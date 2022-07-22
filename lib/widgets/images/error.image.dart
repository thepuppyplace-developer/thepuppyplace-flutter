import 'package:flutter/material.dart';
import '../../util/common.dart';
import '../../util/png_list.dart';

class ErrorImage extends StatelessWidget {
  final double? height;
  final double? width;
  const ErrorImage({
    this.height,
    this.width,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CustomColors.empty,
          image: DecorationImage(
              image: AssetImage(PngList.logo)
          )
      ),
    );
  }
}
