import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/pages/my_page/app_info_page.dart';
import 'package:thepuppyplace_flutter/util/cached_network_image_list.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/custom_icons.dart';
import 'package:thepuppyplace_flutter/util/png_list.dart';
import 'package:thepuppyplace_flutter/widgets/images/custom_cached_network.image.dart';
import '../../controllers/user/user_controller.dart';
import '../../controllers/version/version_controller.dart';
import '../../widgets/buttons/custom_icon_button.dart';
import '../../widgets/buttons/custom_text_button.dart';
import '../../widgets/dialogs/custom_dialog.dart';
import '../notice_page/notice_list_page.dart';
import '../setting_page/setting_page.dart';
import 'consult.page.dart';
import 'login_request_page.dart';
import 'my_board_list.dart';
import 'my_like_board_list_page.dart';
import 'terms_page.dart';
import 'update_my_page.dart';

class MyPage extends GetWidget<UserController> {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: CustomTextStyle.appBarStyle(context),
        title: const Text('마이페이지'),
      ),
      body: controller.obx((user) => Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      CustomCachedNetworkImage(
                        user!.photo_url,
                        padding: basePadding(context),
                        fit: BoxFit.cover,
                        height: mediaHeight(context, 0.06),
                        width: mediaHeight(context, 0.06),
                        shape: BoxShape.circle,
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
                                        text: user.nickname,
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
                      type: IconButtonType.withText,
                      icon: CustomIcons.menu,
                      text: '내가 쓴 게시물',
                      onTap: (){
                        Get.to(() => const MyBoardListPage());
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomIconButton(
                      type: IconButtonType.withText,
                      icon: CustomIcons.heart,
                      text: '내가 좋아한 게시물',
                      onTap: (){
                        Get.to(() => const MyLikeBoardListPage());
                      },
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
                      Container(
                          margin: EdgeInsets.only(bottom: mediaHeight(context, 0.02)),
                          child: Text('설정', style: CustomTextStyle.w500(context, color: CustomColors.hint),)),
                      CustomTextButton('환경설정', (){
                        Get.to(() => const SettingPage(),);
                      }, color: Colors.black, alignment: Alignment.centerLeft),
                      CustomTextButton('공지사항', (){
                        Get.toNamed(NoticeListPage.routeName);
                      }, color: Colors.black, alignment: Alignment.centerLeft),
                      CustomTextButton('문의하기', (){
                        Get.toNamed(ConsultPage.routeName);
                      }, color: Colors.black, alignment: Alignment.centerLeft),
                      CustomTextButton('앱 정보', (){
                        Get.toNamed(AppInfoPage.routeName);
                      }, color: Colors.black, alignment: Alignment.centerLeft),
                      CustomTextButton('서비스 이용약관', (){
                        Get.to(() => const TermsPage());
                      }, color: Colors.black, alignment: Alignment.centerLeft),
                      CustomTextButton('로그아웃', (){
                        showCupertinoDialog(context: context, builder: (context) => CustomDialog(
                          title: '로그아웃 하시겠습니까?',
                          onTap: (){
                            Get.back();
                            showIndicator(controller.logout(context));
                          },
                          tabText: '로그아웃',
                        ));
                      }, color: Colors.black, alignment: Alignment.centerLeft),
                      CustomTextButton('회원탈퇴', (){
                        showCupertinoDialog(context: context, builder: (context) => CustomDialog(
                            title: '회원을 탈퇴하시겠습니까?',
                            tabText: '회원탈퇴',
                            content: '회원탈퇴시 복원되지 않습니다.\n삭제하시겠습니까?',
                            onTap: () => showIndicator(controller.deleteUser(context))
                        ));
                      }, color: Colors.black, alignment: Alignment.centerLeft),
                    ],
                  ))
            ],
          ),
        ),
      ),
          onLoading: const CustomIndicator(),
          onError: (error) => CustomErrorView(error: error),
          onEmpty: const LoginRequestPage()
      ),
    );
  }
}
