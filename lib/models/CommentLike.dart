import 'Board.dart';

class CommentLike{
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int comment_id;
  final int user_id;

  CommentLike({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.comment_id,
    required this.user_id,
  });

  factory CommentLike.fromJson(Map<String, dynamic> json) => CommentLike(
    id: json['id'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    comment_id: json['comment_id'],
    user_id: json['user_id'],
  );
}