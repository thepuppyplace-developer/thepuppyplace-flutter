import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thepuppyplace_flutter/pages/my_page/update_password_page.dart';
import 'package:thepuppyplace_flutter/util/png_list.dart';
import 'package:thepuppyplace_flutter/widgets/images/custom_cached_network.image.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/Member.dart';
import '../../util/common.dart';
import '../../widgets/buttons/update_text_button.dart';
import 'update_nickname_page.dart';

class UpdateMyPage extends StatefulWidget {
  static const String routeName = '/updateMyPage';
  const UpdateMyPage({Key? key}) : super(key: key);

  @override
  State<UpdateMyPage> createState() => _UpdateMyPageState();
}

class _UpdateMyPageState extends State<UpdateMyPage> {
 XFile? _photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool inner) => [
            SliverAppBar(
              snap: true,
              floating: true,
              pinned: true,
              title: Text('내 정보 수정', style: CustomTextStyle.w700(context, scale: 0.02)),
              elevation: 1,
            )
          ],
          body: GetBuilder<UserController>(
            init: UserController(),
            builder: (UserController controller) {
              return controller.obx((Member? user) => Column(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                      child: Column(
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.04)),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CustomCachedNetworkImage(
                                  user!.photo_url,
                                  padding: basePadding(context),
                                  height: mediaHeight(context, 0.14),
                                  width: mediaHeight(context, 0.14),
                                  fit: BoxFit.cover,
                                  shape: BoxShape.circle,
                                ),
                                Container(
                                  width: mediaHeight(context, 0.05),
                                  height: mediaHeight(context, 0.05),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: CustomColors.hint)
                                  ),
                                  child: Icon(Icons.add, size: mediaHeight(context, 0.03), color: CustomColors.hint),
                                )
                              ],
                            ),
                            onPressed: (){
                              showCupertinoModalPopup(context: context, builder: (context) => CupertinoActionSheet(
                                title: Text('프로필 수정', style: CustomTextStyle.w500(context, scale: 0.02)),
                                actions: [
                                  CupertinoActionSheetAction(
                                    child: Text('카메라로 촬영하기', style: CustomTextStyle.w500(context, scale: 0.02)),
                                    onPressed: () async{
                                      Get.back();
                                      _photo = await photoPick(ImageSource.camera);
                                      if(_photo != null){
                                        controller.updatePhotoURL(context, _photo);
                                      } else {
                                        showSnackBar(context, '카메라 촬영이 취소되었습니다.');
                                      }
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text('앨범에서 사진 선택', style: CustomTextStyle.w500(context, scale: 0.02)),
                                    onPressed: () async{
                                      Get.back();
                                      _photo = await photoPick(ImageSource.gallery);
                                      if(_photo != null){
                                        controller.updatePhotoURL(context, _photo);
                                      } else {
                                        showSnackBar(context, '사진 선택이 취소되었습니다.');
                                      }
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text('프로필 사진 삭제', style: CustomTextStyle.w500(context, scale: 0.02)),
                                    onPressed: (){
                                      Get.back();
                                      controller.deletePhotoURL(context);
                                    },
                                  )
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  child: Text('취소', style: CustomTextStyle.w500(context, scale: 0.02, color: Colors.red)),
                                  onPressed: (){
                                    Get.back();
                                  },
                                ),
                              ));
                            },
                          ),
                          UpdateTextButton(
                            title: '이메일 아이디',
                            content: user.auth_type == 'google' ? '구글로 로그인 했습니다.' : user.auth_type == 'apple' ? '애플로 로그인했습니다.' : user.email ?? '',
                          ),
                          UpdateTextButton(
                            title: '비밀번호 변경',
                            content: '********',
                            onTap: (){
                              switch(user.auth_type){
                                case 'local': return Get.to(() => const UpdatePasswordPage());
                                case 'google': return showSnackBar(context, '구글로 로그인 했습니다.');
                                case 'apple': return showSnackBar(context, '애플로 로그인 했습니다.');
                              }
                            },
                          ),
                          UpdateTextButton(
                            title: '닉네임 변경',
                            content: user.nickname,
                            onTap: (){
                              Get.to(() => const UpdateNicknamePage());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // CustomButton(
                  //   height: mediaHeight(context, 0.06),
                  //   margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                  //   title: '수정',
                  //   onPressed: (){},
                  // )
                ],
              ));
            }
          )
      ),
    );
  }
}
