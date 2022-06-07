class BannerModel{
  final int id;
  final String imageURL;
  final String linkType;
  final String linkURL;
  final String comment;

  BannerModel({
    required this.id,
    required this.imageURL,
    required this.linkType,
    required this.linkURL,
    required this.comment,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    id: json['id'],
    imageURL: json['image_url'],
    linkType: json['link_type'],
    linkURL: json['link_url'],
    comment: json['comment'],
  );
}