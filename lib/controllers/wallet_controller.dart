// lib/controllers/wallet_controller.dart
import 'package:get/get.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/wallet_transaction_model.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import 'auth_controller.dart';

class WalletController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  final RxList<WalletTransactionModel> _transactions = <WalletTransactionModel>[].obs;
  final RxDouble _balance = 0.0.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isWithdrawing = false.obs;

  List<WalletTransactionModel> get transactions => _transactions;
  double get balance => _balance.value;
  bool get isLoading => _isLoading.value;
  bool get isWithdrawing => _isWithdrawing.value;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
    _updateBalanceFromUser();
  }

  void _updateBalanceFromUser() {
    final AuthController authController = Get.find();
    authController.currentUserData.listen((userData) {
      if (userData != null) {
        _balance.value = userData.walletBalance;
      }
    });
  }

  Future<void> loadTransactions() async {
    try {
      _isLoading.value = true;
      final user = _authService.currentUser;

      if (user == null) {
        throw Exception('User not authenticated');
      }

      _databaseService.getUserTransactions(user.uid).listen((transactions) {
        _transactions.value = transactions;

        // Calculate balance from transactions
        double calculatedBalance = 0.0;
        for (var transaction in transactions) {
          if (transaction.status == TransactionStatus.completed) {
            if (transaction.type == TransactionType.credit) {
              calculatedBalance += transaction.amount;
            } else {
              calculatedBalance -= transaction.amount;
            }
          }
        }

        // Update balance if it differs significantly
        if ((_balance.value - calculatedBalance).abs() > 0.01) {
          _balance.value = calculatedBalance;
        }
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to load transactions: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshTransactions() async {
    await loadTransactions();
  }

  Future<bool> requestWithdrawal(double amount, String upiId, {Map<String, dynamic>? bankDetails}) async {
    try {
      _isWithdrawing.value = true;

      if (amount < 10) {
        Get.snackbar('Error', 'Minimum withdrawal amount is ₹10');
        return false;
      }

      if (_balance.value < amount) {
        Get.snackbar('Error', 'Insufficient balance');
        return false;
      }

      final user = _authService.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not authenticated');
        return false;
      }

      // Call cloud function to process withdrawal
      final HttpsCallable callable = _functions.httpsCallable('processWithdrawal');

      final result = await callable.call({
        'amount': amount,
        'upiId': upiId.isNotEmpty ? upiId : null,
        'bankDetails': bankDetails,
      });

      if (result.data['success'] == true) {
        Get.snackbar('Success', 'Withdrawal request submitted successfully');

        // Update local balance
        _balance.value = result.data['newBalance'].toDouble();

        // Refresh transactions to show the new withdrawal
        await refreshTransactions();

        return true;
      } else {
        Get.snackbar('Error', result.data['message'] ?? 'Withdrawal failed');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Withdrawal failed: ${e.toString()}');
      return false;
    } finally {
      _isWithdrawing.value = false;
    }
  }

  Future<bool> claimDailyBonus() async {
    try {
      final user = _authService.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not authenticated');
        return false;
      }

      final HttpsCallable callable = _functions.httpsCallable('processDailyLoginBonus');
      final result = await callable.call();

      if (result.data['success'] == true) {
        Get.snackbar('Success', result.data['message']);

        // Update local balance
        _balance.value = result.data['newBalance'].toDouble();

        // Refresh transactions
        await refreshTransactions();

        return true;
      } else {
        Get.snackbar('Info', result.data['message']);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to claim bonus: ${e.toString()}');
      return false;
    }
  }

  // Get transactions by type
  List<WalletTransactionModel> getTransactionsByType(TransactionType type) {
    return _transactions.where((t) => t.type == type).toList();
  }

  // Get transactions by status
  List<WalletTransactionModel> getTransactionsByStatus(TransactionStatus status) {
    return _transactions.where((t) => t.status == status).toList();
  }

  // Get earnings from reviews
  double get totalEarnings {
    return _transactions
        .where((t) => t.type == TransactionType.credit &&
        t.status == TransactionStatus.completed &&
        t.description.contains('Review approved'))
        .map((t) => t.amount)
        .fold(0.0, (sum, amount) => sum + amount);
  }

  // Get total withdrawals
  double get totalWithdrawals {
    return _transactions
        .where((t) => t.type == TransactionType.debit &&
        t.status == TransactionStatus.completed)
        .map((t) => t.amount)
        .fold(0.0, (sum, amount) => sum + amount);
  }

  // Get pending withdrawals
  double get pendingWithdrawals {
    return _transactions
        .where((t) => t.type == TransactionType.debit &&
        t.status == TransactionStatus.pending)
        .map((t) => t.amount)
        .fold(0.0, (sum, amount) => sum + amount);
  }

  // Check if user can withdraw
  bool canWithdraw(double amount) {
    return _balance.value >= amount && amount >= 10;
  }

  // Get transaction statistics
  Map<String, dynamic> getTransactionStats() {
    return {
      'totalTransactions': _transactions.length,
      'totalEarnings': totalEarnings,
      'totalWithdrawals': totalWithdrawals,
      'pendingWithdrawals': pendingWithdrawals,
      'currentBalance': _balance.value,
      'completedTransactions': _transactions.where((t) => t.status == TransactionStatus.completed).length,
      'pendingTransactions': _transactions.where((t) => t.status == TransactionStatus.pending).length,
    };
  }

  // Format amount for display
  String formatAmount(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  // Get recent transactions (last 10)
  List<WalletTransactionModel> get recentTransactions {
    final sorted = List<WalletTransactionModel>.from(_transactions)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(10).toList();
  }
}