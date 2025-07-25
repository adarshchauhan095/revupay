// lib/screens/user/wallet_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/wallet_controller.dart';
import '../../widgets/transaction_card.dart';

class WalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WalletController walletController = Get.put(WalletController());

    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => walletController.refreshTransactions(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Balance Card
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[600]!, Colors.blue[800]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Balance',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Obx(() => Text(
                  '₹${walletController.balance.value.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: walletController.balance.value >= 10
                      ? () => _showWithdrawDialog(context, walletController)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[800],
                  ),
                  child: Text('Withdraw Money'),
                ),
              ],
            ),
          ),

          // Transactions List
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: Obx(() {
                      if (walletController.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (walletController.transactions.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No transactions yet',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                'Complete reviews to earn money!',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: walletController.transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = walletController.transactions[index];
                          return TransactionCard(transaction: transaction);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, WalletController controller) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController upiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Withdraw Money'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (Min ₹10)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: upiController,
              decoration: InputDecoration(
                labelText: 'UPI ID',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount >= 10 && upiController.text.isNotEmpty) {
                controller.requestWithdrawal(amount, upiController.text);
                Get.back();
              } else {
                Get.snackbar('Error', 'Please enter valid details');
              }
            },
            child: Text('Withdraw'),
          ),
        ],
      ),
    );
  }
}