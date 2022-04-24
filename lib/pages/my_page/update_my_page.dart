import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thepuppyplace_flutter/util/cached_network_image_list.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/User.dart';
import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/buttons/update_text_button.dart';
import 'update_nickname_page.dart';

class UpdateMyPage extends StatefulWidget {
  const UpdateMyPage({Key? key}) : super(key: key);

  @override
  State<UpdateMyPage> createState() => _UpdateMyPageState();
}

class _UpdateMyPageState extends State<UpdateMyPage> {
  File? _photo;

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
              return controller.obx((User? user) => Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                        child: Column(
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.04)),
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    maxRadius: mediaHeight(context, 0.07),
                                    backgroundColor: CustomColors.emptySide,
                                    backgroundImage: CachedNetworkImageProvider(CachedNetworkImageList.thepuppy_profile_0),
                                    foregroundImage: user!.photo_url == null ? null : CachedNetworkImageProvider(user.photo_url!),
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
                                      child: Text('앨범에서 사진 선택', style: CustomTextStyle.w500(context, scale: 0.02)),
                                      onPressed: () async{
                                        Get.back();
                                        _photo = await photoPick(context, ImageSource.gallery);
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text('기본 이미지로 변경', style: CustomTextStyle.w500(context, scale: 0.02)),
                                      onPressed: (){
                                        Get.back();
                                        controller.updatePhotoURL(context, _photo);
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
                              content: user.email,
                              onTap: null,
                            ),
                            UpdateTextButton(
                              title: '비밀번호 변경',
                              content: '********',
                              onTap: (){},
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
                  ),
                  CustomButton(
                    height: mediaHeight(context, 0.06),
                    margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                    title: '수정',
                    onPressed: (){},
                  )
                ],
              ));
            }
          )
      ),
    );
  }
}
