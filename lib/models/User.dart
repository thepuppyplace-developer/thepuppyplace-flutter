class User{
  final int id;
  final String email;
  final String nickname;
  final String? name;
  final String? phone_number;
  final String? photo_url;
  final String? gender;
  final String? fcm_token;
  final String? jwt_token;
  final bool is_alarm;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  User({
    required this.id,
    required this.email,
    required this.nickname,
    this.name,
    this.phone_number,
    this.photo_url,
    this.gender,
    this.fcm_token,
    this.jwt_token,
    required this.is_alarm,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json[ID],
    email: json[EMAIL],
    nickname: json[NICKNAME],
    name: json[NAME],
    phone_number: json[PHONE_NUMBER],
    photo_url: json[PHOTO_URL],
    gender: json[GENDER],
    fcm_token: json[FCM_TOKEN],
    jwt_token: json[JWT_TOKEN],
    is_alarm: json[IS_ALARM].runtimeType == int ? json[IS_ALARM] == 1 ? true : false : json[IS_ALARM],
    createdAt: DateTime.parse(json[CREATED_AT]),
    updatedAt: DateTime.parse(json[UPDATED_AT]),
    deletedAt: json[DELETED_AT] == null ? null : DateTime.parse(json[DELETED_AT]),
  );

  Map<String, dynamic> toJson() => {
    ID: id,
    EMAIL: email,
    NICKNAME: nickname,
    NAME: name,
    PHONE_NUMBER: phone_number,
    PHOTO_URL: photo_url,
    GENDER: gender,
    FCM_TOKEN: fcm_token,
    JWT_TOKEN: jwt_token,
    IS_ALARM: is_alarm ? 1 : 0,
    CREATED_AT: createdAt.toIso8601String(),
    UPDATED_AT: updatedAt.toIso8601String(),
    DELETED_AT: deletedAt == null ? null : deletedAt!.toIso8601String(),
  };

  static const String TABLE = 'User';

  static const String ID = 'id';
  static const String EMAIL = 'email';
  static const String NICKNAME = 'nickname';
  static const String NAME = 'name';
  static const String PHONE_NUMBER = 'phone_number';
  static const String PHOTO_URL = 'photo_url';
  static const String GENDER = 'gender';
  static const String FCM_TOKEN = 'fcm_token';
  static const String JWT_TOKEN = 'jwt_token';
  static const String IS_ALARM = 'is_alarm';
  static const String CREATED_AT = 'createdAt';
  static const String UPDATED_AT = 'updatedAt';
  static const String DELETED_AT = 'deletedAt';

  static String get CREATE_TABLE => '''
  CREATE TABLE IF NOT EXISTS $TABLE(
  $ID INTEGER NOT NULL,
  $EMAIL STRING NOT NULL,
  $NICKNAME STRING NOT NULL,
  $NAME STRING,
  $PHONE_NUMBER STRING,
  $PHOTO_URL STRING,
  $GENDER STRING,
  $FCM_TOKEN STRING,
  $JWT_TOKEN STRING,
  $IS_ALARM INTEGER DEFAULT 1 NOT NULL,
  $CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  $UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  $DELETED_AT TIMESTAMP,
  PRIMARY KEY($ID),
  UNIQUE($ID, $EMAIL, $NICKNAME)
  )
  ''';

  static String get TRIGGER => '''
  CREATE TRIGGER ${TABLE}_${UPDATED_AT}_TRIGGER
  AFTER UPDATE ON $TABLE
  BEGIN UPDATE $TABLE SET $UPDATED_AT = CURRENT_TIMESTAMP WHERE $ID = NEW.$ID; END
  ''';
}