import 'package:thepuppyplace_flutter/util/common.dart';

import 'cached_network_image_list.dart';

class PngList{
  static const String logo = 'assets/png/logo.png';
  static const String loading = 'assets/png/loading.png';
  static const String empty = 'assets/png/empty.png';

  static final List<String> categoryList = <String>[
    CachedNetworkImageList.cafe,
    CachedNetworkImageList.restaurant,
    CachedNetworkImageList.shopping,
    CachedNetworkImageList.hotel,
    CachedNetworkImageList.ground,
    CachedNetworkImageList.talk,
  ];

  static String defaultProfile = 'https://thepuppyplace.s3.ap-northeast-2.amazonaws.com/uploads/thepuppy_profile_${randomImage()}.jpeg';
}