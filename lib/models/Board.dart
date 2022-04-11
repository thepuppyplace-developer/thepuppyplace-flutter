import 'dart:convert';
import 'dart:io';

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

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'title': title,
    'description': description,
    'location': location,
    'category': category,
    'images': board_photos!.map((photo) => File.new(photo)).toList(),
  };
}