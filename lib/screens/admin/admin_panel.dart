// lib/screens/admin/admin_panel.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../widgets/admin_stats_card.dart';
import 'user_management_screen.dart';
import 'campaign_oversight_screen.dart';
import 'dispute_resolution_screen.dart';
import 'analytics_dashboard.dart';

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AdminController adminController = Get.put(AdminController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => adminController.refreshDashboard(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await adminController.refreshDashboard();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Stats
              Text(
                'System Overview',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16),

              Obx(() {
                final stats = adminController.systemStats.value;
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AdminStatsCard(
                            title: 'Total Users',
                            value: stats['totalUsers']?.toString() ?? '0',
                            icon: Icons.people,
                            color: Colors.blue,
                            onTap: () => Get.to(() => UserManagementScreen()),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: AdminStatsCard(
                            title: 'Active Campaigns',
                            value: stats['activeCampaigns']?.toString() ?? '0',
                            icon: Icons.campaign,
                            color: Colors.green,
                            onTap: () => Get.to(() => CampaignOversightScreen()),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AdminStatsCard(
                            title: 'Pending Reviews',
                            value: stats['pendingReviews']?.toString() ?? '0',
                            icon: Icons.pending_actions,
                            color: Colors.orange,
                            onTap: () => Get.to(() => DisputeResolutionScreen()),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: AdminStatsCard(
                            title: 'Total Revenue',
                            value: '₹${stats['totalRevenue']?.toStringAsFixed(2) ?? '0.00'}',
                            icon: Icons.account_balance_wallet,
                            color: Colors.purple,
                            onTap: () => Get.to(() => AnalyticsDashboard()),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),

              SizedBox(height: 24),

              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildQuickActionCard(
                    context,
                    'User Management',
                    Icons.people_alt,
                    Colors.blue,
                        () => Get.to(() => UserManagementScreen()),
                  ),
                  _buildQuickActionCard(
                    context,
                    'Campaign Oversight',
                    Icons.visibility,
                    Colors.green,
                        () => Get.to(() => CampaignOversightScreen()),
                  ),
                  _buildQuickActionCard(
                    context,
                    'Dispute Resolution',
                    Icons.gavel,
                    Colors.orange,
                        () => Get.to(() => DisputeResolutionScreen()),
                  ),
                  _buildQuickActionCard(
                    context,
                    'Analytics',
                    Icons.analytics,
                    Colors.purple,
                        () => Get.to(() => AnalyticsDashboard()),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Recent Activities
              Text(
                'Recent Activities',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16),

              Obx(() {
                if (adminController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                final activities = adminController.recentActivities;
                if (activities.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Text('No recent activities'),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: activities.length.clamp(0, 10),
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(_getActivityIcon(activity['type'])),
                        title: Text(activity['title']),
                        subtitle: Text(activity['description']),
                        trailing: Text(_formatTime(activity['timestamp'])),
                      ),
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

  Widget _buildQuickActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'user_registered':
        return Icons.person_add;
      case 'campaign_created':
        return Icons.add_circle;
      case 'review_submitted':
        return Icons.rate_review;
      case 'payment_processed':
        return Icons.payment;
      default:
        return Icons.info;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}