// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/theme/app_theme.dart';
import 'app/data/services/storage_service.dart';
import 'app/data/services/wallet_service.dart';
import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Global/shared services and controllers
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => WalletService().init());

  // Global bindings
  Get.put(AuthController()); // Global auth controller

  runApp(const ReviewCampaignApp());
}

class ReviewCampaignApp extends StatelessWidget {
  const ReviewCampaignApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Review Campaign',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: _getInitialRoute(),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }

  String _getInitialRoute() {
    final currentUser = StorageService.to.getCurrentUser();
    if (currentUser != null) {
      switch (currentUser['role']) {
        case 'company':
          return Routes.COMPANY_DASHBOARD;
        case 'user':
          return Routes.USER_DASHBOARD;
        case 'admin':
          return Routes.ADMIN_DASHBOARD;
      }
    }
    return Routes.ROLE_SELECTION;
  }
}
