import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user/user_controller.dart';
import '../../models/User.dart';
import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/buttons/update_text_button.dart';
import 'update_nickname_page.dart';

class UpdateMyPage extends GetView<UserController> {
  const UpdateMyPage({Key? key}) : super(key: key);

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
          body: controller.obx((User? user) => Column(
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
                              Container(
                                width: mediaHeight(context, 0.15),
                                height: mediaHeight(context, 0.15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: CustomColors.hint)
                                ),
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
                          onPressed: (){},
                        ),
                        UpdateTextButton(
                          title: '이메일 아이디',
                          content: user!.email ?? '',
                          onTap: null,
                        ),
                        UpdateTextButton(
                          title: '비밀번호 변경',
                          content: '********',
                          onTap: (){},
                        ),
                        UpdateTextButton(
                          title: '닉네임 변경',
                          content: user.nickname ?? '',
                          onTap: (){
                            Get.to(() => UpdateNicknamePage());
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
          ))
      ),
    );
  }
}
