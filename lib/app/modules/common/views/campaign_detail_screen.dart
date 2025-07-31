// lib/app/modules/campaign_detail/campaign_detail_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/campaign_model.dart';
import '../../../data/services/storage_service.dart';

class CampaignDetailController extends GetxController {
  late CampaignModel campaign;
  final currentUser = Rxn<Map<String, dynamic>>();
  final userReviews = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    campaign = Get.arguments as CampaignModel;
    currentUser.value = StorageService.to.getCurrentUser();
    fetchUserReviews();
  }

  Future<void> fetchUserReviews() async {
    isLoading.value = true;
    try {
      final user = currentUser.value;
      if (user == null) return;
      userReviews.value = await StorageService.to.getReviews(
        campaignId: campaign.id,
        userId: user['id'],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitProof(String proofLink) async {
    final user = currentUser.value;
    if (user == null) return;

    final review = {
      'userId': user['id'],
      'campaignId': campaign.id,
      'proofLink': proofLink,
    };

    final success = await StorageService.to.submitReview(review);
    if (success) {
      Get.snackbar('Success', 'Review submitted');
      fetchUserReviews();
    } else {
      Get.snackbar('Error', 'Failed to submit');
    }
  }

  Future<void> approveReview(String reviewId) async {
    final success = await StorageService.to.updateReviewStatus(reviewId, 'approved');
    if (success) {
      Get.snackbar('Success', 'Review approved');
      fetchUserReviews();
    }
  }

  Future<void> rejectReview(String reviewId) async {
    final success = await StorageService.to.updateReviewStatus(reviewId, 'rejected');
    if (success) {
      Get.snackbar('Success', 'Review rejected');
      fetchUserReviews();
    }
  }
}

class CampaignDetailView extends StatelessWidget {
  final CampaignDetailController controller = Get.put(CampaignDetailController());

  @override
  Widget build(BuildContext context) {
    final user = controller.currentUser.value;
    final role = user?['role'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(controller.campaign.title)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(controller.campaign.description),
              const SizedBox(height: 12),
              Text('Platform: ${controller.campaign.platform}'),
              Text('Business Link: ${controller.campaign.businessLink}'),
              Text('Reward: ₹${controller.campaign.pricePerReview.toStringAsFixed(2)}'),
              const Divider(),
              if (role == 'user') _buildUserActions(),
              if (role == 'company') _buildCompanyActions(),
              if (role == 'admin') _buildAdminActions(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildUserActions() {
    final proofController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: proofController,
          decoration: const InputDecoration(labelText: 'Proof of Review Link'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => controller.submitProof(proofController.text),
          child: const Text('Submit Review'),
        ),
        const SizedBox(height: 12),
        Text('Your Submissions:'),
        ...controller.userReviews.map((r) => ListTile(
          title: Text(r['proofLink']),
          subtitle: Text('Status: ${r['status']}'),
        )),
      ],
    );
  }

  Widget _buildCompanyActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reviews Submitted:'),
        ...controller.userReviews.map((r) => Card(
          child: ListTile(
            title: Text(r['proofLink']),
            subtitle: Text('Status: ${r['status']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () => controller.approveReview(r['id']),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => controller.rejectReview(r['id']),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildAdminActions() {
    return const Text('Admin: view-only for now'); // extend later
  }
}