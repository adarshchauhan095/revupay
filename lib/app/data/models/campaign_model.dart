
// lib/app/data/models/campaign_model.dart
class CampaignModel {
  final String id;
  final String companyId;
  final String title;
  final String description;
  final String platform;
  final String businessLink;
  final double pricePerReview;
  final int maxReviews;
  final DateTime expiry;
  final String status;
  final int reviewsSubmitted;
  final DateTime createdAt;

  CampaignModel({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.platform,
    required this.businessLink,
    required this.pricePerReview,
    required this.maxReviews,
    required this.expiry,
    required this.status,
    required this.reviewsSubmitted,
    required this.createdAt,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'],
      companyId: json['companyId'],
      title: json['title'],
      description: json['description'],
      platform: json['platform'],
      businessLink: json['businessLink'],
      pricePerReview: (json['pricePerReview'] ?? 0.0).toDouble(),
      maxReviews: json['maxReviews'] ?? 0,
      expiry: DateTime.parse(json['expiry']),
      status: json['status'] ?? 'active',
      reviewsSubmitted: json['reviewsSubmitted'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'title': title,
      'description': description,
      'platform': platform,
      'businessLink': businessLink,
      'pricePerReview': pricePerReview,
      'maxReviews': maxReviews,
      'expiry': expiry.toIso8601String(),
      'status': status,
      'reviewsSubmitted': reviewsSubmitted,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}