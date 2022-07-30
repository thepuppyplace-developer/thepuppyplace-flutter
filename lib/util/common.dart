import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/BoardComment.dart';
import 'package:url_launcher/url_launcher.dart';

double mediaHeight(BuildContext context, double scale) => MediaQuery.of(context).size.height * scale;
double mediaWidth(BuildContext context, double scale) => MediaQuery.of(context).size.width * scale;

EdgeInsets basePadding(BuildContext context) => EdgeInsets.all(mediaWidth(context, 0.033));
EdgeInsets baseHorizontalPadding(BuildContext context) => EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033));
EdgeInsets baseVerticalPadding(BuildContext context) => EdgeInsets.symmetric(vertical: mediaWidth(context, 0.033));

void unFocus(BuildContext context) => FocusScope.of(context).unfocus();

Future<List<XFile>> pickMultiImage({int? limit}) async{
  final ImagePicker picker = ImagePicker();
  final imageList = await picker.pickMultiImage();
  if(imageList == null){
    return <XFile>[];
  } else {
    return imageList;
  }
}

Future<XFile?> imagePicker(ImageSource imageSource) async{
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: imageSource, imageQuality: 10);
  return image;
}

Future showSnackBar(BuildContext context, String msg) async{
  ScaffoldMessenger.of(context).clearSnackBars();
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg, style: CustomTextStyle.w500(context, color: Colors.white))));
}

Future network_check_message(BuildContext context) => showSnackBar(context, '인터넷 연결을 확인해주세요.');

Future expiration_token_message(BuildContext context) => showSnackBar(context, '토큰값이 만료되었습니다.');

Future unknown_message(BuildContext context) => showSnackBar(context, '알 수 없는 오류가 발생했습니다.');

Future showToast(String msg) async{
  await Fluttertoast.cancel();
  return Fluttertoast.showToast(msg: msg);
}

Future showIndicator(Future future) => Get.dialog(FutureBuilder(
  future: future.whenComplete(() => Get.back()),
  builder: (context, snapshot) => Container(
    alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.04)),
      child: const CupertinoActivityIndicator()),
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
  static const Color empty = Color(0xFFFBFBFB);
  static const Color emptySide = Color(0xFFEAEAEA);
}

mixin CustomTextStyle implements TextStyle{
  static const double _scale = 0.016;
  static const Color _color = Colors.black;
  static const String _family = 'Tmoney';
  static const TextDecoration _decoration = TextDecoration.none;

  static TextStyle appBarStyle(BuildContext context, {double? scale, Color? color}) => TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: mediaHeight(context, scale ?? 0.022),
      color: color ?? _color,
      fontFamily: _family
  );
  static TextStyle w100(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily, TextDecoration? decoration}) => TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: mediaHeight(context, scale ?? _scale),
      color: color ?? _color,
      height: height,
      fontFamily: fontFamily ?? _family,
      decoration: decoration ?? _decoration
  );
  static TextStyle w200(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily, TextDecoration? decoration}) => TextStyle(
      fontWeight: FontWeight.w200,
      fontSize: mediaHeight(context, scale ?? _scale),
      color: color ?? _color,
      height: height,
      fontFamily: fontFamily ?? _family,
      decoration: decoration ?? _decoration
  );
  static TextStyle w300(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily, TextDecoration? decoration}) => TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: mediaHeight(context, scale ?? _scale),
      color: color ?? _color,
      height: height,
      fontFamily: fontFamily ?? _family,
      decoration: decoration ?? _decoration
  );
  static TextStyle w400(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily, TextDecoration? decoration}) => TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: mediaHeight(context, scale ?? _scale),
      color: color ?? _color,
      height: height,
      fontFamily: fontFamily ?? _family,
      decoration: decoration ?? _decoration
  );
  static TextStyle w500(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily, TextDecoration? decoration}) => TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: mediaHeight(context, scale ?? _scale),
      color: color ?? _color,
      height: height,
      fontFamily: fontFamily ?? _family,
      decoration: decoration ?? _decoration
  );
  static TextStyle w600(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily, TextDecoration? decoration}) => TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: mediaHeight(context, scale ?? _scale),
      color: color ?? _color,
      height: height,
      fontFamily: fontFamily ?? _family,
      decoration: decoration ?? _decoration
  );
  static TextStyle w700(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily, TextDecoration? decoration}) => TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: mediaHeight(context, scale ?? _scale),
      color: color ?? _color,
      height: height,
      fontFamily: fontFamily ?? _family,
      decoration: decoration ?? _decoration
  );
  static TextStyle w800(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily, TextDecoration? decoration}) => TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: mediaHeight(context, scale ?? _scale),
      color: color ?? _color,
      height: height,
      fontFamily: fontFamily ?? _family,
      decoration: decoration ?? _decoration
  );
  static TextStyle w900(BuildContext context, {double? scale, double? height, Color? color, String? fontFamily, TextDecoration? decoration}) => TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: mediaHeight(context, scale ?? _scale),
      color: color ?? _color,
      height: height,
      fontFamily: fontFamily ?? _family,
      decoration: decoration ?? _decoration
  );
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
    return DateFormat('yyyy.MM.dd').format(date);
  }
}

int commentCount(List<BoardComment>? commentList){
  int commentCount = commentList!.length;
  for(int i = 0; i < commentList.length; i++){
    commentCount += commentList[i].nestedCommentList.length;
    for(int index = 0; index < commentList[i].nestedCommentList.length; index ++){
      commentCount += commentList[i].nestedCommentList[index].commentList.length;
    }
  }
  return commentCount;
}

String orderText(String order){
  switch(order){
    case 'date': return '최신순';
    case 'like': return '인기순';
    case 'view': return '조회순';
    default: return '최신순';
  }
}

int randomImage(){
  int random = Random().nextInt(12);
  return random;
}

void openURL({required String url, bool? inApp}) => launch(
    url,
    forceSafariVC: inApp,
    forceWebView: inApp ?? false,
    enableJavaScript: true
);

Future<XFile?> photoPick(ImageSource imageSource) async{
  final imagePicker = ImagePicker();
  final XFile? photo = await imagePicker.pickImage(source: imageSource);
  return photo;
}

int bytesLength(String value){
  return utf8.encode(value).length;
}

int hexStringToHexInt(String hex) {
  hex = hex.replaceFirst('#', '');
  hex = hex.length == 6 ? 'ff' + hex : hex;
  int val = int.parse(hex, radix: 16);
  return val;
}

Response returnResponse(Response res){
  if(res.statusCode != 204 || res.statusCode == null) print(res.body['message']);
  return res;
}