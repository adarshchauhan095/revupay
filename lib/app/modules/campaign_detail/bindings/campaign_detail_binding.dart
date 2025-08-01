// lib/app/modules/campaign_detail/user_wallet/campaign_detail_binding.dart
import 'package:get/get.dart';

import '../controllers/campaign_detail_controller.dart';

class CampaignDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CampaignDetailController>(() => CampaignDetailController());
  }
}
