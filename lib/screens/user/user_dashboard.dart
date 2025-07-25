// lib/screens/user/user_dashboard.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/campaign_controller.dart';
import '../../widgets/campaign_card.dart';
import 'campaign_list_screen.dart';
import 'wallet_screen.dart';

class UserDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    final CampaignController campaignController = Get.put(CampaignController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Review Marketplace'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_balance_wallet),
            onPressed: () => Get.to(() => WalletScreen()),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Profile'),
                value: 'profile',
              ),
              PopupMenuItem(
                child: Text('Settings'),
                value: 'settings',
              ),
              PopupMenuItem(
                child: Text('Logout'),
                value: 'logout',
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'logout':
                  authController.logout();
                  break;
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          campaignController.refreshCampaigns();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${authController.currentUserData.value?.name ?? 'User'}!',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 8),
                      Obx(() => Text(
                        'Wallet Balance: ₹${authController.currentUserData.value?.walletBalance.toStringAsFixed(2) ?? '0.00'}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Quick Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.to(() => CampaignListScreen()),
                      icon: Icon(Icons.search),
                      label: Text('Browse Campaigns'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.to(() => WalletScreen()),
                      icon: Icon(Icons.account_balance_wallet),
                      label: Text('My Wallet'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Featured Campaigns
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Campaigns',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => CampaignListScreen()),
                    child: Text('View All'),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Campaign List
              Obx(() {
                if (campaignController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (campaignController.campaigns.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.campaign, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No campaigns available',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            'Check back later for new opportunities!',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: campaignController.campaigns.length.clamp(0, 5),
                  itemBuilder: (context, index) {
                    final campaign = campaignController.campaigns[index];
                    return CampaignCard(
                      campaign: campaign,
                      onTap: () => campaignController.viewCampaignDetails(campaign),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}