import 'UserNicknameAndPhotoURL.dart';

class NestedComment{
  int id;
  String comment;
  UserNicknameAndPhotoURL user;
  int comment_id;
  int user_id;
  final List<NestNestComment> commentList;
  DateTime createdAt;

  NestedComment({
    required this.id,
    required this.comment,
    required this.user,
    required this.comment_id,
    required this.user_id,
    required this.commentList,
    required this.createdAt,
  });

  factory NestedComment.fromJson(Map<String, dynamic> json){
    return NestedComment(
      id: json['id'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      user: UserNicknameAndPhotoURL.fromJson(json['User']),
      comment_id: json['comment_id'],
      commentList: json['NestNestComments'] == null ? <NestNestComment>[] : List.from(json['NestNestComments']).map((comment) => NestNestComment.fromJson(comment)).toList(),
      user_id: json['user_id'],
    );
  }
}

class NestNestComment{
  final int id;
  final String comment;
  final DateTime createdAt;
  final UserNicknameAndPhotoURL user;
  final int nested_comment_id;
  final int user_id;

  NestNestComment({
    required this.id,
    required this.comment,
    required this.user,
    required this.nested_comment_id,
    required this.user_id,
    required this.createdAt,
  });

  factory NestNestComment.fromJson(Map<String, dynamic> json) => NestNestComment(
    id: json['id'],
    comment: json['comment'],
    createdAt: DateTime.parse(json['createdAt']),
    user: UserNicknameAndPhotoURL.fromJson(json['User']),
    nested_comment_id: json['nested_comment_id'],
    user_id: json['user_id'],
  );
}