import 'User.dart';

class Like{
  final int? likeId;
  final int boardId;
  final int userId;
  final User? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Like({
    this.likeId,
    required this.boardId,
    required this.userId,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) => Like(
    likeId: json['id'],
    boardId: json['board_id'],
    userId: json['user_id'],
    user: User.fromJson(json['User']),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'board_id': boardId,
    'user_id': userId,
  };
}