import 'Member.dart';
import 'UserNicknameAndPhotoURL.dart';

class NestedComment{
  int id;
  String comment;
  UserNicknameAndPhotoURL user;
  int comment_id;
  int user_id;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

  NestedComment({
    required this.id,
    required this.comment,
    required this.user,
    required this.comment_id,
    required this.user_id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory NestedComment.fromJson(Map<String, dynamic> json) => NestedComment(
    id: json['id'],
    comment: json['comment'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
    user: UserNicknameAndPhotoURL.fromJson(json['User']),
    comment_id: json['comment_id'],
    user_id: json['user_id'],
  );
}