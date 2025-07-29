// lib/screens/admin/user_management_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';

class UserManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AdminController adminController = Get.find();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Management'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All Users'),
              Tab(text: 'Companies'),
              Tab(text: 'Regular Users'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserList(adminController, null),
            _buildUserList(adminController, UserRole.company),
            _buildUserList(adminController, UserRole.user),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(AdminController controller, UserRole? role) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.refreshUsers();
      },
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => controller.searchUsers(value),
            ),
          ),

          // User List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              List<UserModel> users = controller.allUsers;
              if (role != null) {
                users = users.where((u) => u.role == role).toList();
              }

              final searchQuery = controller.userSearchQuery.value;
              if (searchQuery.isNotEmpty) {
                users = users.where((user) =>
                user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                    user.email.toLowerCase().contains(searchQuery.toLowerCase())
                ).toList();
              }

              if (users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No users found'),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getRoleColor(user.role),
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(user.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.email),
                          Text(
                            '${_getRoleName(user.role)} • Balance: ₹${user.walletBalance.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text('View Details'),
                            value: 'details',
                          ),
                          PopupMenuItem(
                            child: Text(user.isActive ? 'Suspend' : 'Activate'),
                            value: 'toggle_status',
                          ),
                          PopupMenuItem(
                            child: Text('Transaction History'),
                            value: 'transactions',
                          ),
                          if (user.role == UserRole.company) ...[
                            PopupMenuItem(
                              child: Text('View Campaigns'),
                              value: 'campaigns',
                            ),
                          ],
                        ],
                        onSelected: (value) => _handleUserAction(context, user, value.toString(), controller),
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red;
      case UserRole.company:
        return Colors.blue;
      case UserRole.user:
        return Colors.green;
    }
  }

  String _getRoleName(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.company:
        return 'Company';
      case UserRole.user:
        return 'User';
    }
  }

  void _handleUserAction(BuildContext context, UserModel user, String action, AdminController controller) {
    switch (action) {
      case 'details':
        _showUserDetails(context, user);
        break;
      case 'toggle_status':
        _toggleUserStatus(user, controller);
        break;
      case 'transactions':
        _showTransactionHistory(context, user);
        break;
      case 'campaigns':
        _showUserCampaigns(context, user);
        break;
    }
  }

  void _showUserDetails(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('User Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Name', user.name),
              _buildDetailRow('Email', user.email),
              _buildDetailRow('Phone', user.phone ?? 'Not provided'),
              _buildDetailRow('Role', _getRoleName(user.role)),
              _buildDetailRow('Status', user.isActive ? 'Active' : 'Suspended'),
              _buildDetailRow('Balance', '₹${user.walletBalance.toStringAsFixed(2)}'),
              _buildDetailRow('Joined', user.createdAt.toString().split(' ')[0]),
              if (user.lastLogin != null)
                _buildDetailRow('Last Login', user.lastLogin.toString().split(' ')[0]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _toggleUserStatus(UserModel user, AdminController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('Confirm Action'),
        content: Text(
          user.isActive
              ? 'Are you sure you want to suspend ${user.name}?'
              : 'Are you sure you want to activate ${user.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.toggleUserStatus(user.id, !user.isActive);
            },
            child: Text(user.isActive ? 'Suspend' : 'Activate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: user.isActive ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionHistory(BuildContext context, UserModel user) {
    Get.dialog(
      Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${user.name} - Transaction History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Text('Transaction history will be loaded here'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserCampaigns(BuildContext context, UserModel user) {
    Get.dialog(
      Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${user.name} - Campaigns',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Text('User campaigns will be loaded here'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}