class User{
  String? userId, email, password, nickname, name, photoURL, phoneNumber, fcmToken, jsonToken, deviceId;
  int? gender;
  bool? isDeleted, isLogged, notification;
  DateTime? loggedAt, birthDay, deletedAt, createAt, updateAt;

  User({
    this.userId,
    this.email,
    this.password,
    this.nickname,
    this.name,
    this.photoURL,
    this.phoneNumber,
    this.fcmToken,
    this.jsonToken,
    this.deviceId,
    this.gender,
    this.isLogged,
    this.isDeleted,
    this.notification,
    this.birthDay,
    this.loggedAt,
    this.deletedAt,
    this.createAt,
    this.updateAt
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json['_id'],
    email: json['email'],
    password: json['password'],
    nickname: json['nickname'],
    name: json['name'],
    photoURL: json['photoURL'],
    phoneNumber: json['phoneNumber'],
    fcmToken: json['fcmToken'],
    jsonToken: json['jsonToken'],
    deviceId: json['deviceId'],
    gender: json['gender'],
    isLogged: json['isLogged'],
    isDeleted: json['isDeleted'],
    notification: json['notification'],
    birthDay: json['birthDay'] != null ? DateTime.parse(json['birthDay']) : null,
    loggedAt: json['loggedAt'] != null ? DateTime.parse(json['loggedAt']) : null,
    deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    createAt: json['createAt'] != null ? DateTime.parse(json['createAt']) : null,
    updateAt: json['updateAt'] != null ? DateTime.parse(json['updateAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    '_id': userId,
    'email': email,
    'password': password,
    'nickname': nickname,
    'name': name,
    'photoURL': photoURL,
    'phoneNumber': phoneNumber,
    'fcmToken': fcmToken,
    'jsonToken': jsonToken,
    'deviceId': deviceId,
    'gender': gender,
    'isLogged': isLogged,
    'isDeleted': isDeleted,
    'notification': notification,
    'birthDay': birthDay!.toIso8601String(),
    'loggedAt': DateTime.now().toIso8601String(),
    'deletedAt': deletedAt!.toIso8601String(),
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

  Map<String, dynamic> logoutToJson() => {
    '_id': userId,
    'loggedAt': DateTime.now().toIso8601String(),
    'isLogged': false
  };
}