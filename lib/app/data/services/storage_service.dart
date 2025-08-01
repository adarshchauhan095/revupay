// lib/app/data/services/storage_service.dart - Updated sections only
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'dart:math';
import 'wallet_service.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  late GetStorage _box;

  Future<StorageService> init() async {
    _box = GetStorage();
    await _initializeData();
    return this;
  }

  Future<void> _initializeData() async {
    // Only seed data if no users exist (first time setup)
    if (_box.read('users') == null) {
      await _seedInitialData();
    }
    // Remove the auto-erase to maintain persistent login
  }

  Future<void> _seedInitialData() async {
    final users = [
      {
        'id': '1',
        'email': 'company@gmail.com',
        'phone': '9876543210',
        'password': '123',
        'role': 'company',
        'name': 'Test Company',
        'wallet': 1000.0, // Starting balance for testing
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '2',
        'email': 'user@gmail.com',
        'phone': '9876543211',
        'password': '123',
        'role': 'user',
        'name': 'Test User',
        'wallet': 0.0,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '3',
        'email': 'admin@gmail.com',
        'phone': '9876543212',
        'password': '123',
        'role': 'admin',
        'name': 'Admin',
        'wallet': 0.0,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ];

    final campaigns = [
      {
        'id': 'test_campaign_1',
        'companyId': '1',
        'title': 'Test Google Review Campaign',
        'description': 'Leave a review on our Google Business page',
        'platform': 'Google',
        'businessLink': 'https://google.com/business/test',
        'pricePerReview': 10.0,
        'maxReviews': 50,
        'expiry': DateTime.now().add(Duration(days: 30)).toIso8601String(),
        'status': 'active', // Active so users can see it
        'reviewsSubmitted': 5,
        'escrowAmount': 500.0, // Pre-funded for testing
        'escrowUsed': 50.0,
        'createdAt': DateTime.now().toIso8601String(),
      }
    ];

    await _box.write('users', users);
    await _box.write('campaigns', campaigns);
    await _box.write('reviews', []);
    await _box.write('transactions', []);
  }

  // Updated submitReview with wallet integration
  Future<bool> submitReview(Map<String, dynamic> review) async {
    await Future.delayed(Duration(seconds: 1));

    final reviews = List<Map<String, dynamic>>.from(_box.read('reviews') ?? []);
    review['id'] = _generateId();
    review['submittedAt'] = DateTime.now().toIso8601String();
    review['status'] = 'pending';

    // Store image paths if provided
    if (review['imagePaths'] != null) {
      review['imagePaths'] = List<String>.from(review['imagePaths']);
    }

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

  // Updated review status with wallet payment
  Future<bool> updateReviewStatus(String id, String status) async {
    final reviews = List<Map<String, dynamic>>.from(_box.read('reviews') ?? []);
    final idx = reviews.indexWhere((r) => r['id'] == id);
    if (idx == -1) return false;

    reviews[idx]['status'] = status;
    await _box.write('reviews', reviews);

    // Process payment if approved
    if (status == 'approved') {
      final review = reviews[idx];
      final campaigns = List<Map<String, dynamic>>.from(_box.read('campaigns') ?? []);
      final campaign = campaigns.firstWhereOrNull((c) => c['id'] == review['campaignId']);

      if (campaign != null) {
        await WalletService.to.processReviewPayment(
            campaign['id'],
            review['userId'],
            campaign['pricePerReview'].toDouble()
        );
      }
    }

    return true;
  }

  // Create campaign with funding requirement
  Future<bool> createCampaign(Map<String, dynamic> campaign) async {
    await Future.delayed(Duration(seconds: 1));

    final campaigns = List<Map<String, dynamic>>.from(_box.read('campaigns') ?? []);
    campaign['id'] = _generateId();
    campaign['createdAt'] = DateTime.now().toIso8601String();
    campaign['status'] = 'active'; // Always active
    campaign['reviewsSubmitted'] = 0;
    campaign['escrowAmount'] = 0.0; // Unfunded initially
    campaign['escrowUsed'] = 0.0;

    campaigns.add(campaign);
    await _box.write('campaigns', campaigns);
    return true;
  }

  // Existing methods remain the same...
  Future<Map<String, dynamic>?> login(String identifier, String password) async {
    await Future.delayed(Duration(seconds: 1));
    final users = List<Map<String, dynamic>>.from(_box.read('users') ?? []);
    final user = users.firstWhereOrNull(
          (u) => (u['email'] == identifier || u['phone'] == identifier) && u['password'] == password,
    );
    return user;
  }

  Future<bool> register(Map<String, dynamic> userData) async {
    await Future.delayed(Duration(seconds: 1));
    final users = List<Map<String, dynamic>>.from(_box.read('users') ?? []);
    userData['id'] = _generateId();
    userData['wallet'] = 0.0;
    users.add(userData);
    await _box.write('users', users);
    return true;
  }

  Future<List<Map<String, dynamic>>> getCampaigns({
    bool all = false,
    String? userId,
    String? status,
    String? companyId,
    bool? funded,
    bool? expired,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final list = List<Map<String, dynamic>>.from(_box.read('campaigns') ?? []);

    if (all && userId == null && status == null && companyId == null && funded == null && expired == null) {
      return list; // Return everything if truly all
    }

    return list.where((campaign) {
      // User/Company filter
      if (userId != null && campaign['companyId'] != userId) return false;
      if (companyId != null && campaign['companyId'] != companyId) return false;

      // Status filter
      if (status != null && campaign['status'] != status) return false;

      // Funding filter
      if (funded != null) {
        final escrowAmount = (campaign['escrowAmount'] ?? 0.0).toDouble();
        if (funded && escrowAmount == 0) return false;
        if (!funded && escrowAmount > 0) return false;
      }

      // Expiry filter
      if (expired != null) {
        final expiry = DateTime.parse(campaign['expiry']);
        final isExpired = expiry.isBefore(DateTime.now());
        if (expired && !isExpired) return false;
        if (!expired && isExpired) return false;
      }

      return true;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getReviews({String? campaignId, String? userId}) async {
    await Future.delayed(Duration(milliseconds: 500));
    final reviews = List<Map<String, dynamic>>.from(_box.read('reviews') ?? []);
    if (campaignId != null) return reviews.where((r) => r['campaignId'] == campaignId).toList();
    if (userId != null) return reviews.where((r) => r['userId'] == userId).toList();
    return reviews;
  }

  String _generateId() => DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(1000).toString();

  Map<String, dynamic>? getCurrentUser() => _box.read('currentUser');

  Future<void> setCurrentUser(Map<String, dynamic> user) async {
    await _box.write('currentUser', user);
  }

  Future<void> logout() async {
    await _box.remove('currentUser');
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<Map<String, dynamic>>.from(_box.read('users') ?? []);
  }
}