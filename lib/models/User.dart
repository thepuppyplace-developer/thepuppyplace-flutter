class User{
  final int id;
  final String uid;
  final String? email;
  final String nickname;
  final String? name;
  final String? phone_number;
  final String? photo_url;
  final String? gender;
  final String? fcm_token;
  final String? jwt_token;
  final bool is_alarm;
  final String? location;
  final String auth_type;

  User({
    required this.id,
    required this.uid,
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
    required this.auth_type,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    uid: json['uid'],
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
    auth_type: json['auth_type'],
  );
}