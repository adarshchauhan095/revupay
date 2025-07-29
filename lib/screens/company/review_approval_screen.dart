// lib/screens/company/review_approval_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/review_submission_model.dart';
import '../../widgets/review_submission_card.dart';

class ReviewApprovalScreen extends StatelessWidget {
  final String campaignId;

  const ReviewApprovalScreen({Key? key, required this.campaignId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final ReviewApprovalController controller = Get.put(ReviewApprovalController(campaignId));

  //   return DefaultTabController(
  //     length: 3,
  //     child: Scaffold(
  //       appBar: AppBar(
  //         title: Text('Review Submissions'),
  //         bottom: TabBar(
  //           tabs: [
  //             Tab(text: 'Pending'),
  //             Tab(text: 'Approved'),
  //             Tab(text: 'Rejected'),
  //           ],
  //         ),
  //       ),
  //       body: TabBarView(
  //         children: [
  //           _buildSubmissionsList(controller, SubmissionStatus.pending),
  //           _buildSubmissionsList(controller, SubmissionStatus.approved),
  //           _buildSubmissionsList(controller, SubmissionStatus.rejected),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildSubmissionsList(ReviewApprovalController controller, SubmissionStatus status) {
  //   return RefreshIndicator(
  //     onRefresh: () async {
  //       await controller.refreshSubmissions();
  //     },
  //     child: Obx(() {
  //       if (controller.isLoading.value) {
  //         return Center(child: CircularProgressIndicator());
  //       }
  //
  //       final submissions = controller.submissions
  //           .where((s) => s.status == status)
  //           .toList();
  //
  //       if (submissions.isEmpty) {
  //         return Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(_getStatusIcon(status), size: 64, color: Colors.grey),
  //               SizedBox(height: 16),
  //               Text(
  //                 'No ${status.toString().split('.').last} submissions',
  //                 style: Theme.of(context).textTheme.titleMedium,
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //
  //       return ListView.builder(
  //         padding: EdgeInsets.all(16),
  //         itemCount: submissions.length,
  //         itemBuilder: (context, index) {
  //           final submission = submissions[index];
  //           return ReviewSubmissionCard(
  //             submission: submission,
  //             onTap: () => _showSubmissionDetails(context, submission, controller),
  //           );
  //         },
  //       );
  //     }),
  //   );
  // }
  //
  // IconData _getStatusIcon(SubmissionStatus status) {
  //   switch (status) {
  //     case SubmissionStatus.pending:
  //       return Icons.pending_actions;
  //     case SubmissionStatus.approved:
  //       return Icons.check_circle;
  //     case SubmissionStatus.rejected:
  //       return Icons.cancel;
  //   }
  // }
  //
  // void _showSubmissionDetails(BuildContext context, ReviewSubmissionModel submission, ReviewApprovalController controller) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) => DraggableScrollableSheet(
  //       initialChildSize: 0.8,
  //       maxChildSize: 0.95,
  //       minChildSize: 0.5,
  //       builder: (context, scrollController) => Container(
  //         padding: EdgeInsets.all(16),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Header
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: Text(
  //                     'Review Submission',
  //                     style: Theme.of(context).textTheme.titleLarge,
  //                   ),
  //                 ),
  //                 IconButton(
  //                   onPressed: () => Get.back(),
  //                   icon: Icon(Icons.close),
  //                 ),
  //               ],
  //             ),
  //
  //             Divider(),
  //
  //             Expanded(
  //               child: SingleChildScrollView(
  //                 controller: scrollController,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     // User Info
  //                     ListTile(
  //                       leading: CircleAvatar(
  //                         child: Text(submission.userName[0].toUpperCase()),
  //                       ),
  //                       title: Text(submission.userName),
  //                       subtitle: Text('Submitted ${_formatDate(submission.submittedAt)}'),
  //                       contentPadding: EdgeInsets.zero,
  //                     ),
  //
  //                     SizedBox(height: 16),
  //
  //                     // Amount
  //                     Container(
  //                       padding: EdgeInsets.all(12),
  //                       decoration: BoxDecoration(
  //                         color: Colors.green.withOpacity(0.1),
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           Icon(Icons.account_balance_wallet, color: Colors.green),
  //                           SizedBox(width: 8),
  //                           Text(
  //                             'Amount: ₹${submission.amount.toStringAsFixed(2)}',
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.green,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //
  //                     SizedBox(height: 16),
  //
  //                     // Comment
  //                     if (submission.comment?.isNotEmpty == true) ...[
  //                       Text(
  //                         'User Comment:',
  //                         style: Theme.of(context).textTheme.titleMedium,
  //                       ),
  //                       SizedBox(height: 8),
  //                       Container(
  //                         width: double.infinity,
  //                         padding: EdgeInsets.all(12),
  //                         decoration: BoxDecoration(
  //                           color: Colors.grey[100],
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         child: Text(submission.comment!),
  //                       ),
  //                       SizedBox(height: 16),
  //                     ],
  //
  //                     // Proof Images
  //                     if (submission.proofImages.isNotEmpty) ...[
  //                       Text(
  //                         'Proof Images:',
  //                         style: Theme.of(context).textTheme.titleMedium,
  //                       ),
  //                       SizedBox(height: 8),
  //                       SizedBox(
  //                         height: 120,
  //                         child: ListView.builder(
  //                           scrollDirection: Axis.horizontal,
  //                           itemCount: submission.proofImages.length,
  //                           itemBuilder: (context, index) {
  //                             return Container(
  //                               width: 120,
  //                               margin: EdgeInsets.only(right: 8),
  //                               child: ClipRRect(
  //                                 borderRadius: BorderRadius.circular(8),
  //                                 child: CachedNetworkImage(
  //                                   imageUrl: submission.proofImages[index],
  //                                   fit: BoxFit.cover,
  //                                   placeholder: (context, url) => Center(
  //                                     child: CircularProgressIndicator(),
  //                                   ),
  //                                   errorWidget: (context, url, error) => Container(
  //                                     color: Colors.grey[300],
  //                                     child: Icon(Icons.error),
  //                                   ),
  //                                 ),
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                       ),
  //                       SizedBox(height: 16),
  //                     ],
  //
  //                     // Review Message (if any)
  //                     if (submission.reviewMessage?.isNotEmpty == true) ...[
  //                       Text(
  //                         'Review Message:',
  //                         style: Theme.of(context).textTheme.titleMedium,
  //                       ),
  //                       SizedBox(height: 8),
  //                       Container(
  //                         width: double.infinity,
  //                         padding: EdgeInsets.all(12),
  //                         decoration: BoxDecoration(
  //                           color: submission.status == SubmissionStatus.approved
  //                               ? Colors.green.withOpacity(0.1)
  //                               : Colors.red.withOpacity(0.1),
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         child: Text(submission.reviewMessage!),
  //                       ),
  //                       SizedBox(height: 16),
  //                     ],
  //                   ],
  //                 ),
  //               ),
  //             ),
  //
  //             // Action Buttons
  //             if (submission.status == SubmissionStatus.pending) ...[
  //               Divider(),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: OutlinedButton.icon(
  //                       onPressed: () => _showRejectDialog(context, submission, controller),
  //                       icon: Icon(Icons.close, color: Colors.red),
  //                       label: Text('Reject', style: TextStyle(color: Colors.red)),
  //                       style: OutlinedButton.styleFrom(
  //                         side: BorderSide(color: Colors.red),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(width: 16),
  //                   Expanded(
  //                     child: ElevatedButton.icon(
  //                       onPressed: () => _approveSubmission(context, submission, controller),
  //                       icon: Icon(Icons.check),
  //                       label: Text('Approve'),
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.green,
  //                         foregroundColor: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // void _approveSubmission(BuildContext context, ReviewSubmissionModel submission, ReviewApprovalController controller) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Approve Submission'),
  //       content: Text('Are you sure you want to approve this submission? ₹${submission.amount.toStringAsFixed(2)} will be paid to the user.'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //           child: Text('Cancel'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Get.back(); // Close dialog
  //             Get.back(); // Close bottom sheet
  //             controller.approveSubmission(submission.id, 'Great work! Review approved.');
  //           },
  //           child: Text('Approve'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // void _showRejectDialog(BuildContext context, ReviewSubmissionModel submission, ReviewApprovalController controller) {
  //   final TextEditingController messageController = TextEditingController();
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Reject Submission'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text('Please provide a reason for rejection:'),
  //           SizedBox(height: 16),
  //           TextField(
  //             controller: messageController,
  //             decoration: InputDecoration(
  //               labelText: 'Rejection reason',
  //               border: OutlineInputBorder(),
  //             ),
  //             maxLines: 3,
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //           child: Text('Cancel'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             if (messageController.text.trim().isEmpty) {
  //               Get.snackbar('Error', 'Please provide a rejection reason');
  //               return;
  //             }
  //             Get.back(); // Close dialog
  //             Get.back(); // Close bottom sheet
  //             controller.rejectSubmission(submission.id, messageController.text.trim());
  //           },
  //           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
  //           child: Text('Reject'),
  //         ),
  //       ],
  //     ),
  //   );
    return Container();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}