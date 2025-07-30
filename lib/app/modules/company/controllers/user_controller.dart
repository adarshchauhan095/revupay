import 'package:get/get.dart';
import '../../../data/models/campaign_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/storage_service.dart';

class UserController extends GetxController {
  final isLoading = false.obs;
  final campaigns = <CampaignModel>[].obs;
  final reviews   = <Map<String, dynamic>>[].obs;
  final currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
    refreshData();
  }

  void _loadCurrentUser() {
    final data = StorageService.to.getCurrentUser();
    if (data != null) currentUser.value = UserModel.fromJson(data);
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    try {
      campaigns.value = (await StorageService.to.getCampaigns())
          .map((e) => CampaignModel.fromJson(e))
          .toList();
      reviews.value =
      await StorageService.to.getReviews(userId: currentUser.value?.id);
    } finally {
      isLoading.value = false;
    }
  }
}
