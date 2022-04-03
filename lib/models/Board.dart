import 'dart:convert';

import 'BoardComment.dart';
import 'Like.dart';
import 'User.dart';

class Board{
  final int? id;
  final int userId;
  final String title;
  final String description;
  final String location;
  final String category;
  final int? view_count;
  final User? user;
  final List<String>? board_photos;
  final List<Like>? likeList;
  final List<BoardComment>? commentList;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Board({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    this.view_count,
    this.user,
    required this.board_photos,
    this.likeList,
    this.commentList,
    this.createdAt,
    this.updatedAt,
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
    user: User.fromJson(json['User']),
    board_photos: List.from(jsonDecode(json['board_photos'])),
    likeList: List.from(json['BoardLikes']).map((data) => Like.fromJson(data)).toList(),
    commentList: List.from(json['Comments']).map((comment) => BoardComment.fromJson(comment)).toList(),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
  );

  factory Board.fromDatabase(Map<String, dynamic> json) => Board(
    id: json['id'],
    userId: json['user_id'],
    title: json['title'],
    description: json['description'],
    location: json['location'],
    category: json['category'],
    view_count: json['view_count'],
    user: User.fromNicknameAndPhotoURL(jsonDecode(json['User'])),
    board_photos: List.from(jsonDecode(json['board_photos'])),
    likeList: List.from(jsonDecode(json['BoardLikes'])).map((like) => Like.fromJson(like)).toList(),
    commentList: List.from(jsonDecode(json['Comments'])).map((comment) => BoardComment.fromJson(comment)).toList(),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'title': title,
    'description': description,
    'location': location,
    'category': category,
    'view_count': view_count,
    'User': jsonEncode(user!.toDatabase()),
    'board_photos': jsonEncode(board_photos),
    'BoardLikes': jsonEncode(likeList),
    'Comments': jsonEncode(commentList),
    'createdAt': createdAt == null ? DateTime.now().toIso8601String() : createdAt!.toIso8601String(),
    'updatedAt': updatedAt == null ? DateTime.now().toIso8601String() : updatedAt!.toIso8601String(),
    'deletedAt': deletedAt == null ? DateTime.now().toIso8601String() : deletedAt!.toIso8601String(),
  };


  Map<String, dynamic> insert() => {
    'user_id': userId,
    'title': title,
    'description': description,
    'location': location,
    'category': category,
  };
}