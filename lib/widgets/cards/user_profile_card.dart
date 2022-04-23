import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
        CircleAvatar(
          radius: mediaHeight(context, 0.018),
          backgroundImage: CachedNetworkImageProvider(CachedNetworkImageList.thepuppy_profile_0),
          foregroundImage: user.photo_url == null ? null : CachedNetworkImageProvider(user.photo_url!),
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.015)),
            child: Text(user.nickname, style: CustomTextStyle.w600(context)))
      ],
    );
  }
}
