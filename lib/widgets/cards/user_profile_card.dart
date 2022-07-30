import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/png_list.dart';
import 'package:thepuppyplace_flutter/widgets/images/custom_cached_network.image.dart';
import '../../models/UserNicknameAndPhotoURL.dart';
import '../../util/cached_network_image_list.dart';
import '../../util/common.dart';

class UserProfileCard extends StatelessWidget {
  final UserNicknameAndPhotoURL user;

  const UserProfileCard(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCachedNetworkImage(
          user.photo_url,
          padding: basePadding(context) / 2,
          shape: BoxShape.circle,
          height: mediaHeight(context, 0.036),
          width: mediaHeight(context, 0.036),
          loadingSameEmpty: true,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.015)),
            child: Text(user.nickname, style: CustomTextStyle.w600(context)))
      ],
    );
  }
}
