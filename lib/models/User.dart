class User{
  final int? userId;
  final String? email;
  final String? password;
  final String? nickname;
  final String? name;
  final String? phoneNumber;
  final String? photoURL;
  final String? gender;
  final String? location;
  final DateTime? createdAt, updatedAt, deletedAt;

  User({
    this.userId,
    this.email,
    this.password,
    this.nickname,
    this.name,
    this.phoneNumber,
    this.photoURL,
    this.gender,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json['id'],
    email: json['email'],
    password: json['password'],
    nickname: json['nickname'],
    name: json['name'],
    phoneNumber: json['phone_number'],
    photoURL: json['photo_url'],
    gender: json['gender'],
    location: json['location'],
    createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': userId,
    'email': email,
    'password': password,
    'nickname': nickname,
    'name': name,
    'phone_number': phoneNumber,
    'photo_url': photoURL,
    'gender': gender,
    'location': location,
  };
}