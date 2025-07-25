// lib/services/database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/campaign_model.dart';
import '../models/review_submission_model.dart';
import '../models/wallet_transaction_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Campaign operations
  Future<String> createCampaign(CampaignModel campaign) async {
    try {
      DocumentReference doc = await _firestore
          .collection('campaigns')
          .add(campaign.toMap());
      return doc.id;
    } catch (e) {
      print('Create campaign error: $e');
      rethrow;
    }
  }

  Stream<List<CampaignModel>> getActiveCampaigns({
    int? limit,
    String? lastDocId,
  }) {
    Query query = _firestore
        .collection('campaigns')
        .where('status', isEqualTo: 'active')
        .where('deadline', isGreaterThan: DateTime.now().millisecondsSinceEpoch)
        .orderBy('deadline')
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => CampaignModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Stream<List<CampaignModel>> getCompanyCampaigns(String companyId) {
    return _firestore
        .collection('campaigns')
        .where('companyId', isEqualTo: companyId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => CampaignModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Future<CampaignModel?> getCampaignById(String campaignId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('campaigns')
          .doc(campaignId)
          .get();

      if (doc.exists) {
        return CampaignModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Get campaign error: $e');
      return null;
    }
  }

  Future<void> updateCampaign(String campaignId, Map<String, dynamic> updates) async {
    try {
      await _firestore
          .collection('campaigns')
          .doc(campaignId)
          .update(updates);
    } catch (e) {
      print('Update campaign error: $e');
      rethrow;
    }
  }

  // Review submission operations
  Future<String> submitReview(ReviewSubmissionModel submission) async {
    try {
      DocumentReference doc = await _firestore
          .collection('reviewSubmissions')
          .add(submission.toMap());
      return doc.id;
    } catch (e) {
      print('Submit review error: $e');
      rethrow;
    }
  }

  Stream<List<ReviewSubmissionModel>> getUserSubmissions(String userId) {
    return _firestore
        .collection('reviewSubmissions')
        .where('userId', isEqualTo: userId)
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ReviewSubmissionModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Stream<List<ReviewSubmissionModel>> getCampaignSubmissions(String campaignId) {
    return _firestore
        .collection('reviewSubmissions')
        .where('campaignId', isEqualTo: campaignId)
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ReviewSubmissionModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Future<void> updateSubmissionStatus({
    required String submissionId,
    required SubmissionStatus status,
    String? reviewMessage,
  }) async {
    try {
      Map<String, dynamic> updates = {
        'status': status.toString().split('.').last,
        'reviewedAt': DateTime.now().millisecondsSinceEpoch,
      };

      if (reviewMessage != null) {
        updates['reviewMessage'] = reviewMessage;
      }

      await _firestore
          .collection('reviewSubmissions')
          .doc(submissionId)
          .update(updates);
    } catch (e) {
      print('Update submission status error: $e');
      rethrow;
    }
  }

  // Wallet operations
  Future<void> addWalletTransaction(WalletTransactionModel transaction) async {
    try {
      await _firestore
          .collection('walletTransactions')
          .add(transaction.toMap());
    } catch (e) {
      print('Add wallet transaction error: $e');
      rethrow;
    }
  }

  Stream<List<WalletTransactionModel>> getUserTransactions(String userId) {
    return _firestore
        .collection('walletTransactions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => WalletTransactionModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Future<void> updateUserWalletBalance(String userId, double newBalance) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'walletBalance': newBalance});
    } catch (e) {
      print('Update wallet balance error: $e');
      rethrow;
    }
  }

  // Search and filter campaigns
  Stream<List<CampaignModel>> searchCampaigns({
    String? searchTerm,
    ReviewPlatform? platform,
    double? minPrice,
    double? maxPrice,
  }) {
    Query query = _firestore
        .collection('campaigns')
        .where('status', isEqualTo: 'active')
        .where('deadline', isGreaterThan: DateTime.now().millisecondsSinceEpoch);

    if (platform != null) {
      query = query.where('platform', isEqualTo: platform.toString().split('.').last);
    }

    if (minPrice != null) {
      query = query.where('pricePerReview', isGreaterThanOrEqualTo: minPrice);
    }

    if (maxPrice != null) {
      query = query.where('pricePerReview', isLessThanOrEqualTo: maxPrice);
    }

    return query.snapshots().map((snapshot) {
      List<CampaignModel> campaigns = snapshot.docs
          .map((doc) => CampaignModel.fromMap(
          doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Client-side search for title/description if searchTerm provided
      if (searchTerm != null && searchTerm.isNotEmpty) {
        campaigns = campaigns.where((campaign) =>
        campaign.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
            campaign.description.toLowerCase().contains(searchTerm.toLowerCase())
        ).toList();
      }

      return campaigns;
    });
  }
}