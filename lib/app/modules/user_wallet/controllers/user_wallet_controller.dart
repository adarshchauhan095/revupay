import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/storage_service.dart';
import '../../../data/services/wallet_service.dart';

class UserWalletController extends GetxController {
  final balance = 0.0.obs;
  final transactions = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final withdrawController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadWalletData();
  }

  Future<void> loadWalletData() async {
    isLoading.value = true;
    final user = StorageService.to.getCurrentUser();
    if (user != null) {
      balance.value = await WalletService.to.getUserBalance(user['id']);
      transactions.value = await WalletService.to.getUserTransactions(
        user['id'],
      );
    }
    isLoading.value = false;
  }

  Future<void> withdraw() async {
    final amount = double.tryParse(withdrawController.text) ?? 0;
    if (amount < 10) {
      Get.snackbar('Error', 'Minimum withdrawal: ₹10');
      return;
    }
    if (amount > balance.value) {
      Get.snackbar('Error', 'Insufficient balance');
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    await Future.delayed(const Duration(seconds: 2)); // Simulate processing

    final user = StorageService.to.getCurrentUser();
    final success = await WalletService.to.withdrawFunds(user!['id'], amount);

    Get.back(); // Close dialog

    if (success) {
      withdrawController.clear();
      loadWalletData();
      Get.snackbar('Success', 'Withdrawal successful! 💰');
    } else {
      Get.snackbar('Error', 'Withdrawal failed');
    }
  }

  @override
  void onClose() {
    withdrawController.dispose();
    super.onClose();
  }
}
