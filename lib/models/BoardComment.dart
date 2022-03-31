import 'User.dart';

class BoardComment{
  int? commentId;
  String comment;
  int userId;
  int boardId;
  User? user;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  BoardComment({
    this.commentId,
    required this.comment,
    required this.userId,
    required this.boardId,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory BoardComment.fromJson(Map<String, dynamic> json) => BoardComment(
    commentId: json['id'],
    comment: json['comment'],
    userId: json['user_id'],
    boardId: json['board_id'],
    user: json['User'] == null ? null : User.fromNicknameAndPhotoURL(json['User']),
    createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': commentId,
    'comment': comment,
    'user_id': userId,
    'board_id': boardId,
  };
}