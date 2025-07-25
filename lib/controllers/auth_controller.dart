// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final Rx<User?> _user = Rx<User?>(null);
  final Rx<UserModel?> _currentUserData = Rx<UserModel?>(null);
  final RxBool _isLoading = true.obs;

  User? get currentUser => _user.value;
  UserModel? get currentUserData => _currentUserData.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_authService.authStateChanges);
    ever(_user, _setInitialScreen);
  }

  void _setInitialScreen(User? user) async {
    _isLoading.value = true;

    if (user == null) {
      _currentUserData.value = null;
      _isLoading.value = false;
      return;
    }

    // Get user data from Firestore
    UserModel? userData = await _authService.getCurrentUserData();
    _currentUserData.value = userData;
    _isLoading.value = false;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? phone,
  }) async {
    try {
      _isLoading.value = true;

      UserCredential? result = await _authService.registerWithEmail(
        email: email,
        password: password,
        name: name,
        role: role,
        phone: phone,
      );

      if (result != null) {
        Get.snackbar('Success', 'Account created successfully!');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading.value = true;

      UserCredential? result = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      if (result != null) {
        Get.snackbar('Success', 'Logged in successfully!');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout: ${e.toString()}');
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
      Get.snackbar('Success', 'Password reset email sent!');
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }
}