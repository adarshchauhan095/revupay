// lib/models/wallet_transaction_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { credit, debit }
enum TransactionStatus { pending, completed, failed, cancelled }

class WalletTransactionModel {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final String description;
  final TransactionStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? campaignId;
  final String? submissionId;
  final String? withdrawalMethod; // 'upi', 'bank', etc.
  final Map<String, dynamic>? withdrawalDetails;
  final String? transactionId; // External transaction ID
  final String? failureReason;
  final Map<String, dynamic>? metadata;

  WalletTransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.description,
    this.status = TransactionStatus.pending,
    required this.createdAt,
    this.completedAt,
    this.campaignId,
    this.submissionId,
    this.withdrawalMethod,
    this.withdrawalDetails,
    this.transactionId,
    this.failureReason,
    this.metadata,
  });

  factory WalletTransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return WalletTransactionModel(
      id: id,
      userId: map['userId'] ?? '',
      type: _parseType(map['type']),
      amount: (map['amount'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      status: _parseStatus(map['status']),
      createdAt: _parseDateTime(map['createdAt'])??DateTime.now(),
      completedAt: _parseDateTime(map['completedAt']),
      campaignId: map['campaignId'],
      submissionId: map['submissionId'],
      withdrawalMethod: map['withdrawalMethod'],
      withdrawalDetails: map['withdrawalDetails'],
      transactionId: map['transactionId'],
      failureReason: map['failureReason'],
      metadata: map['metadata'],
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
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'campaignId': campaignId,
      'submissionId': submissionId,
      'withdrawalMethod': withdrawalMethod,
      'withdrawalDetails': withdrawalDetails,
      'transactionId': transactionId,
      'failureReason': failureReason,
      'metadata': metadata,
    };
  }

  WalletTransactionModel copyWith({
    String? id,
    String? userId,
    TransactionType? type,
    double? amount,
    String? description,
    TransactionStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
    String? campaignId,
    String? submissionId,
    String? withdrawalMethod,
    Map<String, dynamic>? withdrawalDetails,
    String? transactionId,
    String? failureReason,
    Map<String, dynamic>? metadata,
  }) {
    return WalletTransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      campaignId: campaignId ?? this.campaignId,
      submissionId: submissionId ?? this.submissionId,
      withdrawalMethod: withdrawalMethod ?? this.withdrawalMethod,
      withdrawalDetails: withdrawalDetails ?? this.withdrawalDetails,
      transactionId: transactionId ?? this.transactionId,
      failureReason: failureReason ?? this.failureReason,
      metadata: metadata ?? this.metadata,
    );
  }

  static TransactionType _parseType(dynamic type) {
    if (type is String) {
      switch (type.toLowerCase()) {
        case 'credit':
          return TransactionType.credit;
        case 'debit':
          return TransactionType.debit;
        default:
          return TransactionType.credit;
      }
    }
    return TransactionType.credit;
  }

  static TransactionStatus _parseStatus(dynamic status) {
    if (status is String) {
      switch (status.toLowerCase()) {
        case 'pending':
          return TransactionStatus.pending;
        case 'completed':
          return TransactionStatus.completed;
        case 'failed':
          return TransactionStatus.failed;
        case 'cancelled':
          return TransactionStatus.cancelled;
        default:
          return TransactionStatus.pending;
      }
    }
    return TransactionStatus.pending;
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
  bool get isCredit => type == TransactionType.credit;
  bool get isDebit => type == TransactionType.debit;
  bool get isPending => status == TransactionStatus.pending;
  bool get isCompleted => status == TransactionStatus.completed;
  bool get isFailed => status == TransactionStatus.failed;
  bool get isCancelled => status == TransactionStatus.cancelled;
  bool get isWithdrawal => withdrawalMethod != null;

  String get typeDisplayName {
    switch (type) {
      case TransactionType.credit:
        return 'Credit';
      case TransactionType.debit:
        return 'Debit';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get formattedAmount {
    final sign = isCredit ? '+' : '-';
    return '$sign₹${amount.toStringAsFixed(2)}';
  }

  String get shortDescription {
    if (description.length <= 50) return description;
    return '${description.substring(0, 47)}...';
  }

  // Factory methods for common transaction types
  factory WalletTransactionModel.reviewPayment({
    required String userId,
    required double amount,
    required String campaignId,
    required String submissionId,
    String? campaignTitle,
  }) {
    return WalletTransactionModel(
      id: '', // Will be set when saved to Firestore
      userId: userId,
      type: TransactionType.credit,
      amount: amount,
      description: campaignTitle != null
          ? 'Review approved for: $campaignTitle'
          : 'Review payment received',
      status: TransactionStatus.completed,
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
      campaignId: campaignId,
      submissionId: submissionId,
    );
  }

  factory WalletTransactionModel.withdrawal({
    required String userId,
    required double amount,
    required String withdrawalMethod,
    required Map<String, dynamic> withdrawalDetails,
  }) {
    return WalletTransactionModel(
      id: '', // Will be set when saved to Firestore
      userId: userId,
      type: TransactionType.debit,
      amount: amount,
      description: 'Withdrawal to ${withdrawalMethod.toUpperCase()}',
      status: TransactionStatus.pending,
      createdAt: DateTime.now(),
      withdrawalMethod: withdrawalMethod,
      withdrawalDetails: withdrawalDetails,
    );
  }

  factory WalletTransactionModel.dailyBonus({
    required String userId,
    required double amount,
  }) {
    return WalletTransactionModel(
      id: '', // Will be set when saved to Firestore
      userId: userId,
      type: TransactionType.credit,
      amount: amount,
      description: 'Daily login bonus',
      status: TransactionStatus.completed,
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
    );
  }

  factory WalletTransactionModel.refund({
    required String userId,
    required double amount,
    required String reason,
    String? campaignId,
  }) {
    return WalletTransactionModel(
      id: '', // Will be set when saved to Firestore
      userId: userId,
      type: TransactionType.credit,
      amount: amount,
      description: 'Refund: $reason',
      status: TransactionStatus.completed,
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
      campaignId: campaignId,
    );
  }

  @override
  String toString() {
    return 'WalletTransactionModel(id: $id, type: $type, amount: $amount, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WalletTransactionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}