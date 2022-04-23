class Search{
  final int id;
  final String search_text;
  final int search_count;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Search({
    required this.id,
    required this.search_text,
    required this.search_count,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Search.fromJson(Map<String, dynamic> json) => Search(
    id: json['id'],
    search_text: json['search_text'],
    search_count: json['search_count'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'search_text': search_text,
    'search_count': search_count,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'deletedAt': deletedAt == null ? null : deletedAt!.toIso8601String(),
  };

  static const String TABLE = 'Search';
  static String get CREATE_TABLE => '''
  CREATE TABLE IF NOT EXISTS $TABLE(
  id INTEGER NOT NULL,
  search_text STRING NOT NULL,
  )
  ''';
}