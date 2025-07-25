// lib/screens/company/company_dashboard.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/company_campaign_controller.dart';
import '../../widgets/campaign_stats_card.dart';
import 'create_campaign_screen.dart';
import 'campaign_management_screen.dart';

class CompanyDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    final CompanyCampaignController campaignController = Get.put(CompanyCampaignController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Business Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => _showNotifications(context),
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
          await campaignController.refreshDashboard();
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
                        'Welcome, ${authController.currentUserData.value?.name ?? 'Business'}!',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Manage your review campaigns and grow your business',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
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
                      onPressed: () => Get.to(() => CreateCampaignScreen()),
                      icon: Icon(Icons.add_circle),
                      label: Text('Create Campaign'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Get.to(() => CampaignManagementScreen()),
                      icon: Icon(Icons.manage_accounts),
                      label: Text('Manage Campaigns'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Statistics Cards
              Obx(() {
                final stats = campaignController.dashboardStats.value;
                return Row(
                  children: [
                    Expanded(
                      child: CampaignStatsCard(
                        title: 'Active Campaigns',
                        value: stats['activeCampaigns']?.toString() ?? '0',
                        icon: Icons.campaign,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: CampaignStatsCard(
                        title: 'Total Reviews',
                        value: stats['totalReviews']?.toString() ?? '0',
                        icon: Icons.star,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                );
              }),

              SizedBox(height: 12),

              Obx(() {
                final stats = campaignController.dashboardStats.value;
                return Row(
                  children: [
                    Expanded(
                      child: CampaignStatsCard(
                        title: 'Pending Reviews',
                        value: stats['pendingReviews']?.toString() ?? '0',
                        icon: Icons.pending_actions,
                        color: Colors.amber,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: CampaignStatsCard(
                        title: 'Total Spent',
                        value: '₹${stats['totalSpent']?.toStringAsFixed(2) ?? '0.00'}',
                        icon: Icons.account_balance_wallet,
                        color: Colors.green,
                      ),
                    ),
                  ],
                );
              }),

              SizedBox(height: 20),

              // Recent Campaigns
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Campaigns',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => CampaignManagementScreen()),
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

                if (campaignController.companyCampaigns.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.campaign, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No campaigns yet',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            'Create your first campaign to get started!',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => Get.to(() => CreateCampaignScreen()),
                            child: Text('Create Campaign'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: campaignController.companyCampaigns.length.clamp(0, 3),
                  itemBuilder: (context, index) {
                    final campaign = campaignController.companyCampaigns[index];
                    return CompanyCampaignCard(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => CreateCampaignScreen()),
        child: Icon(Icons.add),
        tooltip: 'Create New Campaign',
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    // Implement notifications
    Get.snackbar('Notifications', 'No new notifications');
  }
}