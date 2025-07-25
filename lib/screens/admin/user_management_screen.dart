// // lib/screens/admin/user_management_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/admin_controller.dart';
// import '../../models/user_model.dart';
//
// class UserManagementScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final AdminController adminController = Get.find();
//
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('User Management'),
//           bottom: TabBar(
//             tabs: [
//               Tab(text: 'All Users'),
//               Tab(text: 'Companies'),
//               Tab(text: 'Regular Users'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _buildUserList(adminController, null),
//             _buildUserList(adminController, UserRole.company),
//             _buildUserList(adminController, UserRole.user),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildUserList(AdminController controller, UserRole? role) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         await controller.refreshUsers();
//       },
//       child: Column(
//         children: [
//           // Search Bar
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search users...',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onChanged: (value) => controller.searchUsers(value),
//             ),
//           ),
//
//           // User List
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return Center(child: CircularProgressIndicator());
//               }
//
//               List<UserModel> users = controller.allUsers;
//               if (role != null) {
//                 users = users.where((u) => u.role == role).toList();
//               }
//
//               final searchQuery = controller.userSearchQuery.value;
//               if (searchQuery.isNotEmpty) {
//                 users = users.where((user) =>
//                 user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
//                     user.email.toLowerCase().contains(searchQuery.toLowerCase())
//                 ).toList();
//               }
//
//               if (users.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.people, size: 64, color: Colors.grey),
//                       SizedBox(height: 16),
//                       Text('No users found'),
//                     ],
//                   ),
//                 );
//               }
//
//               return ListView.builder(
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   final user = users[index];
//                   return Card(
//                     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: _getRoleColor(user.role),
//                         child: Text(
//                           user.name[0].toUpperCase(),
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       title: Text(user.name),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(user.email),
//                           Text(
//                             '${_getRoleName(user.role)} • Balance: ₹${user.walletBalance.toStringAsFixed(2)}',
//                             style: TextStyle(fontSize: 12),
//                           ),
//                         ],
//                       ),
//                       trailing: PopupMenuButton(
//                         itemBuilder: (context) => [
//                           PopupMenuItem(
//                             child: Text('View Details'),
//                             value: 'details',
//                           ),
//                           PopupMenuItem(
//                             child: Text(user.isActive ? 'Suspend' : 'Activate'),
//                             value: 'toggle_status',
//                           ),
//                           PopupMenuItem(
//                             child: Text('Transaction History'),
//                             value: 'transactions',
//                           ),
//                           if (user.role == UserRole.company) ...[
//                             PopupMenuItem(
//                               child: Text('View Campaigns'),
//                               value: 'campaigns',
//                             ),
//                           ],
//                         ],
//                         onSelected: (value) => _handleUserAction(context, user, value.toString(), controller),
//                       ),
//                       isThreeLine: true,
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getRoleColor(UserRole role) {
//     switch (role) {
//     case UserRole