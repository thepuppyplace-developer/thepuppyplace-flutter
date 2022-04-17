import 'NestedComment.dart';
import 'UserNicknameAndPhotoURL.dart';

class BoardComment{
  int commentId;
  String comment;
  int userId;
  int boardId;
  UserNicknameAndPhotoURL user;
  List<NestedComment> nestedCommentList;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

  BoardComment({
    required this.commentId,
    required this.comment,
    required this.userId,
    required this.boardId,
    required this.user,
    required this.nestedCommentList,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory BoardComment.fromJson(Map<String, dynamic> json) => BoardComment(
    commentId: json['id'],
    comment: json['comment'],
    userId: json['user_id'],
    boardId: json['board_id'],
    user: UserNicknameAndPhotoURL.fromJson(json['User']),
    nestedCommentList: List.from(json['NestedComments']).map((comment) => NestedComment.fromJson(comment)).toList(),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
  );
}