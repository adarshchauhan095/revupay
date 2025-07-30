
// lib/app/data/services/storage_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'dart:math';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  late GetStorage _box;

  Future<StorageService> init() async {
    _box = GetStorage();
    await _initializeData();
    return this;
  }

  Future<void> _initializeData() async {
    if (_box.read('users') == null) {
      await _seedInitialData();
    }
  }

  Future<void> _seedInitialData() async {
    final users = [
      {
        'id': '1',
        'email': 'company@gmail.com',
        'phone': '9876543210',
        'password': 'Yopmail@123',
        'role': 'company',
        'name': 'Test Company',
        'wallet': 0.0,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '2',
        'email': 'user@gmail.com',
        'phone': '9876543211',
        'password': 'Yopmail@123',
        'role': 'user',
        'name': 'Test User',
        'wallet': 0.0,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '3',
        'email': 'admin@gmail.com',
        'phone': '9876543212',
        'password': 'Yopmail@123',
        'role': 'admin',
        'name': 'Admin',
        'wallet': 0.0,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ];

    await _box.write('users', users);
    await _box.write('campaigns', []);
    await _box.write('reviews', []);
    await _box.write('transactions', []);
  }

  // Authentication methods
  Future<Map<String, dynamic>?> login(String identifier, String password) async {
    await Future.delayed(Duration(seconds: 1));

    final users = List<Map<String, dynamic>>.from(_box.read('users') ?? []);
    print("ALL USERS: $users");

    final user = users.firstWhere(
          (u) => (u['email'] == identifier || u['phone'] == identifier),
      orElse: () => {},
    );

    print("MATCHED USER: $user");

    if (user.isEmpty) return null;
    if (user['password'] != password) {
      print("Password mismatch: expected ${user['password']}, got $password");
      return null;
    }

    return user;
  }


  Future<bool> register(Map<String, dynamic> userData) async {
    await Future.delayed(Duration(seconds: 1));

    final users = List<Map<String, dynamic>>.from(_box.read('users') ?? []);
    userData['id'] = _generateId();
    // userData['createdAt'] = DateTime.now().toIso8601String();
    // userData['wallet'] = 0.0;

    users.add(userData);
    await _box.write('users', users);
    return true;
  }

  // Campaign methods

  /// Optional: fetch **all** campaigns (admin)
  Future<List<Map<String, dynamic>>> getCampaigns({bool all = false, String? userId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final list = List<Map<String, dynamic>>.from(_box.read('campaigns') ?? []);
    if (all)      return list;
    if (userId != null) return list.where((c) => c['companyId'] == userId).toList();
    return list.where((c) => c['status'] == 'active').toList();
  }

  Future<bool> createCampaign(Map<String, dynamic> campaign) async {
    await Future.delayed(Duration(seconds: 1));

    final campaigns = List<Map<String, dynamic>>.from(_box.read('campaigns') ?? []);
    campaign['id'] = _generateId();
    campaign['createdAt'] = DateTime.now().toIso8601String();
    campaign['status'] = 'active';
    campaign['reviewsSubmitted'] = 0;

    campaigns.add(campaign);
    await _box.write('campaigns', campaigns);
    return true;
  }

  // Review methods
  Future<bool> submitReview(Map<String, dynamic> review) async {
    await Future.delayed(Duration(seconds: 1));

    final reviews = List<Map<String, dynamic>>.from(_box.read('reviews') ?? []);
    review['id'] = _generateId();
    review['submittedAt'] = DateTime.now().toIso8601String();
    review['status'] = 'pending';

    reviews.add(review);
    await _box.write('reviews', reviews);

    // Update campaign review count
    final campaigns = List<Map<String, dynamic>>.from(_box.read('campaigns') ?? []);
    final campaignIndex = campaigns.indexWhere((c) => c['id'] == review['campaignId']);
    if (campaignIndex != -1) {
      campaigns[campaignIndex]['reviewsSubmitted']++;
      await _box.write('campaigns', campaigns);
    }

    return true;
  }

  Future<List<Map<String, dynamic>>> getReviews({String? campaignId, String? userId}) async {
    await Future.delayed(Duration(milliseconds: 500));

    final reviews = List<Map<String, dynamic>>.from(_box.read('reviews') ?? []);
    if (campaignId != null) {
      return reviews.where((r) => r['campaignId'] == campaignId).toList();
    }
    if (userId != null) {
      return reviews.where((r) => r['userId'] == userId).toList();
    }
    return reviews;
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }

  // User management
  Map<String, dynamic>? getCurrentUser() {
    return _box.read('currentUser');
  }

  Future<void> setCurrentUser(Map<String, dynamic> user) async {
    try {
      if (user == null) {
        throw Exception('Trying to save null user!');
      }
      await _box.write('currentUser', user);
    } catch (e) {
      debugPrint('setCurrentUser Error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _box.remove('currentUser');
  }

  /* ==== NEW (admin helpers) ==== */

  Future<List<Map<String, dynamic>>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<Map<String, dynamic>>.from(_box.read('users') ?? []);
  }

  Future<bool> updateReviewStatus(String id, String status) async {
    final reviews = List<Map<String, dynamic>>.from(_box.read('reviews') ?? []);
    final idx = reviews.indexWhere((r) => r['id'] == id);
    if (idx == -1) return false;
    reviews[idx]['status'] = status;
    await _box.write('reviews', reviews);
    return true;
  }

}
