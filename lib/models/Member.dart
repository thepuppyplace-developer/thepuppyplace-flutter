class Member{
  final int id;
  final String uid;
  final String? email;
  String nickname;
  final String? name;
  String? phone_number;
  String? photo_url;
  String? gender;
  final String? fcm_token;
  final String? jwt_token;
  bool is_alarm;
  bool is_service_alarm;
  bool is_comment_alarm;
  bool is_like_alarm;
  String? location;
  final String auth_type;

  Member({
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
    required this.is_service_alarm,
    required this.is_comment_alarm,
    required this.is_like_alarm,
    this.location,
    required this.auth_type,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
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
    is_service_alarm: json['is_service_alarm'].runtimeType == int ? json['is_service_alarm'] == 1 ? true : false : json['is_service_alarm'],
    is_comment_alarm: json['is_comment_alarm'].runtimeType == int ? json['is_comment_alarm'] == 1 ? true : false : json['is_comment_alarm'],
    is_like_alarm: json['is_like_alarm'].runtimeType == int ? json['is_like_alarm'] == 1 ? true : false : json['is_like_alarm'],
    location: json['location'],
    auth_type: json['auth_type'],
  );
}