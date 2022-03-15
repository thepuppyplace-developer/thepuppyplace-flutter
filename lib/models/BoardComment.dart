import 'User.dart';

class BoardComment{
  int? comment_id;
  String comment;
  int user_id;
  int board_id;
  User? user;
  DateTime? createdAt;
  DateTime? updatedAt;

  BoardComment({
    this.comment_id,
    required this.comment,
    required this.user_id,
    required this.board_id,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory BoardComment.fromJson(Map<String, dynamic> json) => BoardComment(
    comment_id: json['id'],
    comment: json['comment'],
    user_id: json['user_id'],
    board_id: json['board_id'],
    user: User.fromJson(json['User']),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': comment_id,
    'comment': comment,
    'user_id': user_id,
    'board_id': board_id,
  };
}