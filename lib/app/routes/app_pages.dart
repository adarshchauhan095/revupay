
// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/role_selection_view.dart';
import '../modules/company/bindings/company_binding.dart';
import '../modules/company/bindings/user_controller_binding.dart';
import '../modules/admin/views/admin_dashboard_view.dart';
import '../modules/common/views/campaign_detail_screen.dart';
import '../modules/company/views/company_dashboard_view.dart';
import '../modules/company/views/create_campaign_view.dart';
import '../modules/company/views/fund_campaign_view.dart';
import '../modules/user/views/user_dashboard_view.dart';
import '../modules/user/views/user_wallet_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const INITIAL = Routes.ROLE_SELECTION;

  static final routes = [
    GetPage(name: _Paths.ROLE_SELECTION, page: () => RoleSelectionView(), binding: AuthBinding()),
    GetPage(name: _Paths.LOGIN, page: () => LoginView(), binding: AuthBinding()),
    GetPage(name: _Paths.REGISTER, page: () => RegisterView(), binding: AuthBinding()),
    GetPage(
      name: _Paths.COMPANY_DASHBOARD,
      page: () => CompanyDashboardView(),
      bindings: [AuthBinding(), CompanyBinding()],
    ),
    GetPage(name: _Paths.CREATE_CAMPAIGN, page: () => CreateCampaignView(), binding: CompanyBinding()),
    GetPage(name: _Paths.FUND_CAMPAIGN, page: () => FundCampaignView(), binding: CompanyBinding()),
    GetPage(
      name: _Paths.USER_DASHBOARD,
      page: () => UserDashboardView(),
      bindings: [AuthBinding(), UserControllerBinding()],
    ),
    GetPage(name: _Paths.USER_WALLET, page: () => UserWalletView()),
    GetPage(name: _Paths.COMPANY_WALLET, page: () => UserWalletView()),
    GetPage(name: _Paths.CAMPAIGN_DETAIL, page: () => CampaignDetailView(), binding: UserControllerBinding()),
    GetPage(name: _Paths.ADMIN_DASHBOARD, page: () => AdminDashboardView(), binding: AuthBinding()),
  ];
}
