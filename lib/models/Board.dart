import 'dart:convert';

import 'BoardComment.dart';
import 'Like.dart';
import 'User.dart';

class Board{
  final int? boardId;
  final int userId;
  final String title;
  final String description;
  final String location;
  final String category;
  final int? viewCount;
  final User? user;
  final List<String> photoList;
  final List<Like>? likeList;
  final List<BoardComment>? commentList;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Board({
    this.boardId,
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    this.viewCount,
    this.user,
    required this.photoList,
    this.likeList,
    this.commentList,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Board.fromJson(Map<String, dynamic> json) => Board(
    boardId: json['id'],
    userId: json['user_id'],
    title: json['title'],
    description: json['description'],
    location: json['location'],
    category: json['category'],
    viewCount: json['view_count'],
    user: User.fromJson(json['User']),
    photoList: List.from(jsonDecode(json['board_photos'])),
    likeList: List.from(json['BoardLikes']).map((data) => Like.fromJson(data)).toList(),
    commentList: List.from(json['Comments']).map((data) => BoardComment.fromJson(data)).toList(),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
  );

  factory Board.fromDatabase(Map<String, dynamic> json) => Board(
    boardId: json['id'],
    userId: json['user_id'],
    title: json['title'],
    description: json['description'],
    location: json['location'],
    category: json['category'],
    viewCount: json['view_count'],
    user: User.fromJson(jsonDecode(json['User'])),
    photoList: List.from(jsonDecode(json['board_photos'])),
    likeList: List.from(jsonDecode(json['BoardLikes'])).map((data) => Like.fromJson(data)).toList(),
    commentList: List.from(jsonDecode(json['Comments'])).map((data) => BoardComment.fromJson(data)).toList(),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': boardId,
    'user_id': userId,
    'title': title,
    'description': description,
    'location': location,
    'category': category,
    'view_count': viewCount,
    'User': user == null ? null : user!.toString(),
    'board_photos': photoList.toString(),
    'BoardLikes': likeList.toString(),
    'Comments': commentList.toString(),
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
    'photo_list': photoList
  };
}