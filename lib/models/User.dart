class User{
  final int? id;
  final String? email;
  final String? password;
  final String? nickname;
  final String? name;
  final String? phone_number;
  final String? photo_url;
  final String? gender;
  final String? fcm_token;
  final bool? is_alarm;
  final String? location;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  User({
    this.id,
    this.email,
    this.password,
    this.nickname,
    this.name,
    this.phone_number,
    this.photo_url,
    this.gender,
    this.fcm_token,
    this.is_alarm,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    password: json['password'],
    nickname: json['nickname'],
    name: json['name'],
    phone_number: json['phone_number'],
    photo_url: json['photo_url'],
    gender: json['gender'],
    fcm_token: json['fcm_token'],
    is_alarm: json['is_alarm'],
    location: json['location'],
    createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
  );

  factory User.fromNicknameAndPhotoURL(Map<String, dynamic> json) => User(
    nickname: json['nickname'],
    photo_url: json['photo_url'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'password': password,
    'nickname': nickname,
    'name': name,
    'phone_number': phone_number,
    'photo_url': photo_url,
    'gender': gender,
    'location': location,
    'fmc_token': fcm_token,
    'is_alarm': is_alarm! ? 0 : 1,
    'createdAt': createdAt == null ? null : createdAt!.toIso8601String(),
    'updatedAt': updatedAt == null ? null : updatedAt!.toIso8601String(),
    'deletedAt': deletedAt == null ? null : deletedAt!.toIso8601String(),
  };

  Map<String, dynamic> toDatabase() => {
    'nickname': nickname,
    'photo_url': photo_url
  };
}