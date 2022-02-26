class User{
  String? uid, email, password, nickname, photoURL, fcmToken, jsonToken, deviceId;
  int? gender;
  bool? notification;
  DateTime? createAt, updateAt;

  User({
    this.uid,
    this.email,
    this.password,
    this.nickname,
    this.photoURL,
    this.fcmToken,
    this.jsonToken,
    this.deviceId,
    this.gender,
    this.notification,
    this.createAt,
    this.updateAt
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    uid: json['_id'],
    email: json['email'],
    password: json['password'],
    nickname: json['nickname'],
    photoURL: json['photoURL'],
    fcmToken: json['fcmToken'],
    jsonToken: json['jsonToken'],
    deviceId: json['deviceId'],
    gender: json['gender'],
    notification: json['notification'],
    createAt: json['createAt'] != null ? DateTime.parse(json['createAt']) : null,
    updateAt: json['updateAt'] != null ? DateTime.parse(json['updateAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    '_id': uid,
    'email': email,
    'password': password,
    'nickname': nickname,
    'photoURL': photoURL,
    'fcmToken': fcmToken,
    'jsonToken': jsonToken,
    'deviceId': deviceId,
    'gender': gender,
    'notification': notification,
    'createAt': createAt!.toIso8601String(),
    'updateAt': updateAt!.toIso8601String(),
  };

  Map<String, dynamic> joinToJson() => {
    'email': email,
    'password': password,
    'nickname': nickname,
    'fcmToken': fcmToken,
    'deviceId': deviceId,
  };

  Map<String, dynamic> loginToJson() => {
    'email': email,
    'password': password,
    'fcmToken': fcmToken,
    'deviceId': deviceId,
  };

  Map<String, dynamic> logoutToJson() => {
    '_id': uid,
  };
}