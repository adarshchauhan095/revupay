import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/campaign_model.dart';

class CompanyCampaignController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<CampaignModel> companyCampaigns = <CampaignModel>[].obs;

  Future<void> refreshCampaigns() async {
    // Simulate refresh
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    isLoading.value = false;
  }

  void viewCampaignDetails(CampaignModel campaign) {
    // Handle viewing campaign
  }

  void pauseCampaign(String campaignId) {
    // Handle pausing
  }

  void resumeCampaign(String campaignId) {
    // Handle resuming
  }


  final RxMap<String, dynamic> dashboardStats = <String, dynamic>{}.obs;


  Future<void> refreshDashboard() async {
    // await fetchDashboardStats();
    await fetchCompanyCampaigns();
  }

  void fetchDashboardStats() {
    dashboardStats.value = {
      'activeCampaigns': 4,
      'totalReviews': 120,
      'pendingReviews': 10,
      'totalSpent': 1500.50,
    };
  }

  Future<List<String>> uploadCampaignImages(List<XFile> images) async {
    // Simulate image upload and return dummy URLs
    await Future.delayed(Duration(seconds: 2));
    return images.map((img) => 'https://example.com/uploads/${img.name}').toList();
  }

  Future<void> createCampaign({
    required String title,
    required String description,
    required String requirements,
    required ReviewPlatform platform,
    required String businessLink,
    required double pricePerReview,
    required int totalReviewsNeeded,
    required DateTime deadline,
    required List<String> mediaUrls,
    required bool autoApproval,
    required int autoApprovalHours,
  }) async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));

    final newCampaign = CampaignModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      companyId: 'company123',
      title: title,
      description: description,
      requirements: [requirements],
      platform: platform,
      platformUrl: businessLink,
      pricePerReview: pricePerReview,
      totalReviewsNeeded: totalReviewsNeeded,
      completedReviews: 0,
      status: CampaignStatus.active,
      deadline: deadline,
      createdAt: DateTime.now(),
      tags: [],
      additionalInfo: {},
      autoApproval: autoApproval,
      imageUrl: mediaUrls.isNotEmpty ? mediaUrls.first : null,
      totalBudget: pricePerReview * totalReviewsNeeded,
      spentBudget: 0.0,
    );

    companyCampaigns.add(newCampaign);
    isLoading.value = false;

    Get.snackbar('Campaign Created', 'Your campaign has been created successfully.');
  }


  Future<void> fetchCompanyCampaigns() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1)); // simulate delay
    companyCampaigns.value = [
      CampaignModel(
        id: '1',
        companyId: 'company123',
        title: 'Google Review Drive',
        description: 'Collect Google reviews from satisfied customers.',
        platform: ReviewPlatform.google,
        platformUrl: 'https://google.com/my-business',
        pricePerReview: 20.0,
        totalReviewsNeeded: 100,
        completedReviews: 30,
        status: CampaignStatus.active,
        deadline: DateTime.now().add(Duration(days: 10)),
        createdAt: DateTime.now().subtract(Duration(days: 5)),
        requirements: ['Verified Purchase', 'Minimum 100 words'],
        tags: ['Google', 'Reviews', 'Marketing'],
        additionalInfo: {'targetDemographic': '18-35'},
        autoApproval: true,
        imageUrl: null,
        totalBudget: 2000.0,
        spentBudget: 600.0,
      ),
      CampaignModel(
        id: '2',
        companyId: 'company123',
        title: 'Instagram Boost',
        description: 'Boost Instagram profile with positive reviews.',
        platform: ReviewPlatform.instagram,
        platformUrl: 'https://instagram.com/business',
        pricePerReview: 15.0,
        totalReviewsNeeded: 50,
        completedReviews: 10,
        status: CampaignStatus.paused,
        deadline: DateTime.now().add(Duration(days: 5)),
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        requirements: ['Public Profile'],
        tags: ['Instagram', 'Engagement'],
        additionalInfo: {'hashtag': '#mybrand'},
        autoApproval: false,
        imageUrl: null,
        totalBudget: 1000.0,
        spentBudget: 150.0,
      ),
    ];

    isLoading.value = false;
  }


}
