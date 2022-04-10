import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/custom_icons.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/User.dart';
import '../../util/png_list.dart';
import '../../widgets/buttons/custom_icon_button.dart';
import '../../widgets/buttons/custom_text_button.dart';
import '../../widgets/dialogs/custom_dialog.dart';
import 'login_request_page.dart';
import 'update_my_page.dart';

class MyPage extends GetWidget<UserController> {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.obx((User? user) => Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('마이페이지', style: CustomTextStyle.w500(context, scale: 0.025)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(mediaWidth(context, 0.033)),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: mediaHeight(context, 0.03),
                      backgroundImage: CachedNetworkImageProvider(user!.photo_url ?? PngList.defaultProfile),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: user.nickname ?? '',
                                      style: CustomTextStyle.w600(context, scale: 0.02),
                                    ),
                                    TextSpan(
                                      text: '님',
                                      style: CustomTextStyle.w500(context, scale: 0.02),
                                    ),
                                  ]
                              ),
                            ),
                            Text('환영합니다.', style: CustomTextStyle.w500(context, scale: 0.02))
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: mediaHeight(context, 0.02), color: CustomColors.hint)
                  ],
                ),
                onPressed: (){
                  Get.to(() => const UpdateMyPage());
                },
              ),
            ),
            Divider(
              color: CustomColors.empty,
              thickness: mediaHeight(context, 0.01),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomIconButton(
                    icon: CustomIcons.menu,
                    text: '내가 쓴 게시물',
                    onTap: (){},
                  ),
                ),
                Expanded(
                  child: CustomIconButton(
                    icon: CustomIcons.heart,
                    text: '내가 좋아한 게시물',
                    onTap: (){},
                  ),
                ),
              ],
            ),
            Divider(
              color: CustomColors.empty,
              thickness: mediaHeight(context, 0.01),
            ),
            Container(
                margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('설정', style: CustomTextStyle.w500(context, color: CustomColors.hint),),
                    CustomTextButton('환경설정', (){}, color: Colors.black),
                    CustomTextButton('버전정보', null, color: Colors.black,),
                    CustomTextButton('서비스 이용약관', (){}, color: Colors.black),
                    CustomTextButton('로그아웃', (){
                      showCupertinoDialog(context: context, builder: (context) => CustomDialog(
                        title: '로그아웃 하시겠습니까?',
                        onTap: (){
                          controller.logout();
                        },
                        tabText: '로그아웃',
                      ));
                      // showDialog(context: context, builder: (context) => CustomDialog(
                      //   title: '로그아웃 하시겠습니까?',
                      //   onTap: (){},
                      // ));
                    }, color: Colors.black),
                    CustomTextButton('회원탈퇴', (){}, color: Colors.black),
                  ],
                ))
          ],
        ),
      ),
    ),
        onLoading: const CustomIndicator(),
        onError: (error) => CustomErrorView(error: error),
        onEmpty: const LoginRequestPage()
    );
  }
}
