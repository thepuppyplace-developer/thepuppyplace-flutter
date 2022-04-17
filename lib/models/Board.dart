import 'dart:convert';
import 'BoardComment.dart';
import 'Like.dart';
import 'UserNicknameAndPhotoURL.dart';

class Board{
  final int id;
  final int userId;
  final String title;
  final String description;
  final String location;
  final String category;
  final int view_count;
  final UserNicknameAndPhotoURL user;
  final List<String> board_photos;
  final List<Like> likeList;
  final List<BoardComment> commentList;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Board({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    required this.view_count,
    required this.user,
    required this.board_photos,
    required this.likeList,
    required this.commentList,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Board.fromJson(Map<String, dynamic> json) => Board(
    id: json['id'],
    userId: json['user_id'],
    title: json['title'],
    description: json['description'],
    location: json['location'],
    category: json['category'],
    view_count: json['view_count'],
    user: UserNicknameAndPhotoURL.fromJson(json['User']),
    board_photos: List.from(jsonDecode(json['board_photos'])),
    likeList: List.from(json['BoardLikes']).map((data) => Like.fromJson(data)).toList(),
    commentList: List.from(json['Comments']).map((comment) => BoardComment.fromJson(comment)).toList(),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
  );
}