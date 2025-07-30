
// lib/app/modules/company/views/company_dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/campaign_model.dart';
import '../controllers/company_controller.dart';
import '../../../routes/app_pages.dart';
import '../../auth/controllers/auth_controller.dart';

class CompanyDashboardView extends GetView<CompanyController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.find<AuthController>().logout(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.CREATE_CAMPAIGN),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadCampaigns,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(context),
              const SizedBox(height: 16),
              _buildStatsRow(context),
              const SizedBox(height: 16),
              Text(
                'Your Campaigns',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: _buildCampaignsList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Obx(() => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.business,
                size: 32,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    controller.currentUser.value?.name ?? 'Company',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Wallet: ₹${controller.currentUser.value?.wallet?.toStringAsFixed(2) ?? '0.00'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildStatsRow(BuildContext context) {
    return Obx(() => Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Total Campaigns',
            value: controller.campaigns.length.toString(),
            icon: Icons.campaign,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Active',
            value: controller.campaigns.where((c) => c.status == 'active').length.toString(),
            icon: Icons.play_circle,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Reviews',
            value: controller.campaigns.fold(0, (sum, c) => sum + c.reviewsSubmitted).toString(),
            icon: Icons.star,
            color: Colors.orange,
          ),
        ),
      ],
    ));
  }

  Widget _buildCampaignsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.campaigns.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.campaign_outlined,
                size: 64,
                color: Theme.of(Get.context!).colorScheme.onSurface.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No campaigns yet',
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                  color: Theme.of(Get.context!).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your first campaign to get started',
                style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(Get.context!).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: controller.campaigns.length,
        itemBuilder: (context, index) {
          final campaign = controller.campaigns[index];
          return _CampaignCard(campaign: campaign);
        },
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final CampaignModel campaign;

  const _CampaignCard({required this.campaign});

  @override
  Widget build(BuildContext context) {
    final isExpired = campaign.expiry.isBefore(DateTime.now());
    final progress = campaign.maxReviews > 0
        ? campaign.reviewsSubmitted / campaign.maxReviews
        : 0.0;

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.CAMPAIGN_DETAIL, arguments: campaign),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      campaign.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(campaign.status, isExpired).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isExpired ? 'Expired' : campaign.status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(campaign.status, isExpired),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                campaign.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.monetization_on, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text('₹${campaign.pricePerReview}/review'),
                  const SizedBox(width: 16),
                  Icon(Icons.schedule, size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text('${campaign.expiry.day}/${campaign.expiry.month}'),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                '${campaign.reviewsSubmitted} / ${campaign.maxReviews} reviews',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status, bool isExpired) {
    if (isExpired) return Colors.red;
    switch (status) {
      case 'active':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}