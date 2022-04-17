class UserNicknameAndPhotoURL{
  final String nickname;
  final String? photo_url;

  UserNicknameAndPhotoURL({
    required this.nickname,
    required this.photo_url
  });

  factory UserNicknameAndPhotoURL.fromJson(Map<String, dynamic> json) => UserNicknameAndPhotoURL(
      nickname: json['nickname'],
      photo_url: json['photo_url']
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'nickname': nickname,
    'photo_url': photo_url
  };
}