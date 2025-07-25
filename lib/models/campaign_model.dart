// lib/models/campaign_model.dart
class CampaignModel {
  final String id;
  final String companyId;
  final String companyName;
  final String title;
  final String description;
  final String requirements;
  final ReviewPlatform platform;
  final String businessLink;
  final double pricePerReview;
  final int totalReviewsNeeded;
  final int completedReviews;
  final DateTime deadline;
  final DateTime createdAt;
  final CampaignStatus status;
  final List<String>? mediaUrls;
  final double escrowAmount;
  final bool autoApproval;
  final int autoApprovalHours;

  CampaignModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.title,
    required this.description,
    required this.requirements,
    required this.platform,
    required this.businessLink,
    required this.pricePerReview,
    required this.totalReviewsNeeded,
    this.completedReviews = 0,
    required this.deadline,
    required this.createdAt,
    this.status = CampaignStatus.active,
    this.mediaUrls,
    required this.escrowAmount,
    this.autoApproval = true,
    this.autoApprovalHours = 48,
  });

  factory CampaignModel.fromMap(Map<String, dynamic> map, String id) {
    return CampaignModel(
      id: id,
      companyId: map['companyId'] ?? '',
      companyName: map['companyName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      requirements: map['requirements'] ?? '',
      platform: ReviewPlatform.values.firstWhere(
            (e) => e.toString().split('.').last == map['platform'],
        orElse: () => ReviewPlatform.google,
      ),
      businessLink: map['businessLink'] ?? '',
      pricePerReview: (map['pricePerReview'] ?? 0.0).toDouble(),
      totalReviewsNeeded: map['totalReviewsNeeded'] ?? 0,
      completedReviews: map['completedReviews'] ?? 0,
      deadline: DateTime.fromMillisecondsSinceEpoch(map['deadline']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      status: CampaignStatus.values.firstWhere(
            (e) => e.toString().split('.').last == map['status'],
        orElse: () => CampaignStatus.active,
      ),
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      escrowAmount: (map['escrowAmount'] ?? 0.0).toDouble(),
      autoApproval: map['autoApproval'] ?? true,
      autoApprovalHours: map['autoApprovalHours'] ?? 48,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'companyName': companyName,
      'title': title,
      'description': description,
      'requirements': requirements,
      'platform': platform.toString().split('.').last,
      'businessLink': businessLink,
      'pricePerReview': pricePerReview,
      'totalReviewsNeeded': totalReviewsNeeded,
      'completedReviews': completedReviews,
      'deadline': deadline.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'status': status.toString().split('.').last,
      'mediaUrls': mediaUrls,
      'escrowAmount': escrowAmount,
      'autoApproval': autoApproval,
      'autoApprovalHours': autoApprovalHours,
    };
  }
}

enum ReviewPlatform { google, instagram, youtube, facebook, other }
enum CampaignStatus { active, paused, completed, expired, cancelled }