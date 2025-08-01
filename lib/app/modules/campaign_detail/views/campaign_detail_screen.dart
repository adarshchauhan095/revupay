// lib/app/modules/campaign_detail/views/campaign_detail_screen.dart - Updated sections only
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/campaign_detail_controller.dart';

class CampaignDetailView extends GetView<CampaignDetailController> {
  const CampaignDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = controller.currentUser.value;
    final role = user?['role'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(controller.campaign.title)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.campaign.description),
                const SizedBox(height: 12),
                Text('Platform: ${controller.campaign.platform}'),
                Text('Business Link: ${controller.campaign.businessLink}'),
                Text(
                  'Reward: ₹${controller.campaign.pricePerReview.toStringAsFixed(2)}',
                ),
                const Divider(),
                if (role == 'user') _buildUserActions(),
                if (role == 'company') _buildCompanyActions(),
                if (role == 'admin') _buildAdminActions(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildUserActions() {
    final proofController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: proofController,
          decoration: const InputDecoration(labelText: 'Proof of Review Link'),
        ),
        const SizedBox(height: 12),

        // Image selection section
        const Text(
          'Proof Images (Optional - Max 3):',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        Obx(
          () => Wrap(
            spacing: 8,
            children: [
              ...controller.selectedImages.asMap().entries.map(
                (entry) => Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(entry.value, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: -8,
                      right: -8,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () => controller.removeImage(entry.key),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.selectedImages.length < 3)
                GestureDetector(
                  onTap: () => _showImagePicker(),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add_photo_alternate,
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => controller.submitProof(proofController.text),
          child: const Text('Submit Review'),
        ),
        const SizedBox(height: 12),
        const Text('Your Submissions:'),
        ...controller.userReviews.map((r) => _ReviewSubmissionTile(r)),
      ],
    );
  }

  Widget _buildCompanyActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Reviews Submitted:'),
        ...controller.userReviews.map((r) => _CompanyReviewTile(r)),
      ],
    );
  }

  Widget _buildAdminActions() {
    return const Text('Admin: view-only for now');
  }

  void _showImagePicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }
}

class _ReviewSubmissionTile extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewSubmissionTile(this.review);

  @override
  Widget build(BuildContext context) {
    final imagePaths = List<String>.from(review['imagePaths'] ?? []);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Link: ${review['proofLink']}'),
            Text(
              'Status: ${review['status']}',
              style: TextStyle(
                color: review['status'] == 'approved'
                    ? Colors.green
                    : Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (imagePaths.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Proof Images:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) => Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(imagePaths[index]),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// lib/app/modules/campaign_detail/views/campaign_detail_screen.dart - Replace _CompanyReviewTile class only

class _CompanyReviewTile extends StatelessWidget {
  final Map<String, dynamic> review;
  const _CompanyReviewTile(this.review);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CampaignDetailController>();
    final imagePaths = List<String>.from(review['imagePaths'] ?? []);
    final userName = controller.userNames[review['userId']] ?? 'Unknown User';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User name header
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const Spacer(),
                Text(
                  'User ID: ${review['userId']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text('Link: ${review['proofLink']}'),
            Text(
              'Status: ${review['status']}',
              style: TextStyle(
                color: review['status'] == 'approved'
                    ? Colors.green
                    : review['status'] == 'rejected'
                    ? Colors.red
                    : Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),

            if (imagePaths.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Proof Images (${imagePaths.length}):',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• Tap to view full screen',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () =>
                        controller.openImageViewer(imagePaths, index, userName),
                    child: Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(imagePaths[index]),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                            ),
                          ),
                          // Full screen indicator
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],

            if (review['status'] == 'pending') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () => controller.approveReview(review['id']),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Reject'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => controller.rejectReview(review['id']),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
