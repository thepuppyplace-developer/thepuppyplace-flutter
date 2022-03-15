class User{
  final int? user_id;
  final String? email;
  final String? password;
  final String? nickname;
  final String? name;
  final String? photo_url;
  final String? location;
  final int? gender;
  final DateTime? createAt, updateAt;

  User({
    this.user_id,
    this.email,
    this.password,
    this.nickname,
    this.name,
    this.photo_url,
    this.location,
    this.gender,
    this.createAt,
    this.updateAt
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    user_id: json['id'],
    email: json['email'],
    password: json['password'],
    nickname: json['nickname'],
    name: json['name'],
    photo_url: json['phoro_url'],
    location: json['location'],
    gender: json['gender'],
    createAt: json['createAt'] != null ? DateTime.parse(json['createAt']) : null,
    updateAt: json['updateAt'] != null ? DateTime.parse(json['updateAt']) : null,
  );

  factory User.fromBoard(Map<String, dynamic> json) => User(
    nickname: json['nickname'],
    photo_url: json['phoro_url']
  );

  Map<String, dynamic> toJson() => {
    'id': user_id,
    'email': email,
    'password': password,
    'nickname': nickname,
    'name': name,
    'phoro_url': photo_url,
    'location': location,
    'gender': gender,
    'createAt': createAt!.toIso8601String(),
    'updateAt': updateAt!.toIso8601String(),
  };
}