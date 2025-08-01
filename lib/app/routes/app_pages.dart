// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:review_marketplace/app/modules/user_wallet/bindings/user_wallet_binding.dart';

import '../modules/admin/bindings/admin_binding.dart';
import '../modules/admin/views/admin_dashboard_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/role_selection_view.dart';
import '../modules/campaign_detail/bindings/campaign_detail_binding.dart';
import '../modules/campaign_detail/views/campaign_detail_screen.dart';
import '../modules/company/bindings/company_binding.dart';
import '../modules/company/views/company_dashboard_view.dart';
import '../modules/company/views/create_campaign_view.dart';
import '../modules/company/views/fund_campaign_view.dart';
import '../modules/user/bindings/user_controller_binding.dart';
import '../modules/user/views/user_dashboard_view.dart';
import '../modules/user_wallet/views/user_wallet_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ROLE_SELECTION;

  static final routes = [
    GetPage(
      name: _Paths.ROLE_SELECTION,
      page: () => const RoleSelectionView(),
      // No binding needed; uses global AuthController
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      // No binding needed; uses global AuthController
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      // No binding needed; uses global AuthController
    ),
    GetPage(
      name: _Paths.COMPANY_DASHBOARD,
      page: () => const CompanyDashboardView(),
      binding: CompanyBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_CAMPAIGN,
      page: () => CreateCampaignView(),
      binding: CompanyBinding(),
    ),
    GetPage(
      name: _Paths.FUND_CAMPAIGN,
      page: () => FundCampaignView(),
      binding: CompanyBinding(),
    ),
    GetPage(
      name: _Paths.USER_DASHBOARD,
      page: () => const UserDashboardView(),
      binding: UserControllerBinding(),
    ),
    GetPage(
      name: _Paths.USER_WALLET,
      page: () => const UserWalletView(),
      binding: UserWalletBinding(),
    ),
    GetPage(
      name: _Paths.CAMPAIGN_DETAIL,
      page: () => const CampaignDetailView(),
      binding: CampaignDetailBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminBinding(),
    ),
  ];
}
