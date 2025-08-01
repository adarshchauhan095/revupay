import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/campaign_model.dart';
import '../../../data/services/storage_service.dart';
import '../widgets/fullscreen_image_viewer.dart';

class CampaignDetailController extends GetxController {
  late CampaignModel campaign;
  final currentUser = Rxn<Map<String, dynamic>>();
  final userReviews = <Map<String, dynamic>>[].obs;
  final userNames = <String, String>{}.obs;
  final isLoading = false.obs;
  final selectedImages = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

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

      if (user['role'] == 'company') {
        // Company sees all reviews for their campaign
        userReviews.value = await StorageService.to.getReviews(
          campaignId: campaign.id,
        );

        // Fetch user names for company view
        final users = await StorageService.to.getUsers();
        userNames.clear();
        for (var userData in users) {
          userNames[userData['id']] = userData['name'] ?? 'Unknown User';
        }
      } else {
        // User sees only their reviews
        userReviews.value = await StorageService.to.getReviews(
          campaignId: campaign.id,
          userId: user['id'],
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void openImageViewer(
    List<String> imagePaths,
    int initialIndex,
    String userName,
  ) {
    Get.to(
      () => FullscreenImageViewer(
        imagePaths: imagePaths,
        initialIndex: initialIndex,
        userName: userName,
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    if (selectedImages.length >= 3) {
      Get.snackbar('Limit Reached', 'Maximum 3 images allowed');
      return;
    }

    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImages.add(File(image.path));
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> submitProof(String proofLink) async {
    final user = currentUser.value;
    if (user == null) return;

    final review = {
      'userId': user['id'],
      'campaignId': campaign.id,
      'proofLink': proofLink,
      'imagePaths': selectedImages.map((img) => img.path).toList(),
    };

    final success = await StorageService.to.submitReview(review);
    if (success) {
      selectedImages.clear();
      Get.snackbar('Success', 'Review submitted with proof images');
      fetchUserReviews();
    } else {
      Get.snackbar('Error', 'Failed to submit');
    }
  }

  // Existing methods remain unchanged...
  Future<void> approveReview(String reviewId) async {
    final success = await StorageService.to.updateReviewStatus(
      reviewId,
      'approved',
    );
    if (success) {
      Get.snackbar('Success', 'Review approved');
      fetchUserReviews();
    }
  }

  Future<void> rejectReview(String reviewId) async {
    final success = await StorageService.to.updateReviewStatus(
      reviewId,
      'rejected',
    );
    if (success) {
      Get.snackbar('Success', 'Review rejected');
      fetchUserReviews();
    }
  }
}
