// lib/services/storage_service.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class StorageService {
  static const String _keyUsers = 'users';
  static const String _keyCurrentUser = 'current_user';
  static const String _keyRememberMe = 'remember_me';
  static const String _keyRememberedEmail = 'remembered_email';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // User storage with password
  static Future<bool> saveUserWithPassword(UserModel user, String password) async {
    await init();

    // Get existing users
    Map<String, dynamic> users = await _getAllUsers();

    // Create user data with password
    Map<String, dynamic> userData = user.toMap();
    userData['password'] = password; // Store password for demo purposes

    // Save user
    users[user.email] = userData;

    return await _prefs!.setString(_keyUsers, json.encode(users));
  }

  // Update existing user
  static Future<bool> updateUser(UserModel user) async {
    await init();

    // Get existing users
    Map<String, dynamic> users = await _getAllUsers();

    if (users.containsKey(user.email)) {
      // Keep existing password
      String existingPassword = users[user.email]['password'] ?? '';
      Map<String, dynamic> userData = user.toMap();
      userData['password'] = existingPassword;

      users[user.email] = userData;
      return await _prefs!.setString(_keyUsers, json.encode(users));
    }

    return false;
  }

  // Update user password
  static Future<bool> updateUserPassword(String email, String newPassword) async {
    await init();

    Map<String, dynamic> users = await _getAllUsers();

    if (users.containsKey(email)) {
      users[email]['password'] = newPassword;
      return await _prefs!.setString(_keyUsers, json.encode(users));
    }

    return false;
  }

  // Get all users as Map
  static Future<Map<String, dynamic>> _getAllUsers() async {
    await init();
    String? usersJson = _prefs?.getString(_keyUsers);
    if (usersJson != null && usersJson.isNotEmpty) {
      try {
        return Map<String, dynamic>.from(json.decode(usersJson));
      } catch (e) {
        print('Error parsing users data: $e');
        return {};
      }
    }
    return {};
  }

  static Future<UserModel?> getUserByEmail(String email) async {
    Map<String, dynamic> users = await _getAllUsers();

    if (users.containsKey(email)) {
      Map<String, dynamic> userData = Map<String, dynamic>.from(users[email]);
      return UserModel.fromMap(userData, userData['id']);
    }

    return null;
  }

  static Future<UserModel?> getUserByEmailAndPassword(
      String email,
      String password,
      ) async {
    Map<String, dynamic> users = await _getAllUsers();

    if (users.containsKey(email)) {
      Map<String, dynamic> userData = Map<String, dynamic>.from(users[email]);
      if (userData['password'] == password) {
        return UserModel.fromMap(userData, userData['id']);
      }
    }

    return null;
  }

  // Current user session
  static Future<bool> setCurrentUser(UserModel user) async {
    await init();
    return await _prefs!.setString(_keyCurrentUser, user.toJson());
  }

  static Future<UserModel?> getCurrentUser() async {
    await init();
    String? userJson = _prefs!.getString(_keyCurrentUser);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        return UserModel.fromJson(userJson);
      } catch (e) {
        print('Error parsing current user: $e');
        return null;
      }
    }
    return null;
  }

  static Future<bool> clearCurrentUser() async {
    await init();
    return await _prefs!.remove(_keyCurrentUser);
  }

  // Remember me functionality
  static Future<bool> setRememberMe(bool remember, String? email) async {
    await init();
    await _prefs!.setBool(_keyRememberMe, remember);
    if (remember && email != null) {
      await _prefs!.setString(_keyRememberedEmail, email);
    } else {
      await _prefs!.remove(_keyRememberedEmail);
    }
    return true;
  }

  static Future<bool> getRememberMe() async {
    await init();
    return _prefs!.getBool(_keyRememberMe) ?? false;
  }

  static Future<String?> getRememberedEmail() async {
    await init();
    return _prefs!.getString(_keyRememberedEmail);
  }

  // Get all registered emails (for forgot password functionality)
  static Future<List<String>> getAllRegisteredEmails() async {
    Map<String, dynamic> users = await _getAllUsers();
    return users.keys.toList();
  }

  // Clear all data
  static Future<bool> clearAll() async {
    await init();
    return await _prefs!.clear();
  }

  // Debug function to see all users
  static Future<void> debugPrintAllUsers() async {
    Map<String, dynamic> users = await _getAllUsers();
    print('All users: ${json.encode(users)}');
  }
}