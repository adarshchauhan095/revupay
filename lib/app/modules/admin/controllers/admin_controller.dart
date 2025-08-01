import 'package:get/get.dart';

import '../../../data/models/campaign_model.dart';
import '../../../data/services/storage_service.dart';

class AdminController extends GetxController {
  final users = <Map<String, dynamic>>[].obs;
  final campaigns = <CampaignModel>[].obs;
  final pendingReviews = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshAll();
  }

  Future<void> refreshAll() async {
    isLoading.value = true;
    try {
      users.value = await StorageService.to.getUsers();
      campaigns.value = (await StorageService.to.getCampaigns(
        all: true,
      )).map((e) => CampaignModel.fromJson(e)).toList();
      pendingReviews.value = (await StorageService.to.getReviews())
          .where((r) => r['status'] == 'pending')
          .toList();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approve(String reviewId) =>
      _setReviewStatus(reviewId, 'approved');

  Future<void> reject(String reviewId) =>
      _setReviewStatus(reviewId, 'rejected');

  Future<void> _setReviewStatus(String id, String status) async {
    await StorageService.to.updateReviewStatus(id, status);
    refreshAll(); // reload lists
  }
}
