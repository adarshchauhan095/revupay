// lib/app/modules/user/views/user_dashboard_view.dart - Updated
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/campaign_model.dart';
import '../../../routes/app_pages.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/user_controller.dart';

class UserDashboardView extends GetView<UserController> {
  const UserDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () => Get.toNamed(Routes.USER_WALLET),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.find<AuthController>().logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _welcomeCard(context),
              const SizedBox(height: 16),
              _statsRow(context),
              const SizedBox(height: 16),
              Text(
                'Active Campaigns',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: _campaignList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _welcomeCard(BuildContext ctx) => Obx(
    () => Card(
      child: ListTile(
        leading: const Icon(Icons.person, size: 40),
        title: Text(
          controller.currentUser.value?.name ?? 'User',
          style: Theme.of(
            ctx,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Wallet: ₹${controller.currentUser.value?.wallet?.toStringAsFixed(2) ?? '0.00'}',
          style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
            color: Theme.of(ctx).colorScheme.primary,
          ),
        ),
        trailing: ElevatedButton.icon(
          onPressed: () => Get.toNamed(Routes.USER_WALLET),
          icon: const Icon(Icons.account_balance_wallet, size: 16),
          label: const Text('Wallet'),
        ),
      ),
    ),
  );

  Widget _statsRow(BuildContext ctx) => Obx(() {
    final total = controller.reviews.length;
    final approved = controller.reviews
        .where((r) => r['status'] == 'approved')
        .length;
    final pending = controller.reviews
        .where((r) => r['status'] == 'pending')
        .length;
    final earnings = controller.reviews
        .where((r) => r['status'] == 'approved')
        .fold(0.0, (sum, r) => sum + (r['earning'] ?? 0.0));

    return Row(
      children: [
        _statCard(ctx, 'Reviews', total.toString(), Icons.star),
        const SizedBox(width: 8),
        _statCard(ctx, 'Approved', approved.toString(), Icons.check),
        const SizedBox(width: 8),
        _statCard(
          ctx,
          'Earnings',
          '₹${earnings.toStringAsFixed(0)}',
          Icons.monetization_on,
        ),
      ],
    );
  });

  Widget _statCard(
    BuildContext ctx,
    String title,
    String value,
    IconData icon,
  ) => Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(ctx).colorScheme.primary, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(
                ctx,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                color: Theme.of(ctx).colorScheme.onSurface.withOpacity(.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );

  Widget _campaignList() => Obx(() {
    if (controller.isLoading.value)
      return const Center(child: CircularProgressIndicator());
    if (controller.campaigns.isEmpty)
      return const Center(child: Text('No active campaigns'));
    return ListView.builder(
      itemCount: controller.campaigns.length,
      itemBuilder: (_, i) => _CampaignTile(c: controller.campaigns[i]),
    );
  });
}

class _CampaignTile extends StatelessWidget {
  final CampaignModel c;
  const _CampaignTile({required this.c});

  @override
  Widget build(BuildContext ctx) {
    final progress = c.maxReviews > 0 ? c.reviewsSubmitted / c.maxReviews : 0.0;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(
          c.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('₹${c.pricePerReview} / review • ${c.platform}'),
            const SizedBox(height: 4),
            LinearProgressIndicator(value: progress),
            Text('${c.reviewsSubmitted}/${c.maxReviews} reviews'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Get.toNamed(Routes.CAMPAIGN_DETAIL, arguments: c),
      ),
    );
  }
}
