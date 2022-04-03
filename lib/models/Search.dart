class Search{
  final int? id;
  final String keyword;
  final DateTime? createdAt;

  Search({
    this.id,
    required this.keyword,
    this.createdAt
  });

  factory Search.fromJson(Map<String, dynamic> json) => Search(
      id: json['id'],
      keyword: json['keyword'],
      createdAt: json['createdAt']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'keyword': keyword,
    'createdAt': DateTime.now().toIso8601String()
  };
}