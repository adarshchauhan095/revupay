const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

// Process review submission approval/rejection
exports.processReviewSubmission = functions.firestore
  .document('reviewSubmissions/{submissionId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    // Check if status changed from pending to approved
    if (before.status === 'pending' && after.status === 'approved') {
      const submissionId = context.params.submissionId;
      const userId = after.userId;
      const campaignId = after.campaignId;
      const amount = after.amount;

      try {
        // Get user and campaign data
        const [userDoc, campaignDoc] = await Promise.all([
          db.collection('users').doc(userId).get(),
          db.collection('campaigns').doc(campaignId).get()
        ]);

        if (!userDoc.exists || !campaignDoc.exists) {
          throw new Error('User or campaign not found');
        }

        const userData = userDoc.data();
        const campaignData = campaignDoc.data();

        // Update user wallet balance
        const newBalance = (userData.walletBalance || 0) + amount;

        // Create wallet transaction
        const transaction = {
          userId: userId,
          type: 'credit',
          amount: amount,
          description: `Review approved for: ${campaignData.title}`,
          campaignId: campaignId,
          submissionId: submissionId,
          status: 'completed',
          createdAt: admin.firestore.FieldValue.serverTimestamp()
        };

        // Update campaign completed reviews count
        const newCompletedReviews = (campaignData.completedReviews || 0) + 1;

        // Batch update
        const batch = db.batch();

        // Update user balance
        batch.update(userDoc.ref, { walletBalance: newBalance });

        // Add wallet transaction
        batch.create(db.collection('walletTransactions').doc(), transaction);

        // Update campaign
        batch.update(campaignDoc.ref, {
          completedReviews: newCompletedReviews,
          status: newCompletedReviews >= campaignData.totalReviewsNeeded ? 'completed' : 'active'
        });

        await batch.commit();

        // Send notification to user
        await sendNotificationToUser(userId, {
          title: 'Review Approved!',
          body: `Your review has been approved. ₹${amount} added to your wallet.`,
          data: {
            type: 'review_approved',
            submissionId: submissionId,
            amount: amount.toString()
          }
        });

        console.log(`Successfully processed approval for submission: ${submissionId}`);

      } catch (error) {
        console.error('Error processing review submission:', error);

        // Revert submission status on error
        await change.after.ref.update({
          status: 'pending',
          reviewMessage: 'Processing failed. Please contact support.'
        });
      }
    }
  });

// Auto-approve submissions after deadline
exports.autoApproveSubmissions = functions.pubsub
  .schedule('every 1 hours')
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    const autoApprovalTime = new Date(now.toDate().getTime() - (48 * 60 * 60 * 1000)); // 48 hours ago

    try {
      // Find pending submissions older than 48 hours
      const pendingSubmissions = await db
        .collection('reviewSubmissions')
        .where('status', '==', 'pending')
        .where('submittedAt', '<=', autoApprovalTime)
        .get();

      const batch = db.batch();
      const updates = [];

      for (const doc of pendingSubmissions.docs) {
        const submission = doc.data();

        // Check if campaign has auto-approval enabled
        const campaignDoc = await db.collection('campaigns').doc(submission.campaignId).get();
        const campaignData = campaignDoc.data();

        if (campaignData && campaignData.autoApproval) {
          batch.update(doc.ref, {
            status: 'approved',
            reviewMessage: 'Auto-approved after 48 hours',
            reviewedAt: admin.firestore.FieldValue.serverTimestamp()
          });

          updates.push({
            submissionId: doc.id,
            userId: submission.userId,
            campaignId: submission.campaignId,
            amount: submission.amount
          });
        }
      }

      if (updates.length > 0) {
        await batch.commit();
        console.log(`Auto-approved ${updates.length} submissions`);
      }

    } catch (error) {
      console.error('Error in auto-approval process:', error);
    }
  });

