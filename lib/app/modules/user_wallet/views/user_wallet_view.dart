// lib/app/modules/user/views/user_wallet_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_wallet_controller.dart';

class UserWalletView extends GetView<UserWalletController> {
  const UserWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Wallet')),
      body: RefreshIndicator(
        onRefresh: controller.loadWalletData,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _balanceCard(context),
              const SizedBox(height: 20),
              _withdrawalCard(context),
              const SizedBox(height: 20),
              Text(
                'Transaction History',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...controller.transactions.map((t) => _transactionTile(t)),
            ],
          );
        }),
      ),
    );
  }

  Widget _balanceCard(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(
            Icons.account_balance_wallet,
            size: 48,
            color: Colors.green,
          ),
          const SizedBox(height: 10),
          Text(
            'Available Balance',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            '₹${controller.balance.value.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _withdrawalCard(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Withdraw Funds',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller.withdrawController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount (Min: ₹10)',
              border: OutlineInputBorder(),
              prefixText: '₹',
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.withdraw,
              child: const Text('Withdraw to UPI'),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _transactionTile(Map<String, dynamic> t) => ListTile(
    leading: Icon(
      t['amount'] > 0 ? Icons.add_circle : Icons.remove_circle,
      color: t['amount'] > 0 ? Colors.green : Colors.red,
    ),
    title: Text(t['type']),
    subtitle: Text(DateTime.parse(t['timestamp']).toString().split('.')[0]),
    trailing: Text(
      '${t['amount'] > 0 ? '+' : ''}₹${t['amount'].toStringAsFixed(2)}',
      style: TextStyle(
        color: t['amount'] > 0 ? Colors.green : Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
