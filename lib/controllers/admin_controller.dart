// lib/controllers/admin_controller.dart
import 'package:get/get.dart';
import '../models/user_model.dart';

class AdminController extends GetxController {
  // System Stats
  var systemStats = <String, dynamic>{
    'totalUsers': 0,
    'activeCampaigns': 0,
    'pendingReviews': 0,
    'totalRevenue': 0.0,
  }.obs;

  // Recent activities
  var recentActivities = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  // User Management
  var allUsers = <UserModel>[].obs;
  var userSearchQuery = ''.obs;

  Future<void> refreshDashboard() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1)); // Simulate API delay

    systemStats.value = {
      'totalUsers': 1234,
      'activeCampaigns': 45,
      'pendingReviews': 8,
      'totalRevenue': 98234.25,
    };

    recentActivities.value = [
      {
        'type': 'user_registered',
        'title': 'New User Joined',
        'description': 'Ravi Kumar registered',
        'timestamp': DateTime.now().subtract(Duration(minutes: 20)),
      },
    ];

    isLoading.value = false;
  }

  /// ✅ Refresh users list
  Future<void> refreshUsers() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1)); // Simulate API call

    // Sample dummy data
    allUsers.value = [
      UserModel(
        id: 'u1',
        name: 'Adarsh Chauhan',
        email: 'adarsh@example.com',
        phone: '9876543210',
        role: UserRole.user,
        isActive: true,
        walletBalance: 150.75,
        createdAt: DateTime(2024, 12, 10),
        lastLogin: DateTime.now().subtract(Duration(hours: 2)),
      ),
      UserModel(
        id: 'u2',
        name: 'Innovate Corp',
        email: 'hr@innovatecorp.com',
        phone: '9811122233',
        role: UserRole.company,
        isActive: false,
        walletBalance: 2340.50,
        createdAt: DateTime(2024, 9, 20),
        lastLogin: DateTime.now().subtract(Duration(days: 1)),
      ),
    ];

    isLoading.value = false;
  }

  /// ✅ Filter search users
  void searchUsers(String query) {
    userSearchQuery.value = query;
  }

  /// ✅ Toggle user status (active/suspended)
  void toggleUserStatus(String userId, bool isActive) {
    final index = allUsers.indexWhere((u) => u.id == userId);
    if (index != -1) {
      allUsers[index] = allUsers[index].copyWith(isActive: isActive);
      allUsers.refresh(); // Important for GetX to update UI
    }
  }
}
