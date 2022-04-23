class BoardCategory{
  final int id;
  final String category;
  final String image_url;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;

  BoardCategory({
    required this.id,
    required this.category,
    required this.image_url,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory BoardCategory.fromJson(Map<String, dynamic> json) => BoardCategory(
      id: json['id'],
      category: json['category'],
      image_url: json['image_url'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: DateTime.parse(json['deletedAt'])
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'category': category,
    'image_url': image_url,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'deletedAt': deletedAt,
  };

  static const String TABLE = 'BoardCategory';
  static String get CREATE_TABLE => '''
  CREATE TABLE IF NOT EXISTS $TABLE(
  id INTEGER NOT NULL,
  category STRING NOT NULL,
  image_url STRING NOT NULL,
  createdAT TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  deletedAt TIMESTAMP NOT NULL,
  PRIMARY KEY(id)
  )
  ''';
}