// lib/screens/company/campaign_management_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/company_campaign_controller.dart';
import '../../models/campaign_model.dart';
import '../../widgets/company_campaign_card.dart';
import 'review_approval_screen.dart';

class CampaignManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CompanyCampaignController controller = Get.find();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage Campaigns'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'Paused'),
              Tab(text: 'All'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCampaignList(controller, CampaignStatus.active),
            _buildCampaignList(controller, CampaignStatus.completed),
            _buildCampaignList(controller, CampaignStatus.paused),
            _buildCampaignList(controller, null), // All campaigns
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignList(CompanyCampaignController controller, CampaignStatus? status) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.refreshCampaigns();
      },
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        List<CampaignModel> campaigns = controller.companyCampaigns;
        if (status != null) {
          campaigns = campaigns.where((c) => c.status == status).toList();
        }

        if (campaigns.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.campaign, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No campaigns found',
                  style: Theme.of(Get.context!).textTheme.titleMedium,
                ),
                Text(
                  status != null
                      ? 'No ${status.toString().split('.').last} campaigns'
                      : 'Create your first campaign to get started!',
                  style: Theme.of(Get.context!).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: campaigns.length,
          itemBuilder: (context, index) {
            final campaign = campaigns[index];
            return CompanyCampaignCard(
              campaign: campaign,
              onTap: () => _showCampaignActions(context, campaign, controller),
            );
          },
        );
      }),
    );
  }

  void _showCampaignActions(BuildContext context, CampaignModel campaign, CompanyCampaignController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.visibility),
              title: Text('View Details'),
              onTap: () {
                Get.back();
                controller.viewCampaignDetails(campaign);
              },
            ),
            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text('Review Submissions'),
              subtitle: Text('${campaign.completedReviews} submissions pending'),
              onTap: () {
                Get.back();
                Get.to(() => ReviewApprovalScreen(campaignId: campaign.id));
              },
            ),
            if (campaign.status == CampaignStatus.active) ...[
              ListTile(
                leading: Icon(Icons.pause),
                title: Text('Pause Campaign'),
                onTap: () {
                  Get.back();
                  controller.pauseCampaign(campaign.id);
                },
              ),
            ],
            if (campaign.status == CampaignStatus.paused) ...[
              ListTile(
                leading: Icon(Icons.play_arrow),
                title: Text('Resume Campaign'),
                onTap: () {
                  Get.back();
                  controller.resumeCampaign(campaign.id);
                },
              ),
            ],
            ListTile(
              leading: Icon(Icons.analytics),
              title: Text('View Analytics'),
              onTap: () {
                Get.back();
                _showCampaignAnalytics(context, campaign);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCampaignAnalytics(BuildContext context, CampaignModel campaign) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Campaign Analytics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Campaign: ${campaign.title}'),
            SizedBox(height: 16),
            Text('Progress: ${campaign.completedReviews}/${campaign.totalReviewsNeeded}'),
            Text('Completion: ${((campaign.completedReviews / campaign.totalReviewsNeeded) * 100).toStringAsFixed(1)}%'),
            Text('Days Remaining: ${campaign.deadline.difference(DateTime.now()).inDays}'),
            Text('Total Spent: ₹${(campaign.completedReviews * campaign.pricePerReview).toStringAsFixed(2)}'),
            Text('Remaining Budget: ₹${((campaign.totalReviewsNeeded - campaign.completedReviews) * campaign.pricePerReview).toStringAsFixed(2)}'),
          ],
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
}