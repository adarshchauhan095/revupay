// lib/models/review_submission_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum SubmissionStatus { pending, approved, rejected, under_review }

class ReviewSubmissionModel {
  final String id;
  final String userId;
  final String campaignId;
  final String companyId;
  final String reviewText;
  final int rating;
  final List<String> proofImages;
  final String? reviewScreenshot;
  final String? reviewUrl;
  final SubmissionStatus status;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? reviewMessage;
  final String? reviewedBy;
  final double amount;
  final Map<String, dynamic>? additionalData;

  ReviewSubmissionModel({
    required this.id,
    required this.userId,
    required this.campaignId,
    required this.companyId,
    required this.reviewText,
    required this.rating,
    this.proofImages = const [],
    this.reviewScreenshot,
    this.reviewUrl,
    this.status = SubmissionStatus.pending,
    required this.submittedAt,
    this.reviewedAt,
    this.reviewMessage,
    this.reviewedBy,
    required this.amount,
    this.additionalData,
  });

  factory ReviewSubmissionModel.fromMap(Map<String, dynamic> map, String id) {
    return ReviewSubmissionModel(
      id: id,
      userId: map['userId'] ?? '',
      campaignId: map['campaignId'] ?? '',
      companyId: map['companyId'] ?? '',
      reviewText: map['reviewText'] ?? '',
      rating: map['rating'] ?? 5,
      proofImages: List<String>.from(map['proofImages'] ?? []),
      reviewScreenshot: map['reviewScreenshot'],
      reviewUrl: map['reviewUrl'],
      status: _parseStatus(map['status']),
      submittedAt: _parseDateTime(map['submittedAt'])??DateTime.now(),
      reviewedAt: _parseDateTime(map['reviewedAt']),
      reviewMessage: map['reviewMessage'],
      reviewedBy: map['reviewedBy'],
      amount: (map['amount'] ?? 0.0).toDouble(),
      additionalData: map['additionalData'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'campaignId': campaignId,
      'companyId': companyId,
      'reviewText': reviewText,
      'rating': rating,
      'proofImages': proofImages,
      'reviewScreenshot': reviewScreenshot,
      'reviewUrl': reviewUrl,
      'status': status.toString().split('.').last,
      'submittedAt': submittedAt.millisecondsSinceEpoch,
      'reviewedAt': reviewedAt?.millisecondsSinceEpoch,
      'reviewMessage': reviewMessage,
      'reviewedBy': reviewedBy,
      'amount': amount,
      'additionalData': additionalData,
    };
  }

  ReviewSubmissionModel copyWith({
    String? id,
    String? userId,
    String? campaignId,
    String? companyId,
    String? reviewText,
    int? rating,
    List<String>? proofImages,
    String? reviewScreenshot,
    String? reviewUrl,
    SubmissionStatus? status,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    String? reviewMessage,
    String? reviewedBy,
    double? amount,
    Map<String, dynamic>? additionalData,
  }) {
    return ReviewSubmissionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      campaignId: campaignId ?? this.campaignId,
      companyId: companyId ?? this.companyId,
      reviewText: reviewText ?? this.reviewText,
      rating: rating ?? this.rating,
      proofImages: proofImages ?? this.proofImages,
      reviewScreenshot: reviewScreenshot ?? this.reviewScreenshot,
      reviewUrl: reviewUrl ?? this.reviewUrl,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewMessage: reviewMessage ?? this.reviewMessage,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      amount: amount ?? this.amount,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  static SubmissionStatus _parseStatus(dynamic status) {
    if (status is String) {
      switch (status.toLowerCase()) {
        case 'pending':
          return SubmissionStatus.pending;
        case 'approved':
          return SubmissionStatus.approved;
        case 'rejected':
          return SubmissionStatus.rejected;
        case 'under_review':
          return SubmissionStatus.under_review;
        default:
          return SubmissionStatus.pending;
      }
    }
    return SubmissionStatus.pending;
  }

  static DateTime? _parseDateTime(dynamic timestamp) {
    if (timestamp == null) return null;

    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else if (timestamp is DateTime) {
      return timestamp;
    }

    return null;
  }

  // Getters for computed properties
  bool get isPending => status == SubmissionStatus.pending;
  bool get isApproved => status == SubmissionStatus.approved;
  bool get isRejected => status == SubmissionStatus.rejected;
  bool get isUnderReview => status == SubmissionStatus.under_review;

  String get statusDisplayName {
    switch (status) {
      case SubmissionStatus.pending:
        return 'Pending Review';
      case SubmissionStatus.approved:
        return 'Approved';
      case SubmissionStatus.rejected:
        return 'Rejected';
      case SubmissionStatus.under_review:
        return 'Under Review';
    }
  }

  String get ratingStars {
    return '★' * rating + '☆' * (5 - rating);
  }

  String get shortReviewText {
    if (reviewText.length <= 100) return reviewText;
    return '${reviewText.substring(0, 97)}...';
  }

  Duration get timeSinceSubmission {
    return DateTime.now().difference(submittedAt);
  }

  bool get hasProofImages => proofImages.isNotEmpty;
  bool get hasReviewScreenshot => reviewScreenshot != null && reviewScreenshot!.isNotEmpty;
  bool get hasReviewUrl => reviewUrl != null && reviewUrl!.isNotEmpty;

  @override
  String toString() {
    return 'ReviewSubmissionModel(id: $id, status: $status, rating: $rating, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReviewSubmissionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}