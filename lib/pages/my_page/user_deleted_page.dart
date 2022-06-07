import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/png_list.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_button.dart';

class UserDeletedPage extends StatelessWidget {
  static const String routeName = '/userDeletedPage';
  const UserDeletedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: CustomTextStyle.appBarStyle(context),
        title: const Text('회원탈퇴'),
        elevation: 0.5,
      ),
      body: Container(
        padding: basePadding(context),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: mediaHeight(context, 0.07),
              width: mediaHeight(context, 0.07),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(PngList.app_logo)
                )
              ),
            ),
            Container(
              margin: baseVerticalPadding(context),
              child: Text('회원 탈퇴가 완료되었습니다.', style: CustomTextStyle.w600(context)),
            ),
            Text('아쉽지만 다음에 또 이용해주실꺼죠?', style: CustomTextStyle.w500(context, color: CustomColors.hint)),
            CustomButton(
              margin: baseVerticalPadding(context).copyWith(top: mediaHeight(context, 0.05)),
              width: mediaWidth(context, 0.5),
              sideColor: CustomColors.main,
              textColor: CustomColors.main,
              color: Colors.white,
                title: '홈으로 가기',
                onPressed: () => Get.until((route) => route.isFirst)
            )
          ],
        ),
      ),
    );
  }
}
