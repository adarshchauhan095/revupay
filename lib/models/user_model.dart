// lib/models/user_model.dart
class UserModel {
  final String id;
  final String email;
  final String? phone;
  final String name;
  final UserRole role;
  final double walletBalance;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isActive;
  final String? profileImageUrl;
  final Map<String, dynamic>? additionalInfo;

  UserModel({
    required this.id,
    required this.email,
    this.phone,
    required this.name,
    required this.role,
    this.walletBalance = 0.0,
    required this.createdAt,
    this.lastLogin,
    this.isActive = true,
    this.profileImageUrl,
    this.additionalInfo,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      phone: map['phone'],
      name: map['name'] ?? '',
      role: UserRole.values.firstWhere(
            (e) => e.toString().split('.').last == map['role'],
        orElse: () => UserRole.user,
      ),
      walletBalance: (map['walletBalance'] ?? 0.0).toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      lastLogin: map['lastLogin'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastLogin'])
          : null,
      isActive: map['isActive'] ?? true,
      profileImageUrl: map['profileImageUrl'],
      additionalInfo: map['additionalInfo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phone': phone,
      'name': name,
      'role': role.toString().split('.').last,
      'walletBalance': walletBalance,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLogin': lastLogin?.millisecondsSinceEpoch,
      'isActive': isActive,
      'profileImageUrl': profileImageUrl,
      'additionalInfo': additionalInfo,
    };
  }
}

enum UserRole { user, company, admin }