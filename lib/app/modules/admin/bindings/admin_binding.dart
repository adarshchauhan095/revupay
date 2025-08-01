// lib/app/modules/admin/user_wallet/admin_binding.dart
import 'package:get/get.dart';

import '../controllers/admin_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminController>(() => AdminController());
  }
}
