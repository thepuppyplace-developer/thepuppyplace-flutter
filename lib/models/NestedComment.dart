import 'dart:convert';

import 'User.dart';

class NestedComment{
  int? id;
  String comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  User? user;
  int? comment_id;
  int? user_id;

  NestedComment({
    this.id,
    required this.comment,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
    this.comment_id,
    this.user_id
  });

  factory NestedComment.fromJson(Map<String, dynamic> json) => NestedComment(
    id: json['id'],
    comment: json['comment'],
    createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
    user: User.fromNicknameAndPhotoURL(json['User']),
    comment_id: json['comment_id'],
    user_id: json['user_id'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'comment': comment,
    'createdAt': createdAt == null ? null : createdAt!.toIso8601String(),
    'updatedAt': updatedAt == null ? null : updatedAt!.toIso8601String(),
    'deletedAt': deletedAt == null ? null : deletedAt!.toIso8601String(),
    'User': user,
    'comment_id': comment_id,
    'user_id': user_id
  };
}