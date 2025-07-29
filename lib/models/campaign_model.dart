// lib/models/campaign_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum ReviewPlatform { google, facebook, instagram, trustpilot, yelp, other }
enum CampaignStatus { draft, active, paused, completed, expired, cancelled }

class CampaignModel {
  final String id;
  final String companyId;
  final String title;
  final String description;
  final ReviewPlatform platform;
  final String platformUrl;
  final double pricePerReview;
  final int totalReviewsNeeded;
  final int completedReviews;
  final CampaignStatus status;
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> requirements;
  final List<String> tags;
  final Map<String, dynamic>? additionalInfo;
  final bool autoApproval;
  final String? imageUrl;
  final double totalBudget;
  final double spentBudget;

  CampaignModel({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.platform,
    required this.platformUrl,
    required this.pricePerReview,
    required this.totalReviewsNeeded,
    this.completedReviews = 0,
    this.status = CampaignStatus.draft,
    required this.deadline,
    required this.createdAt,
    this.updatedAt,
    this.requirements = const [],
    this.tags = const [],
    this.additionalInfo,
    this.autoApproval = false,
    this.imageUrl,
    required this.totalBudget,
    this.spentBudget = 0.0,
  });

  factory CampaignModel.fromMap(Map<String, dynamic> map, String id) {
    return CampaignModel(
      id: id,
      companyId: map['companyId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      platform: _parsePlatform(map['platform']),
      platformUrl: map['platformUrl'] ?? '',
      pricePerReview: (map['pricePerReview'] ?? 0.0).toDouble(),
      totalReviewsNeeded: map['totalReviewsNeeded'] ?? 0,
      completedReviews: map['completedReviews'] ?? 0,
      status: _parseStatus(map['status']),
      deadline: _parseDateTime(map['deadline']),
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
      requirements: List<String>.from(map['requirements'] ?? []),
      tags: List<String>.from(map['tags'] ?? []),
      additionalInfo: map['additionalInfo'],
      autoApproval: map['autoApproval'] ?? false,
      imageUrl: map['imageUrl'],
      totalBudget: (map['totalBudget'] ?? 0.0).toDouble(),
      spentBudget: (map['spentBudget'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'title': title,
      'description': description,
      'platform': platform.toString().split('.').last,
      'platformUrl': platformUrl,
      'pricePerReview': pricePerReview,
      'totalReviewsNeeded': totalReviewsNeeded,
      'completedReviews': completedReviews,
      'status': status.toString().split('.').last,
      'deadline': deadline.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'requirements': requirements,
      'tags': tags,
      'additionalInfo': additionalInfo,
      'autoApproval': autoApproval,
      'imageUrl': imageUrl,
      'totalBudget': totalBudget,
      'spentBudget': spentBudget,
    };
  }

  CampaignModel copyWith({
    String? id,
    String? companyId,
    String? title,
    String? description,
    ReviewPlatform? platform,
    String? platformUrl,
    double? pricePerReview,
    int? totalReviewsNeeded,
    int? completedReviews,
    CampaignStatus? status,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? requirements,
    List<String>? tags,
    Map<String, dynamic>? additionalInfo,
    bool? autoApproval,
    String? imageUrl,
    double? totalBudget,
    double? spentBudget,
  }) {
    return CampaignModel(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      title: title ?? this.title,
      description: description ?? this.description,
      platform: platform ?? this.platform,
      platformUrl: platformUrl ?? this.platformUrl,
      pricePerReview: pricePerReview ?? this.pricePerReview,
      totalReviewsNeeded: totalReviewsNeeded ?? this.totalReviewsNeeded,
      completedReviews: completedReviews ?? this.completedReviews,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      requirements: requirements ?? this.requirements,
      tags: tags ?? this.tags,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      autoApproval: autoApproval ?? this.autoApproval,
      imageUrl: imageUrl ?? this.imageUrl,
      totalBudget: totalBudget ?? this.totalBudget,
      spentBudget: spentBudget ?? this.spentBudget,
    );
  }

  static ReviewPlatform _parsePlatform(dynamic platform) {
    if (platform is String) {
      switch (platform.toLowerCase()) {
        case 'google':
          return ReviewPlatform.google;
        case 'facebook':
          return ReviewPlatform.facebook;
        case 'instagram':
          return ReviewPlatform.instagram;
        case 'trustpilot':
          return ReviewPlatform.trustpilot;
        case 'yelp':
          return ReviewPlatform.yelp;
        case 'other':
        default:
          return ReviewPlatform.other;
      }
    }
    return ReviewPlatform.other;
  }

  static CampaignStatus _parseStatus(dynamic status) {
    if (status is String) {
      switch (status.toLowerCase()) {
        case 'draft':
          return CampaignStatus.draft;
        case 'active':
          return CampaignStatus.active;
        case 'paused':
          return CampaignStatus.paused;
        case 'completed':
          return CampaignStatus.completed;
        case 'expired':
          return CampaignStatus.expired;
        case 'cancelled':
          return CampaignStatus.cancelled;
        default:
          return CampaignStatus.draft;
      }
    }
    return CampaignStatus.draft;
  }

  static DateTime _parseDateTime(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();

    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else if (timestamp is DateTime) {
      return timestamp;
    }

    return DateTime.now();
  }

  // Getters for computed properties
  bool get isActive => status == CampaignStatus.active;
  bool get isCompleted => status == CampaignStatus.completed;
  bool get isExpired => status == CampaignStatus.expired || deadline.isBefore(DateTime.now());
  bool get isPaused => status == CampaignStatus.paused;
  bool get isDraft => status == CampaignStatus.draft;

  double get progressPercentage {
    if (totalReviewsNeeded == 0) return 0.0;
    return (completedReviews / totalReviewsNeeded * 100).clamp(0.0, 100.0);
  }

  int get remainingReviews => (totalReviewsNeeded - completedReviews).clamp(0, totalReviewsNeeded);

  double get remainingBudget => (totalBudget - spentBudget).clamp(0.0, totalBudget);

  Duration get timeRemaining => deadline.difference(DateTime.now());

  bool get isEndingSoon {
    final now = DateTime.now();
    final daysLeft = deadline.difference(now).inDays;
    return daysLeft <= 3 && daysLeft >= 0;
  }

  bool get isHighPaying => pricePerReview >= 50.0;

  String get platformDisplayName {
    switch (platform) {
      case ReviewPlatform.google:
        return 'Google Reviews';
      case ReviewPlatform.facebook:
        return 'Facebook';
      case ReviewPlatform.instagram:
        return 'Instagram';
      case ReviewPlatform.trustpilot:
        return 'Trustpilot';
      case ReviewPlatform.yelp:
        return 'Yelp';
      case ReviewPlatform.other:
        return 'Other Platform';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case CampaignStatus.draft:
        return 'Draft';
      case CampaignStatus.active:
        return 'Active';
      case CampaignStatus.paused:
        return 'Paused';
      case CampaignStatus.completed:
        return 'Completed';
      case CampaignStatus.expired:
        return 'Expired';
      case CampaignStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  String toString() {
    return 'CampaignModel(id: $id, title: $title, status: $status, platform: $platform)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CampaignModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}