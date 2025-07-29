// lib/models/user_model.dart
import 'dart:convert';

enum UserRole { user, company, admin }

class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? phone;
  final String? profileImageUrl;
  final double walletBalance;
  final bool isActive;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final String? fcmToken;
  final Map<String, dynamic>? preferences;
  final Map<String, dynamic>? businessInfo;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phone,
    this.profileImageUrl,
    this.walletBalance = 0.0,
    this.isActive = true,
    this.isVerified = false,
    required this.createdAt,
    this.lastLogin,
    this.fcmToken,
    this.preferences,
    this.businessInfo,
  });

  factory UserModel.fromJson(String jsonStr) {
    final map = json.decode(jsonStr);
    return UserModel.fromMap(map, map['id']);
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: _parseRole(map['role']),
      phone: map['phone'],
      profileImageUrl: map['profileImageUrl'],
      walletBalance: (map['walletBalance'] ?? 0.0).toDouble(),
      isActive: map['isActive'] ?? true,
      isVerified: map['isVerified'] ?? false,
      createdAt: _parseDateTime(map['createdAt']),
      lastLogin: _parseDateTime(map['lastLogin']),
      fcmToken: map['fcmToken'],
      preferences: map['preferences'] != null
          ? Map<String, dynamic>.from(map['preferences'])
          : null,
      businessInfo: map['businessInfo'] != null
          ? Map<String, dynamic>.from(map['businessInfo'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'walletBalance': walletBalance,
      'isActive': isActive,
      'isVerified': isVerified,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLogin': lastLogin?.millisecondsSinceEpoch,
      'fcmToken': fcmToken,
      'preferences': preferences,
      'businessInfo': businessInfo,
    };
  }

  String toJson() => json.encode(toMap());

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? phone,
    String? profileImageUrl,
    double? walletBalance,
    bool? isActive,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? lastLogin,
    String? fcmToken,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? businessInfo,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      walletBalance: walletBalance ?? this.walletBalance,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      fcmToken: fcmToken ?? this.fcmToken,
      preferences: preferences ?? this.preferences,
      businessInfo: businessInfo ?? this.businessInfo,
    );
  }

  static UserRole _parseRole(dynamic role) {
    if (role is String) {
      switch (role.toLowerCase()) {
        case 'admin':
          return UserRole.admin;
        case 'company':
          return UserRole.company;
        case 'user':
        default:
          return UserRole.user;
      }
    }
    return UserRole.user;
  }

  static DateTime _parseDateTime(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();

    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else if (timestamp is DateTime) {
      return timestamp;
    }

    return DateTime.now();
  }

  // Getters for computed properties
  bool get isCompany => role == UserRole.company;
  bool get isAdmin => role == UserRole.admin;
  bool get isRegularUser => role == UserRole.user;

  String get displayName => name.isNotEmpty ? name : email.split('@').first;

  String get roleDisplayName {
    switch (role) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.company:
        return 'Business';
      case UserRole.user:
        return 'User';
    }
  }

  bool get canWithdraw => walletBalance >= 10.0;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}