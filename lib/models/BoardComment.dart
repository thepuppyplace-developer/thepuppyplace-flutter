import 'User.dart';

class BoardComment{
  int? commentId;
  String comment;
  int userId;
  int boardId;
  User? user;
  DateTime? createdAt;
  DateTime? updatedAt;

  BoardComment({
    this.commentId,
    required this.comment,
    required this.userId,
    required this.boardId,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory BoardComment.fromJson(Map<String, dynamic> json) => BoardComment(
    commentId: json['id'],
    comment: json['comment'],
    userId: json['user_id'],
    boardId: json['board_id'],
    user: User.fromJson(json['User']),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': commentId,
    'comment': comment,
    'user_id': userId,
    'board_id': boardId,
  };
}