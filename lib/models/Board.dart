import 'User.dart';

class Board{
  final int? board_id;
  final int user_id;
  final String title;
  final String description;
  final String location;
  final int? view_count;
  final User? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Board({
    this.board_id,
    required this.user_id,
    required this.title,
    required this.description,
    required this.location,
    this.view_count,
    this.user,
    this.createdAt,
    this.updatedAt
  });

  factory Board.fromJson(Map<String, dynamic> json) => Board(
    board_id: json['id'],
    user_id: json['user_id'],
    title: json['title'],
    description: json['description'],
    location: json['location'],
    view_count: json['view_count'],
    user: User.fromJson(json['user']),
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );

  Map<String, dynamic> toJson() => {
    'user_id': user_id,
    'title': title,
    'description': description,
    'location': location,
  };
}