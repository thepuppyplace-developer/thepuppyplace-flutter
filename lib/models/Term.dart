class Term{
  final int id;
  final String name;
  final String content;
  final bool is_required;
  bool check;

  Term({
    required this.id,
    required this.name,
    required this.content,
    required this.is_required,
    required this.check,
  });

  factory Term.fromJson(Map<String, dynamic> json) => Term(
      id: json[ID],
      name: json[TITLE],
      content: json[CONTENTS],
      is_required: json[IS_REQUIRED],
      check: false
  );

  static const String ID = 'id';
  static const String TITLE = 'term_title';
  static const String CONTENTS = 'term_contents';
  static const String IS_REQUIRED = 'is_require';
}