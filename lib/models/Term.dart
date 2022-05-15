class Term{
  final int id;
  final String term_title;
  final String term_contents;
  final bool is_require;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Term({
    required this.id,
    required this.term_title,
    required this.term_contents,
    required this.is_require,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Term.fromJson(Map<String, dynamic> json) => Term(
    id: json['id'],
    term_title: json['term_title'],
    term_contents: json['term_contents'],
    is_require: json['is_require'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
  );
}