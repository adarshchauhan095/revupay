// lib/screens/user/user_dashboard.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/campaign_controller.dart';
import '../../widgets/campaign_card.dart';
import 'campaign_list_screen.dart';
import 'wallet_screen.dart';

// class UserDashboard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final AuthController authController = Get.find();
//     final CampaignController campaignController = Get.put(CampaignController());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Review Marketplace'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.account_balance_wallet),
//             onPressed: () => Get.to(() => WalletScreen()),
//           ),
//           PopupMenuButton(
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 child: Text('Profile'),
//                 value: 'profile',
//               ),
//               PopupMenuItem(
//                 child: Text('Settings'),
//                 value: 'settings',
//               ),
//               PopupMenuItem(
//                 child: Text('Logout'),
//                 value: 'logout',
//               ),
//             ],
//             onSelected: (value) {
//               switch (value) {
//                 case 'logout':
//                   authController.logout();
//                   break;
//               }
//             },
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           campaignController.refreshCampaigns();
//         },
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Welcome Card
//               Card(
//                 child: Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Welcome back, ${authController.currentUserData?.name ?? 'User'}!',
//                         style: Theme.of(context).textTheme.headlineSmall,
//                       ),
//                       SizedBox(height: 8),
//                       Obx(() => Text(
//                         'Wallet Balance: ₹${authController.currentUserData?.walletBalance.toStringAsFixed(2) ?? '0.00'}',
//                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           color: Colors.green,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       )),
//                     ],
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 20),
//
//               // Quick Actions
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () => Get.to(() => CampaignListScreen()),
//                       icon: Icon(Icons.search),
//                       label: Text('Browse Campaigns'),
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () => Get.to(() => WalletScreen()),
//                       icon: Icon(Icons.account_balance_wallet),
//                       label: Text('My Wallet'),
//                     ),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 20),
//
//               // Featured Campaigns
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Featured Campaigns',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   TextButton(
//                     onPressed: () => Get.to(() => CampaignListScreen()),
//                     child: Text('View All'),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 12),
//
//               // Campaign List
//               Obx(() {
//                 if (campaignController.isLoading) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 if (campaignController.campaigns.isEmpty) {
//                   return Card(
//                     child: Padding(
//                       padding: EdgeInsets.all(32),
//                       child: Column(
//                         children: [
//                           Icon(Icons.campaign, size: 64, color: Colors.grey),
//                           SizedBox(height: 16),
//                           Text(
//                             'No campaigns available',
//                             style: Theme.of(context).textTheme.titleMedium,
//                           ),
//                           Text(
//                             'Check back later for new opportunities!',
//                             style: Theme.of(context).textTheme.bodyMedium,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: campaignController.campaigns.length.clamp(0, 5),
//                   itemBuilder: (context, index) {
//                     final campaign = campaignController.campaigns[index];
//                     return CampaignCard(
//                       campaign: campaign,
//                       onTap: () => campaignController.viewCampaignDetails(campaign),
//                     );
//                   },
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// lib/screens/user/user_dashboard.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/constants.dart';

class UserDashboard extends StatelessWidget {
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _authController.logout(),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final user = _authController.currentUser;
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${user?.displayName ?? 'User'}!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Email: ${user?.email ?? ''}'),
                      Text('Role: ${user?.roleDisplayName ?? ''}'),
                      Text('Wallet Balance: \${user?.walletBalance.toStringAsFixed(2) ?? 0.00}'),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: 24),
            Text(
              'Features Coming Soon:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            _buildFeatureCard('Write Reviews', 'Earn money by writing honest reviews'),
            _buildFeatureCard('View Earnings', 'Track your review earnings'),
            _buildFeatureCard('Withdrawal', 'Withdraw your earnings to bank account'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.star, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Get.snackbar('Coming Soon', '$title feature will be available soon!');
        },
      ),
    );
  }
}