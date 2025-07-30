
// lib/app/routes/app_routes.dart
part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const ROLE_SELECTION = _Paths.ROLE_SELECTION;
  static const LOGIN = _Paths.LOGIN;
  static const COMPANY_DASHBOARD = _Paths.COMPANY_DASHBOARD;
  static const CREATE_CAMPAIGN = _Paths.CREATE_CAMPAIGN;
  static const USER_DASHBOARD = _Paths.USER_DASHBOARD;
  static const CAMPAIGN_DETAIL = _Paths.CAMPAIGN_DETAIL;
  static const ADMIN_DASHBOARD = _Paths.ADMIN_DASHBOARD;
}

abstract class _Paths {
  _Paths._();
  static const ROLE_SELECTION = '/role-selection';
  static const LOGIN = '/login';
  static const COMPANY_DASHBOARD = '/company-dashboard';
  static const CREATE_CAMPAIGN = '/create-campaign';
  static const USER_DASHBOARD = '/user-dashboard';
  static const CAMPAIGN_DETAIL = '/campaign-detail';
  static const ADMIN_DASHBOARD = '/admin-dashboard';
}