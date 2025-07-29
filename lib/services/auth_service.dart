// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
//
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   User? get currentUser => _auth.currentUser;
//   Stream<User?> get authStateChanges => _auth.authStateChanges();
//
//   // Register with email and password
//   Future<UserCredential?> registerWithEmail({
//     required String email,
//     required String password,
//     required String name,
//     required UserRole role,
//     String? phone,
//   }) async {
//     try {
//       UserCredential result = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       if (result.user != null) {
//         // Create user document in Firestore
//         await _createUserDocument(
//           userId: result.user!.uid,
//           email: email,
//           name: name,
//           role: role,
//           phone: phone,
//         );
//       }
//
//       return result;
//     } catch (e) {
//       print('Registration error: $e');
//       rethrow;
//     }
//   }
//
//   // Sign in with email and password
//   Future<UserCredential?> signInWithEmail({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential result = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       if (result.user != null) {
//         // Update last login time
//         await _firestore.collection('users').doc(result.user!.uid).update({
//           'lastLogin': DateTime.now().millisecondsSinceEpoch,
//         });
//       }
//
//       return result;
//     } catch (e) {
//       print('Sign in error: $e');
//       rethrow;
//     }
//   }
//
//   // Phone authentication (OTP)
//   Future<void> verifyPhoneNumber({
//     required String phoneNumber,
//     required Function(PhoneAuthCredential) verificationCompleted,
//     required Function(FirebaseAuthException) verificationFailed,
//     required Function(String, int?) codeSent,
//     required Function(String) codeAutoRetrievalTimeout,
//   }) async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: verificationCompleted,
//       verificationFailed: verificationFailed,
//       codeSent: codeSent,
//       codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//     );
//   }
//
//   // Verify OTP and sign in
//   Future<UserCredential?> signInWithOTP({
//     required String verificationId,
//     required String smsCode,
//   }) async {
//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: smsCode,
//       );
//
//       return await _auth.signInWithCredential(credential);
//     } catch (e) {
//       print('OTP verification error: $e');
//       rethrow;
//     }
//   }
//
//   // Get current user data
//   Future<UserModel?> getCurrentUserData() async {
//     try {
//       if (currentUser == null) return null;
//
//       DocumentSnapshot doc = await _firestore
//           .collection('users')
//           .doc(currentUser!.uid)
//           .get();
//
//       if (doc.exists) {
//         return UserModel.fromMap(
//           doc.data() as Map<String, dynamic>,
//           doc.id,
//         );
//       }
//       return null;
//     } catch (e) {
//       print('Get user data error: $e');
//       return null;
//     }
//   }
//
//   // Sign out
//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//     } catch (e) {
//       print('Sign out error: $e');
//       rethrow;
//     }
//   }
//
//   // Create user document in Firestore
//   Future<void> _createUserDocument({
//     required String userId,
//     required String email,
//     required String name,
//     required UserRole role,
//     String? phone,
//   }) async {
//     UserModel user = UserModel(
//       id: userId,
//       email: email,
//       name: name,
//       role: role,
//       phone: phone,
//       createdAt: DateTime.now(),
//     );
//
//     await _firestore.collection('users').doc(userId).set(user.toMap());
//   }
//
//   // Update user profile
//   Future<void> updateUserProfile({
//     String? name,
//     String? phone,
//     String? profileImageUrl,
//   }) async {
//     try {
//       if (currentUser == null) throw Exception('No user signed in');
//
//       Map<String, dynamic> updates = {};
//       if (name != null) updates['name'] = name;
//       if (phone != null) updates['phone'] = phone;
//       if (profileImageUrl != null) updates['profileImageUrl'] = profileImageUrl;
//
//       if (updates.isNotEmpty) {
//         await _firestore
//             .collection('users')
//             .doc(currentUser!.uid)
//             .update(updates);
//       }
//     } catch (e) {
//       print('Update profile error: $e');
//       rethrow;
//     }
//   }
//
//   // Reset password
//   Future<void> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//     } catch (e) {
//       print('Reset password error: $e');
//       rethrow;
//     }
//   }
// }