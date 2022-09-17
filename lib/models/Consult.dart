import 'dart:convert';

class Consult{
  final int consultId;
  final int? userId;
  final String title;
  final String description;
  final List<String> photoList;
  String? answer;
  final DateTime createdAt;
  final DateTime updatedAt;

  Consult({
    required this.consultId,
    required this.userId,
    required this.title,
    required this.description,
    required this.photoList,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Consult.fromJson(Map<String, dynamic> json) => Consult(
    consultId: json['id'],
    userId: json['user_id'],
    title: json['title'],
    description: json['description'],
    photoList: List<String>.from(json['consult_photos'].runtimeType == String ? jsonDecode(json['consult_photos']) : json['consult_photos']),
    answer: json['answer'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}