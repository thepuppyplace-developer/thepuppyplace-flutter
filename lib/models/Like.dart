import 'User.dart';

class Like{
  final int? like_id;
  final int board_id;
  final int user_id;
  final User? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Like({
    this.like_id,
    required this.board_id,
    required this.user_id,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) => Like(
    like_id: json['id'],
    board_id: json['board_id'],
    user_id: json['user_id'],
    user: User.fromJson(json['User']),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'board_id': board_id,
    'user_id': user_id,
  };
}