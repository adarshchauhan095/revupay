
// lib/app/data/models/user_model.dart
class UserModel {
  final String? id;
  final String? email;
  final String? phone;
  final String? role;
  final String? name;
  final double? wallet;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.role,
    required this.name,
    required this.wallet,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      name: json['name'],
      wallet: (json['wallet'] ?? 0.0).toDouble(),
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'role': role,
      'name': name,
      'wallet': wallet,
      'createdAt': createdAt,
    };
  }
}
