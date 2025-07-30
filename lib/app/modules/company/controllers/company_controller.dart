
// lib/app/modules/company/controllers/company_controller.dart
import 'package:get/get.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/models/campaign_model.dart';
import '../../../data/models/user_model.dart';

class CompanyController extends GetxController {
  final isLoading = false.obs;
  final campaigns = <CampaignModel>[].obs;
  final currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
    loadCampaigns();
  }

  void _loadCurrentUser() {
    final userData = StorageService.to.getCurrentUser();
    if (userData != null) {
      currentUser.value = UserModel.fromJson(userData);
    }
  }

  Future<void> loadCampaigns() async {
    isLoading.value = true;
    try {
      final campaignData = await StorageService.to.getCampaigns(
        userId: currentUser.value?.id,
      );
      campaigns.value = campaignData.map((c) => CampaignModel.fromJson(c)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load campaigns');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createCampaign(Map<String, dynamic> campaignData) async {
    isLoading.value = true;
    try {
      campaignData['companyId'] = currentUser.value?.id;
      final success = await StorageService.to.createCampaign(campaignData);
      if (success) {
        loadCampaigns();
        Get.snackbar('Success', 'Campaign created successfully');
      }
      return success;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create campaign');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
