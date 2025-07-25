// lib/models/wallet_transaction_model.dart
class WalletTransactionModel {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final String description;
  final TransactionStatus status;
  final DateTime createdAt;
  final String? campaignId;
  final String? submissionId;
  final Map<String, dynamic>? withdrawalDetails;

  WalletTransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.description,
    this.status = TransactionStatus.completed,
    required this.createdAt,
    this.campaignId,
    this.submissionId,
    this.withdrawalDetails,
  });

  factory WalletTransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return WalletTransactionModel(
      id: id,
      userId: map['userId'] ?? '',
      type: TransactionType.values.firstWhere(
            (e) => e.toString().split('.').last == map['type'],
        orElse: () => TransactionType.credit,
      ),
      amount: (map['amount'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      status: TransactionStatus.values.firstWhere(
            (e) => e.toString().split('.').last == map['status'],
        orElse: () => TransactionStatus.completed,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      campaignId: map['campaignId'],
      submissionId: map['submissionId'],
      withdrawalDetails: map['withdrawalDetails'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type.toString().split('.').last,
      'amount': amount,
      'description': description,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'campaignId': campaignId,
      'submissionId': submissionId,
      'withdrawalDetails': withdrawalDetails,
    };
  }
}

enum TransactionType { credit, debit }
enum TransactionStatus { pending, completed, failed, cancelled }