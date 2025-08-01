// lib/app/data/services/wallet_service.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WalletService extends GetxService {
  static WalletService get to => Get.find();
  late GetStorage _box;

  Future<WalletService> init() async {
    _box = GetStorage();
    return this;
  }

  // Company Wallet Operations
  Future<bool> fundCampaign(String companyId, String campaignId, double amount) async {
    final campaigns = List<Map<String, dynamic>>.from(_box.read('campaigns') ?? []);
    final campaignIndex = campaigns.indexWhere((c) => c['id'] == campaignId);

    if (campaignIndex == -1) return false;

    // Move funds to escrow
    campaigns[campaignIndex]['escrowAmount'] = amount;
    campaigns[campaignIndex]['escrowUsed'] = 0.0;
    await _box.write('campaigns', campaigns);

    // Record transaction
    await _addTransaction(companyId, -amount, 'Campaign Funding', campaignId);
    return true;
  }

  Future<bool> processReviewPayment(String campaignId, String userId, double amount) async {
    final campaigns = List<Map<String, dynamic>>.from(_box.read('campaigns') ?? []);
    final campaignIndex = campaigns.indexWhere((c) => c['id'] == campaignId);

    if (campaignIndex == -1) return false;

    final campaign = campaigns[campaignIndex];
    final escrowAmount = campaign['escrowAmount'] ?? 0.0;
    final escrowUsed = campaign['escrowUsed'] ?? 0.0;

    if (escrowUsed + amount > escrowAmount) return false; // Insufficient escrow

    // Deduct from escrow, credit to user
    campaigns[campaignIndex]['escrowUsed'] = escrowUsed + amount;
    await _box.write('campaigns', campaigns);

    await _updateUserWallet(userId, amount);
    await _addTransaction(userId, amount, 'Review Approved', campaignId);
    return true;
  }

  Future<bool> refundUnusedEscrow(String campaignId) async {
    final campaigns = List<Map<String, dynamic>>.from(_box.read('campaigns') ?? []);
    final campaignIndex = campaigns.indexWhere((c) => c['id'] == campaignId);

    if (campaignIndex == -1) return false;

    final campaign = campaigns[campaignIndex];
    final escrowAmount = campaign['escrowAmount'] ?? 0.0;
    final escrowUsed = campaign['escrowUsed'] ?? 0.0;
    final refundAmount = escrowAmount - escrowUsed;

    if (refundAmount > 0) {
      await _updateUserWallet(campaign['companyId'], refundAmount);
      await _addTransaction(campaign['companyId'], refundAmount, 'Escrow Refund', campaignId);
      campaigns[campaignIndex]['status'] = 'completed';
      await _box.write('campaigns', campaigns);
    }
    return true;
  }

  // User Wallet Operations
  Future<bool> withdrawFunds(String userId, double amount) async {
    final user = await _getUser(userId);
    if (user == null || (user['wallet'] ?? 0.0) < amount || amount < 10) return false;

    await _updateUserWallet(userId, -amount);
    await _addTransaction(userId, -amount, 'Withdrawal', '');
    return true;
  }

  Future<double> getUserBalance(String userId) async {
    final user = await _getUser(userId);
    return user?['wallet'] ?? 0.0;
  }

  Future<List<Map<String, dynamic>>> getUserTransactions(String userId) async {
    final transactions = List<Map<String, dynamic>>.from(_box.read('transactions') ?? []);
    return transactions.where((t) => t['userId'] == userId).toList();
  }

  // Helper Methods
  Future<void> _updateUserWallet(String userId, double amount) async {
    final users = List<Map<String, dynamic>>.from(_box.read('users') ?? []);
    final userIndex = users.indexWhere((u) => u['id'] == userId);

    if (userIndex != -1) {
      users[userIndex]['wallet'] = (users[userIndex]['wallet'] ?? 0.0) + amount;
      await _box.write('users', users);
    }
  }

  Future<Map<String, dynamic>?> _getUser(String userId) async {
    final users = List<Map<String, dynamic>>.from(_box.read('users') ?? []);
    return users.firstWhereOrNull((u) => u['id'] == userId);
  }

  Future<void> _addTransaction(String userId, double amount, String type, String campaignId) async {
    final transactions = List<Map<String, dynamic>>.from(_box.read('transactions') ?? []);
    transactions.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'userId': userId,
      'amount': amount,
      'type': type,
      'campaignId': campaignId,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await _box.write('transactions', transactions);
  }
}