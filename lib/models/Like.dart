import 'User.dart';
import 'UserNicknameAndPhotoURL.dart';

class Like{
  final int? likeId;
  final int boardId;
  final int userId;
  final UserNicknameAndPhotoURL? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Like({
    this.likeId,
    required this.boardId,
    required this.userId,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) => Like(
    likeId: json['id'],
    boardId: json['board_id'],
    userId: json['user_id'],
    user: json['User'] == null ? null : UserNicknameAndPhotoURL.fromJson(json['User']),
    createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
  );
}