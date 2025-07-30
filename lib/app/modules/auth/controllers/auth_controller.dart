
// lib/app/modules/auth/controllers/auth_controller.dart
import 'dart:developer';

import 'package:get/get.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final selectedRole = ''.obs;

  void selectRole(String role) {
    selectedRole.value = role;
    Get.toNamed(Routes.LOGIN, arguments: role);
  }

  Future<void> login(String identifier, String password, String role) async {
    isLoading.value = true;

    try {
      final user = await StorageService.to.login(identifier, password);

      if (user == null) {
        Get.snackbar('Error', 'Invalid email/phone or password');
      } else if (user['role'] != role) {
        Get.snackbar('Error', 'Role mismatch');
      } else {
        await StorageService.to.setCurrentUser(user);
        _navigateBasedOnRole(role);
        Get.snackbar('Success', 'Login successful');
      }
    } catch (e) {
      log('Error: Login failed -> ${e.toString()}');
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await StorageService.to.logout();
    Get.offAllNamed(Routes.ROLE_SELECTION);
  }

  void _navigateBasedOnRole(String role) {
    switch (role) {
      case 'company':
        Get.offAllNamed(Routes.COMPANY_DASHBOARD);
        break;
      case 'user':
        Get.offAllNamed(Routes.USER_DASHBOARD);
        break;
      case 'admin':
        Get.offAllNamed(Routes.ADMIN_DASHBOARD);
        break;
    }
  }
}
