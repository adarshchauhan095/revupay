import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}
