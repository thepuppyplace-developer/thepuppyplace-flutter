class Notice{
  final int? id;
  final String notice_title;
  final String notice_main_text;
  final String? image_url;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Notice({
    required this.id,
    required this.notice_title,
    required this.notice_main_text,
    required this.image_url,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    json.removeWhere((key, value) => value == null);
    return Notice(
      id: json['id'],
      notice_title: json['notice_title'],
      notice_main_text: json['notice_main_text'],
      image_url: json['image_url'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
    );
  }

  Map<String, dynamic> toJson(){
    final map = <String, dynamic>{
      'id': id,
      'notice_title': notice_title,
      'notice_main_text': notice_main_text,
      'image_url': image_url,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt == null ? null : deletedAt!.toIso8601String(),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }
}