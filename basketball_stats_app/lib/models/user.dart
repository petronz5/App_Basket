// lib/models/user.dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String? id;
  final String username;
  final String email;
  final String token;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.token,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
