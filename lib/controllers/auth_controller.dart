// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service_new.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;

  UserModel? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    _isLoading.value = true;
    _currentUser.value = await _authService.getCurrentUser();
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

      final response = await _authService.register(
        email: email,
        password: password,
        name: name,
        role: role,
        phone: phone,
      );

      if (response.success && response.data != null) {
        _currentUser.value = response.data;
        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.TOP,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Registration failed',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Registration failed: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      _isLoading.value = true;

      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response.success && response.data != null) {
        _currentUser.value = response.data;

        // Handle remember me
        await StorageService.setRememberMe(rememberMe, rememberMe ? email : null);

        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.TOP,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Login failed',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      final response = await _authService.logout();
      if (response.success) {
        _currentUser.value = null;
        Get.offAllNamed('/login');
        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Logout failed: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      final response = await _authService.resetPassword(email);

      if (response.success) {
        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.TOP,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to send reset link',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send reset link: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
  }

  Future<void> loadRememberedCredentials() async {
    final rememberMe = await StorageService.getRememberMe();
    final email = await StorageService.getRememberedEmail();

    if (rememberMe && email != null) {
      // Return the remembered email to populate the form
      Get.find<AuthController>().update(['remembered_email']);
    }
  }
}

// class AuthController extends GetxController {
  // final AuthService _authService = AuthService();
  //
  // final Rx<User?> _user = Rx<User?>(null);
  // final Rx<UserModel?> _currentUserData = Rx<UserModel?>(null);
  // final RxBool _isLoading = true.obs;
  //
  // User? get currentUser => _user.value;
  // UserModel? get currentUserData => _currentUserData.value;
  // bool get isLoading => _isLoading.value;
  //
  // @override
  // void onInit() {
  //   super.onInit();
  //   _user.bindStream(_authService.authStateChanges);
  //   ever(_user, _setInitialScreen);
  // }
  //
  // void _setInitialScreen(User? user) async {
  //   _isLoading.value = true;
  //
  //   if (user == null) {
  //     _currentUserData.value = null;
  //     _isLoading.value = false;
  //     return;
  //   }
  //
  //   // Get user data from Firestore
  //   UserModel? userData = await _authService.getCurrentUserData();
  //   _currentUserData.value = userData;
  //   _isLoading.value = false;
  // }
  //
  // Future<bool> register({
  //   required String email,
  //   required String password,
  //   required String name,
  //   required UserRole role,
  //   String? phone,
  // }) async {
  //   try {
  //     _isLoading.value = true;
  //
  //     UserCredential? result = await _authService.registerWithEmail(
  //       email: email,
  //       password: password,
  //       name: name,
  //       role: role,
  //       phone: phone,
  //     );
  //
  //     if (result != null) {
  //       Get.snackbar('Success', 'Account created successfully!');
  //       return true;
  //     }
  //     return false;
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //     return false;
  //   } finally {
  //     _isLoading.value = false;
  //   }
  // }
  //
  // Future<bool> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     _isLoading.value = true;
  //
  //     UserCredential? result = await _authService.signInWithEmail(
  //       email: email,
  //       password: password,
  //     );
  //
  //     if (result != null) {
  //       Get.snackbar('Success', 'Logged in successfully!');
  //       return true;
  //     }
  //     return false;
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //     return false;
  //   } finally {
  //     _isLoading.value = false;
  //   }
  // }
  //
  // Future<void> logout() async {
  //   try {
  //     await _authService.signOut();
  //     Get.offAllNamed('/login');
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to logout: ${e.toString()}');
  //   }
  // }
  //
  // Future<bool> resetPassword(String email) async {
  //   try {
  //     await _authService.resetPassword(email);
  //     Get.snackbar('Success', 'Password reset email sent!');
  //     return true;
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //     return false;
  //   }
  // }
// }