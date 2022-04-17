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
  final String? location;
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
    this.location,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    nickname: json['nickname'],
    name: json['name'],
    phone_number: json['phone_number'],
    photo_url: json['photo_url'],
    gender: json['gender'],
    fcm_token: json['fcm_token'],
    jwt_token: json['jwt_token'],
    is_alarm: json['is_alarm'].runtimeType == int ? json['is_alarm'] == 1 ? true : false : json['is_alarm'],
    location: json['location'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'nickname': nickname,
    'name': name,
    'phone_number': phone_number,
    'photo_url': photo_url,
    'gender': gender,
    'location': location,
    'fcm_token': fcm_token,
    'jwt_token': jwt_token,
    'is_alarm': is_alarm ? 1 : 0,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'deletedAt': deletedAt == null ? null : deletedAt!.toIso8601String(),
  };
}