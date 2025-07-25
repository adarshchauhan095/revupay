// // lib/screens/user/campaign_detail_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../controllers/campaign_controller.dart';
// import '../../models/campaign_model.dart';
// import '../../utils/constants.dart';
// import '../../widgets/custom_button.dart';
// import 'submit_review_screen.dart';
//
// class CampaignDetailScreen extends StatelessWidget {
//   final CampaignModel campaign;
//
//   const CampaignDetailScreen({Key? key, required this.campaign}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final CampaignController controller = Get.find();
//
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Campaign Details'),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.share),
//               onPressed: () => _shareCampaign(),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//               // Campaign Images
//               if (campaign.mediaUrls.isNotEmpty) ...[
//           Container(
//           height: 200,
//           child: PageView.builder(
//             itemCount: campaign.mediaUrls.length,
//             itemBuilder: (context, index) {
//               return CachedNetworkImage(
//                 imageUrl: campaign.mediaUrls[index],
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => Container(
//                   color: Colors.grey[300],
//                   child: Center(child: CircularProgressIndicator()),
//                 ),
//                 errorWidget: (context, url, error) => Container(
//                   color: Colors.grey[300],
//                   child: Icon(Icons.error),
//                 ),
//               );
//             },
//           ),
//         ),
//         ] else ...[
//     Container(
//     height: 200,
//     color: AppColors.primary.withOpacity(0.1),
//     child: Center(
//     child: Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//     Icon(
//     _getPlatformIcon(campaign.platform),
//     size: 64,
//     color: AppColors.primary,
//     ),
//     SizedBox(height: 8),
//     Text(
//     _getPlatformName(campaign.platform),
//     style: TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.bold,
//     color: AppColors.primary,
//     ),
//     ),
//     ],
//     ),
//     ),
//     ),
//     ],
//
//     Padding(
//     padding: EdgeInsets.all(16),
//     child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//     // Campaign Title and Price
//     Row(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//     Expanded(
//     child: Text(
//     campaign.title,
//     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//     fontWeight: FontWeight.bold,
//     ),
//     ),
//     ),
//     Container(
//     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//     decoration: BoxDecoration(
//     color: Colors.green,
//     borderRadius: BorderRadius.circular(20),
//     ),
//     child: Text(
//     '₹${campaign.pricePerReview.toStringAsFixed(0)}',
//     style: TextStyle(
//     color: Colors.white,
//     fontWeight: FontWeight.bold,
//     fontSize: 16,
//     ),
//     ),
//     ),
//     ],
//     ),
//
//     SizedBox(height: 16),
//
//     // Campaign Stats
//     Row(
//     children: [
//     _buildStatCard(
//     'Reviews Left',
//     '${campaign.totalReviewsNeeded - campaign.completedReviews}',
//     Icons.pending_actions,
//     Colors.blue,
//     ),
//     SizedBox(width: 12),
//     _buildStatCard(
//     'Days Left',
//     '${campaign.deadline.difference(DateTime.now()).inDays}',
//     Icons.timer,
//     Colors.orange,
//     ),
//     SizedBox(width: 12),
//     _buildStatCard(
//     'Platform',
//     _getPlatformName(campaign.platform),
//     _getPlatformIcon(campaign.platform),
//     AppColors.primary,
//     ),
//     ],
//     ),
//
//     SizedBox(height: 24),
//
//     // Description Section
//     _buildSection(
//     'Description',
//     campaign.description,
//     Icons.description,
//     ),
//
//     SizedBox(height: 20),
//
//     // Requirements Section
//     _buildSection(
//     'Requirements',
//     campaign.requirements,
//     Icons.checklist,
//     ),
//
//     SizedBox(height: 20),
//
//     // Business Link Section
//     _buildBusinessLinkSection(),
//
//     SizedBox(height: 20),
//
//     // Progress Section
//     _buildProgressSection(),
//
//     SizedBox(height: 20),
//
//     // Auto Approval Info
//     if (campaign.autoApproval) ...[
//     Container(
//     padding: EdgeInsets.all(12),
//     decoration: BoxDecoration(
//     color: Colors.green.withOpacity(0.1),
//     borderRadius: BorderRadius.circular(8),
//     border: Border.all(color: Colors.green.withOpacity(0.3)),
//     ),
//     child: Row(
//     children: [
//     Icon(Icons.auto_awesome, color: Colors.green),
//     SizedBox(width: 8),
//     Expanded(
//     child: Text(
//     'Auto-approval enabled - Reviews are automatically approved after ${campaign.autoApprovalHours} hours',
//     style: TextStyle(color: Colors.green[800]),
//     ),
//     ),
//     ],
//     ),
//     ),
//     SizedBox(height: 20),
//     ],
//
//     // Eligibility Check
//     FutureBuilder<bool>(
//     future: controller.checkUserEligibility(campaign.id),
//     builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//     return Center(child: CircularProgressIndicator());
//     }
//
//     final isEligible = snapshot.data ?? false;
//     final remainingSlots = campaign.totalReviewsNeeded - campaign.completedReviews;
//     final isExpired = campaign.deadline.isBefore(DateTime.now());
//
//     return Column(
//     children: [
//     if (!isEligible) ...[
//     Container(
//     padding: EdgeInsets.all(12),
//     decoration: BoxDecoration(
//     color: Colors.