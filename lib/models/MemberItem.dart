class MemberItem{
  final int id;
  final String nickname;
  final String? photo_url;

  MemberItem({
    required this.id,
    required this.nickname,
    required this.photo_url
  });

  factory MemberItem.fromJson(Map<String, dynamic> json) => MemberItem(
      id: json['id'],
      nickname: json['nickname'],
      photo_url: json['photo_url']
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'nickname': nickname,
    'photo_url': photo_url
  };
}