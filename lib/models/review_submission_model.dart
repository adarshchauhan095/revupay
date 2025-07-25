// lib/models/review_submission_model.dart
class ReviewSubmissionModel {
  final String id;
  final String userId;
  final String userName;
  final String campaignId;
  final String campaignTitle;
  final String companyId;
  final List<String> proofImages;
  final String? comment;
  final double amount;
  final SubmissionStatus status;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? reviewMessage;

  ReviewSubmissionModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.campaignId,
    required this.campaignTitle,
    required this.companyId,
    required this.proofImages,
    this.comment,
    required this.amount,
    this.status = SubmissionStatus.pending,
    required this.submittedAt,
    this.reviewedAt,
    this.reviewMessage,
  });

  factory ReviewSubmissionModel.fromMap(Map<String, dynamic> map, String id) {
    return ReviewSubmissionModel(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      campaignId: map['campaignId'] ?? '',
      campaignTitle: map['campaignTitle'] ?? '',
      companyId: map['companyId'] ?? '',
      proofImages: List<String>.from(map['proofImages'] ?? []),
      comment: map['comment'],
      amount: (map['amount'] ?? 0.0).toDouble(),
      status: SubmissionStatus.values.firstWhere(
            (e) => e.toString().split('.').last == map['status'],
        orElse: () => SubmissionStatus.pending,
      ),
      submittedAt: DateTime.fromMillisecondsSinceEpoch(map['submittedAt']),
      reviewedAt: map['reviewedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['reviewedAt'])
          : null,
      reviewMessage: map['reviewMessage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'campaignId': campaignId,
      'campaignTitle': campaignTitle,
      'companyId': companyId,
      'proofImages': proofImages,
      'comment': comment,
      'amount': amount,
      'status': status.toString().split('.').last,
      'submittedAt': submittedAt.millisecondsSinceEpoch,
      'reviewedAt': reviewedAt?.millisecondsSinceEpoch,
      'reviewMessage': reviewMessage,
    };
  }
}

enum SubmissionStatus { pending, approved, rejected }