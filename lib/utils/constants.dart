// lib/utils/constants.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color error = Color(0xFFB00020);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAFAFA);

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFBDBDBD);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Platform colors
  static const Color google = Color(0xFF4285F4);
  static const Color facebook = Color(0xFF1877F2);
  static const Color instagram = Color(0xFFE4405F);
  static const Color trustpilot = Color(0xFF00B67A);
  static const Color yelp = Color(0xFFD32323);
}

class AppConstants {
  // App Info
  static const String appName = 'Review Marketplace';
  static const String appVersion = '1.0.0';

  // Minimum values
  static const double minWithdrawalAmount = 10.0;
  static const double minCampaignBudget = 50.0;
  static const int minPasswordLength = 6;
  static const int minPhoneLength = 10;

  // Pagination
  static const int campaignsPerPage = 20;
  static const int transactionsPerPage = 50;

  // URLs
  static const String termsOfServiceUrl = 'https://example.com/terms';
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String supportEmail = 'support@reviewmarketplace.com';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String campaignsCollection = 'campaigns';
  static const String reviewSubmissionsCollection = 'reviewSubmissions';
  static const String walletTransactionsCollection = 'walletTransactions';
  static const String adminDataCollection = 'adminData';

  // Shared Preferences Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String notificationsEnabledKey = 'notifications_enabled';

  // Platform specific
  static const Map<String, String> platformNames = {
    'google': 'Google Reviews',
    'facebook': 'Facebook',
    'instagram': 'Instagram',
    'trustpilot': 'Trustpilot',
    'yelp': 'Yelp',
    'other': 'Other',
  };

  static const Map<String, Color> platformColors = {
    'google': AppColors.google,
    'facebook': AppColors.facebook,
    'instagram': AppColors.instagram,
    'trustpilot': AppColors.trustpilot,
    'yelp': AppColors.yelp,
    'other': Colors.grey,
  };

  // Review submission status
  static const Map<String, Color> statusColors = {
    'pending': AppColors.warning,
    'approved': AppColors.success,
    'rejected': AppColors.error,
    'under_review': AppColors.info,
  };

  // Wallet transaction types
  static const Map<String, IconData> transactionIcons = {
    'credit': Icons.add_circle,
    'debit': Icons.remove_circle,
    'withdrawal': Icons.account_balance_wallet,
    'bonus': Icons.card_giftcard,
    'refund': Icons.refresh,
  };
}

class AppStrings {
  // Common
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String update = 'Update';
  static const String submit = 'Submit';
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String warning = 'Warning';
  static const String info = 'Info';

  // Auth
  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String changePassword = 'Change Password';

  // Campaign
  static const String createCampaign = 'Create Campaign';
  static const String editCampaign = 'Edit Campaign';
  static const String deleteCampaign = 'Delete Campaign';
  static const String viewCampaign = 'View Campaign';
  static const String submitReview = 'Submit Review';

  // Wallet
  static const String walletBalance = 'Wallet Balance';
  static const String withdraw = 'Withdraw';
  static const String withdrawalRequest = 'Withdrawal Request';
  static const String transactionHistory = 'Transaction History';
  static const String dailyBonus = 'Daily Bonus';

  // Errors
  static const String internetError = 'Please check your internet connection';
  static const String serverError = 'Server error. Please try again later';
  static const String unknownError = 'Something went wrong';
  static const String validationError = 'Please check your input';

  // Success messages
  static const String loginSuccess = 'Logged in successfully';
  static const String registerSuccess = 'Account created successfully';
  static const String logoutSuccess = 'Logged out successfully';
  static const String updateSuccess = 'Updated successfully';
  static const String deleteSuccess = 'Deleted successfully';
}

class AppSizes {
  // Padding
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // Margin
  static const double marginXS = 4.0;
  static const double marginS = 8.0;
  static const double marginM = 16.0;
  static const double marginL = 24.0;
  static const double marginXL = 32.0;

  // Border radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;

  // Icon sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  // Button heights
  static const double buttonHeightS = 36.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;

  // Card dimensions
  static const double cardElevation = 2.0;
  static const double cardRadius = 12.0;

  // App bar
  static const double appBarHeight = 56.0;

  // List items
  static const double listItemHeight = 72.0;
  static const double listItemPadding = 16.0;
}