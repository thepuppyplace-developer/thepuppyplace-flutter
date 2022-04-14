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
}