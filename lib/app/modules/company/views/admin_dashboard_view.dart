import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/campaign_model.dart';
import '../../../routes/app_pages.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/admin_controller.dart';

class AdminDashboardView extends GetView<AdminController> {
  @override
  Widget build(BuildContext ctx) {
    Get.put(AdminController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
              onPressed: () => Get.find<AuthController>().logout(),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshAll,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _adminStats(ctx),
              const SizedBox(height: 20),
              Text('Pending Reviews',
                  style: Theme.of(ctx)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...controller.pendingReviews
                  .map((r) => _ReviewTile(r))
                  .toList(),
              const SizedBox(height: 20),
              Text('All Campaigns',
                  style: Theme.of(ctx)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...controller.campaigns.map((c) => _campaignCard(c)).toList(),
            ],
          );
        }),
      ),
    );
  }

  /* ---------- Widgets ---------- */

  Widget _adminStats(BuildContext ctx) => Row(
    children: [
      _stat(ctx, 'Users', controller.users.length, Icons.people),
      _stat(ctx, 'Campaigns', controller.campaigns.length,
          Icons.campaign_rounded),
      _stat(ctx, 'Pending', controller.pendingReviews.length,
          Icons.hourglass_empty),
    ],
  );

  Widget _stat(BuildContext ctx, String t, int v, IconData i) => Expanded(
    child: Card(
      child: ListTile(
        leading: Icon(i, color: Theme.of(ctx).colorScheme.primary),
        title: Text('$v',
            style: Theme.of(ctx)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(t),
      ),
    ),
  );

  Widget _ReviewTile(Map<String, dynamic> r) => Card(
    child: ListTile(
      title: Text('Review #${r["id"]} • ₹${r["earning"] ?? "?"}'),
      subtitle: Text('Campaign: ${r["campaignId"]} • User: ${r["userId"]}'),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () =>
                controller.approve(r['id'] as String)),
        IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () =>
                controller.reject(r['id'] as String)),
      ]),
    ),
  );

  Widget _campaignCard(CampaignModel c) => GestureDetector(
    onTap: () => Get.toNamed(Routes.CAMPAIGN_DETAIL, arguments: c),
    child: Card(
      child: ListTile(
        title: Text(c.title),
        subtitle: Text('${c.reviewsSubmitted}/${c.maxReviews} reviews'),
        trailing: Text(c.status),
      ),
    ),
  );
}
