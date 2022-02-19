import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

double mediaHeight(BuildContext context, double scale) => MediaQuery.of(context).size.height * scale;
double mediaWidth(BuildContext context, double scale) => MediaQuery.of(context).size.width * scale;

void unFocus(BuildContext context) => FocusScope.of(context).unfocus();

Future showToast(String msg) async{
  await Fluttertoast.cancel();
  return Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER);
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

