// lib/services/auth_service_new.dart
import 'dart:convert';
import '../models/user_model.dart';
import '../models/api_response.dart';
import 'storage_service.dart';

class AuthService {
  // Simulate API delay
  Future<void> _simulateDelay() async {
    await Future.delayed(Duration(seconds: 1));
  }

  // Register new user
  Future<ApiResponse<UserModel>> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? phone,
  }) async {
    try {
      await _simulateDelay();

      // Check if user already exists
      UserModel? existingUser = await StorageService.getUserByEmail(email);
      if (existingUser != null) {
        return ApiResponse.error('User with this email already exists');
      }

      // Create new user
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        role: role,
        phone: phone,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
        isVerified: true, // Auto-verify for demo
      );

      // Save user with password (in real app, password would be hashed)
      await StorageService.saveUserWithPassword(user, password);
      await StorageService.setCurrentUser(user);

      return ApiResponse.success(user, message: 'Registration successful');
    } catch (e) {
      return ApiResponse.error('Registration failed: ${e.toString()}');
    }
  }

  // Login user
  Future<ApiResponse<UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      await _simulateDelay();

      // Get user by email and password
      UserModel? user = await StorageService.getUserByEmailAndPassword(email, password);

      if (user == null) {
        return ApiResponse.error('Invalid email or password');
      }

      if (!user.isActive) {
        return ApiResponse.error('Account is deactivated');
      }

      // Update last login
      final updatedUser = user.copyWith(lastLogin: DateTime.now());
      await StorageService.updateUser(updatedUser);
      await StorageService.setCurrentUser(updatedUser);

      return ApiResponse.success(updatedUser, message: 'Login successful');
    } catch (e) {
      return ApiResponse.error('Login failed: ${e.toString()}');
    }
  }

  // Reset password
  Future<ApiResponse<bool>> resetPassword(String email) async {
    try {
      await _simulateDelay();

      UserModel? user = await StorageService.getUserByEmail(email);
      if (user == null) {
        return ApiResponse.error('No account found with this email');
      }

      // Generate new temporary password (in real app, send email)
      String tempPassword = 'temp123';
      await StorageService.updateUserPassword(email, tempPassword);

      return ApiResponse.success(true,
          message: 'Password reset successful. Your temporary password is: temp123');
    } catch (e) {
      return ApiResponse.error('Failed to reset password: ${e.toString()}');
    }
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    return await StorageService.getCurrentUser();
  }

  // Logout
  Future<ApiResponse<bool>> logout() async {
    try {
      await StorageService.clearCurrentUser();
      return ApiResponse.success(true, message: 'Logout successful');
    } catch (e) {
      return ApiResponse.error('Logout failed: ${e.toString()}');
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    UserModel? user = await getCurrentUser();
    return user != null;
  }
}