// Handle withdrawal requests
exports.processWithdrawal = functions.https.onCall(async (data, context) => {
  // Check authentication
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const userId = context.auth.uid;
  const { amount, upiId, bankDetails } = data;

  try {
    // Validate input
    if (!amount || amount < 10) {
      throw new functions.https.HttpsError('invalid-argument', 'Minimum withdrawal amount is ₹10');
    }

    if (!upiId && !bankDetails) {
      throw new functions.https.HttpsError('invalid-argument', 'UPI ID or bank details required');
    }

    // Get user data
    const userDoc = await db.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'User not found');
    }

    const userData = userDoc.data();
    const currentBalance = userData.walletBalance || 0;

    if (currentBalance < amount) {
      throw new functions.https.HttpsError('failed-precondition', 'Insufficient balance');
    }

    // Create withdrawal transaction
    const withdrawalTransaction = {
      userId: userId,
      type: 'debit',
      amount: amount,
      description: 'Withdrawal request',
      status: 'pending',
      withdrawalMethod: upiId ? 'upi' : 'bank',
      withdrawalDetails: upiId ? { upiId } : bankDetails,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    };

    // Update user balance and create transaction
    const newBalance = currentBalance - amount;

    const batch = db.batch();
    batch.update(userDoc.ref, { walletBalance: newBalance });
    batch.create(db.collection('walletTransactions').doc(), withdrawalTransaction);

    await batch.commit();

    // In a real app, integrate with payment gateway for actual transfer
    // For now, we'll simulate the process

    return {
      success: true,
      message: 'Withdrawal request submitted successfully',
      newBalance: newBalance
    };

  } catch (error) {
    console.error('Withdrawal processing error:', error);
    throw error;
  }
});

// Send push notifications
async function sendNotificationToUser(userId, notification) {
  try {
    // Get user's FCM token
    const userDoc = await db.collection('users').doc(userId).get();
    const fcmToken = userDoc.data()?.fcmToken;

    if (fcmToken) {
      const message = {
        token: fcmToken,
        notification: {
          title: notification.title,
          body: notification.body
        },
        data: notification.data || {}
      };

      await admin.messaging().send(message);
    }
  } catch (error) {
    console.error('Error sending notification:', error);
  }
}

// Campaign expiry checker
exports.checkExpiredCampaigns = functions.pubsub
  .schedule('every 24 hours')
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();

    try {
      const expiredCampaigns = await db
        .collection('campaigns')
        .where('status', '==', 'active')
        .where('deadline', '<=', now)
        .get();

      const batch = db.batch();

      for (const doc of expiredCampaigns.docs) {
        batch.update(doc.ref, { status: 'expired' });
      }

      if (!expiredCampaigns.empty) {
        await batch.commit();
        console.log(`Marked ${expiredCampaigns.size} campaigns as expired`);
      }

    } catch (error) {
      console.error('Error checking expired campaigns:', error);
    }
  });

// Daily login bonus
exports.processDailyLoginBonus = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const userId = context.auth.uid;

  try {
    const userDoc = await db.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'User not found');
    }

    const userData = userDoc.data();
    const today = new Date().toDateString();
    const lastBonusDate = userData.lastBonusDate;

    // Check if user already claimed bonus today
    if (lastBonusDate === today) {
      return {
        success: false,
        message: 'Daily bonus already claimed today'
      };
    }

    const bonusAmount = 1.0; // ₹1 daily bonus
    const newBalance = (userData.walletBalance || 0) + bonusAmount;

    // Update user data
    const batch = db.batch();
    batch.update(userDoc.ref, {
      walletBalance: newBalance,
      lastBonusDate: today
    });

    // Create transaction record
    const transaction = {
      userId: userId,
      type: 'credit',
      amount: bonusAmount,
      description: 'Daily login bonus',
      status: 'completed',
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    };

    batch.create(db.collection('walletTransactions').doc(), transaction);

    await batch.commit();

    return {
      success: true,
      message: 'Daily bonus claimed successfully!',
      bonusAmount: bonusAmount,
      newBalance: newBalance
    };

  } catch (error) {
    console.error('Daily bonus error:', error);
    throw error;
  }
});