import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/BoardComment.dart';

double mediaHeight(BuildContext context, double scale) => MediaQuery.of(context).size.height * scale;
double mediaWidth(BuildContext context, double scale) => MediaQuery.of(context).size.width * scale;

void unFocus(BuildContext context) => FocusScope.of(context).unfocus();

Future<List<String>> pickMultiImage() async{
  ImagePicker picker = ImagePicker();
  List<XFile>? imageList = await picker.pickMultiImage();
  if(imageList == null){
    return <String>[];
  } else {
    return imageList.map((image) => image.path).toList();
  }
}

Future showSnackBar(BuildContext context, String msg) async{
  ScaffoldMessenger.of(context).clearSnackBars();
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg, style: CustomTextStyle.w500(context, color: Colors.white))));
}

Future showToast(String msg) async{
  await Fluttertoast.cancel();
  return Fluttertoast.showToast(msg: msg);
}

Future showIndicator(Future future) => Get.dialog(FutureBuilder(
  future: future.whenComplete(() => Get.back()),
  builder: (context, snapshot) => Center(
    child: Platform.isAndroid ? const CircularProgressIndicator() : const CupertinoActivityIndicator(),
  ),
));

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Platform.isAndroid
            ? const CircularProgressIndicator()
            : const CupertinoActivityIndicator(),
      )
    );
  }
}

class CustomErrorView extends StatelessWidget {
  String? error;
  CustomErrorView({
    required this.error,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(error ?? 'error'),
      ),
    );
  }
}

mixin CustomColors implements Color{
  static const Color background = Color(0xFFE3F2FD);
  static const Color main = Color(0xFF7DCE70);
  static const Color mainEmpty = Color(0xFFEAFFE6);
  static const Color hint = Color(0xFFB6B6B6);
  static const Color empty = Color(0xFFF2F2F2);
  static const Color emptySide = Color(0xFFEAEAEA);
}

mixin CustomTextStyle implements TextStyle{
  static TextStyle w100(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily}) => TextStyle(fontWeight: FontWeight.w100, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black, height: height, fontFamily: fontFamily ?? 'Tmoney');
  static TextStyle w200(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily}) => TextStyle(fontWeight: FontWeight.w200, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black, height: height, fontFamily: fontFamily ?? 'Tmoney');
  static TextStyle w300(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily}) => TextStyle(fontWeight: FontWeight.w300, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black, height: height, fontFamily: fontFamily ?? 'Tmoney');
  static TextStyle w400(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily}) => TextStyle(fontWeight: FontWeight.w400, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black, height: height, fontFamily: fontFamily ?? 'Tmoney');
  static TextStyle w500(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily}) => TextStyle(fontWeight: FontWeight.w500, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black, height: height, fontFamily: fontFamily ?? 'Tmoney');
  static TextStyle w600(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily}) => TextStyle(fontWeight: FontWeight.w600, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black, height: height, fontFamily: fontFamily ?? 'Tmoney');
  static TextStyle w700(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily}) => TextStyle(fontWeight: FontWeight.w700, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black, height: height, fontFamily: fontFamily ?? 'Tmoney');
  static TextStyle w800(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily}) => TextStyle(fontWeight: FontWeight.w800, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black, height: height, fontFamily: fontFamily ?? 'Tmoney');
  static TextStyle w900(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily}) => TextStyle(fontWeight: FontWeight.w900, fontSize: mediaHeight(context, scale ?? 0.016), color: color ?? Colors.black, height: height, fontFamily: fontFamily ?? 'Tmoney');
}

String beforeDate(DateTime date){
  Duration time = DateTime.now().difference(date);
  if(time.inSeconds < 10){
    return '방금전';
  } else if(time.inSeconds < 60){
    return '${time.inSeconds}초 전';
  } else if(time.inMinutes < 60){
    return '${time.inMinutes}분 전';
  } else if(time.inHours < 24){
    return '${time.inHours}시간 전';
  } else if(time.inDays < 7){
    return '${time.inDays}일 전';
  } else {
    return DateFormat('yyyy.MM.DD').format(date);
  }
}

int commentCount(List<BoardComment>? commentList){
  int commentCount = commentList!.length;
  for(int i = 0; i < commentList.length; i++){
    commentCount += commentList[i].nestedCommentList!.length;
  }
  return commentCount;
}