import 'NestedComment.dart';
import 'User.dart';

class BoardComment{
  int? commentId;
  String comment;
  int? userId;
  int boardId;
  User? user;
  List<NestedComment>? nestedCommentList;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  BoardComment({
    this.commentId,
    required this.comment,
    this.userId,
    required this.boardId,
    this.user,
    this.nestedCommentList,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory BoardComment.fromJson(Map<String, dynamic> json) => BoardComment(
    commentId: json['id'],
    comment: json['comment'],
    userId: json['user_id'],
    boardId: json['board_id'],
    user: User.fromNicknameAndPhotoURL(json['User']),
    nestedCommentList: List.from(json['NestedComments']).map((comment) => NestedComment.fromJson(comment)).toList(),
    createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
  );

  Map<String, dynamic> toJson() => {
    'comment': comment,
    'board_id': boardId,
  };
}