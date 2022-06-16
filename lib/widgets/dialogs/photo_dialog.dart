import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../util/common.dart';
import '../buttons/custom_button.dart';
import '../buttons/custom_text_button.dart';

class PhotoDialog extends StatelessWidget {
  final String title;
  final Function(XFile?) onPickPhoto;

  const PhotoDialog({
    required this.title,
    required this.onPickPhoto, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titleTextStyle: CustomTextStyle.appBarStyle(context),
      title: Text(title),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: _buttonList,
      ),
      titlePadding: basePadding(context).add(basePadding(context)),
      contentPadding: baseHorizontalPadding(context).add(baseHorizontalPadding(context)),
      actionsPadding: EdgeInsets.zero,
      actions: _actionButtonList(context),
    );
  }

  List<Widget> get _buttonList => <Widget>[
    CustomTextButton('카메라로 사진찍기', () async{
      Get.back();
      return onPickPhoto(await photoPick(ImageSource.camera));
    }),
    CustomTextButton('갤러리에서 가져오기', () async {
      Get.back();
      return onPickPhoto(await photoPick(ImageSource.gallery));
    }),
  ];

  List<Widget> _actionButtonList(BuildContext context) => <Widget>[
    CustomButton(
        margin: basePadding(context),
        borderRadius: mediaHeight(context, 1),
        title: '취소',
        onPressed: () => Get.back())
  ];
}