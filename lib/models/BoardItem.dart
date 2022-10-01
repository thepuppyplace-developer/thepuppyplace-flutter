import 'dart:convert';

class BoardItem{
  final String title;
  final List<String> photoList;

  BoardItem({
    required this.title,
    required this.photoList
  });

  factory BoardItem.fromJson(Map<String, dynamic> json) => BoardItem(
      title: json['title'],
      photoList: List<String>.from(jsonDecode(json['board_photos']))
  );
}