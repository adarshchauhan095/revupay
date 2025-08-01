// lib/app/modules/company/views/fund_campaign_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/campaign_model.dart';
import '../../../data/services/wallet_service.dart';
import '../controllers/company_controller.dart';

class FundCampaignView extends StatelessWidget {
  final CampaignModel campaign = Get.arguments;
  final _selectedMethod = 'UPI'.obs;
  final _upiController = TextEditingController();

  FundCampaignView({super.key});

  @override
  Widget build(BuildContext context) {
    final totalAmount = campaign.pricePerReview * campaign.maxReviews;

    return Scaffold(
      appBar: AppBar(title: const Text('Fund Campaign')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Campaign: ${campaign.title}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${campaign.pricePerReview} × ${campaign.maxReviews} reviews',
                    ),
                    const Divider(),
                    Text(
                      'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Column(
                children: ['UPI', 'Razorpay', 'GPay']
                    .map(
                      (method) => RadioListTile<String>(
                        title: Text(method),
                        value: method,
                        groupValue: _selectedMethod.value,
                        onChanged: (value) => _selectedMethod.value = value!,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _upiController,
              decoration: InputDecoration(
                labelText: 'UPI ID / Payment Details',
                border: const OutlineInputBorder(),
                hintText: _selectedMethod.value == 'UPI'
                    ? 'user@paytm'
                    : 'Payment details',
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _processFunding(totalAmount),
                child: Text('Pay ₹${totalAmount.toStringAsFixed(2)}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processFunding(double amount) async {
    if (_upiController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter payment details');
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    final success = await WalletService.to.fundCampaign(
      campaign.companyId,
      campaign.id,
      amount,
    );

    Get.back(); // Close loading

    if (success) {
      Get.back(); // Return to dashboard
      Get.find<CompanyController>().loadCampaigns();
      Get.snackbar('Success', 'Campaign funded successfully! ✅');
    } else {
      Get.snackbar('Error', 'Payment failed. Please try again.');
    }
  }
}
