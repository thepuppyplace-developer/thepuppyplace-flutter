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
      id: json[ID],
      category: json[CATEGORY],
      image_url: json[IMAGE_URL],
      createdAt: DateTime.parse(json[CRETAED_AT]),
      updatedAt: DateTime.parse(json[UPDATED_AT]),
      deletedAt: DateTime.parse(json[DELETED_AT])
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    ID: id,
    CATEGORY: category,
    IMAGE_URL: image_url,
    CRETAED_AT: createdAt,
    UPDATED_AT: updatedAt,
    DELETED_AT: deletedAt,
  };

  static const String TABLE = 'BoardCategory';

  static const String ID = 'id';
  static const String CATEGORY = 'category';
  static const String IMAGE_URL = 'image_url';
  static const String CRETAED_AT = 'createdAt';
  static const String UPDATED_AT = 'updatedAt';
  static const String DELETED_AT = 'deletedAt';

  static String get CREATE_TABLE => '''
  CREATE TABLE IF NOT EXISTS $TABLE(
  $ID INTEGER NOT NULL,
  $CATEGORY STRING NOT NULL,
  $IMAGE_URL STRING NOT NULL,
  $CRETAED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  $UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  $DELETED_AT TIMESTAMP NOT NULL,
  PRIMARY KEY($ID)
  )
  ''';

  static String get TRIGGER => '''
  CREATE TRIGGER ${TABLE}_${UPDATED_AT}_TRIGGER
  AFTER UPDATE ON $TABLE
  BEGIN UPDATE $TABLE SET $UPDATED_AT = CURRENT_TIMESTAMP WHERE $ID = NEW.$ID; END
  ''';

  static String get INSERT_CATEGORIES => '''
  INSERT INTO 
  ''';
}