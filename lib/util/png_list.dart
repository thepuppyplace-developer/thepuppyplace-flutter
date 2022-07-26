import 'package:thepuppyplace_flutter/util/common.dart';

import 'cached_network_image_list.dart';

class PngList{
  static String _basePath(String image_name) => 'assets/png/$image_name.png';

  static final String logo = _basePath('logo');
  static final String loading = _basePath('loading');
  static final String empty = _basePath('empty');
  static final String google = _basePath('google');
  static final String apple = _basePath('apple');
  static final String app_logo = _basePath('app_logo');
  static final String default_profile = _basePath('default_profile');
  static final String splash = _basePath('splash');

  static final List<String> categoryList = <String>[
    CachedNetworkImageList.cafe,
    CachedNetworkImageList.restaurant,
    CachedNetworkImageList.shopping,
    CachedNetworkImageList.hotel,
    CachedNetworkImageList.ground,
    CachedNetworkImageList.talk,
  ];
}