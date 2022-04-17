class CachedNetworkImageList{
  static String _S3URL(String image_name) => 'https://thepuppyplace.s3.ap-northeast-2.amazonaws.com/uploads/$image_name.jpg';

  static final String splash = _S3URL('splash');
  static final String cafe = _S3URL('cafe');
  static final String ground = _S3URL('ground');
  static final String restaurant = _S3URL('restaurant');
  static final String shopping = _S3URL('shopping');
  static final String talk = _S3URL('talk');
  static final String hotel = _S3URL('hotel');
}