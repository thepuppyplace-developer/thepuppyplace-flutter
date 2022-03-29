import 'package:flutter/material.dart';

import '../../util/common.dart';

class UnderlineTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextStyle? textStyle;
  final TextStyle? helperStyle;
  final bool? obscureText;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final double? height;
  final String? hintText;
  final Widget? suffixIcon;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const UnderlineTextField({
    required this.controller,
    required this.keyboardType,
    this.obscureText,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.height,
    this.hintText,
    this.suffixIcon,
    this.margin,
    this.padding,
    this.textStyle,
    this.helperStyle,
    Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    UnderlineInputBorder border = const UnderlineInputBorder(
        borderSide: BorderSide(color: CustomColors.main, width: 1)
    );

    return Container(
      height: height,
      margin: margin ?? EdgeInsets.symmetric(vertical: mediaHeight(context, 0.005)),
      child: TextFormField(
        style: CustomTextStyle.w500(context, scale: 0.018),
        obscureText: obscureText ?? false,
        controller: controller,
        maxLength: maxLength,
        maxLines: maxLines,
        minLines: minLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintStyle: CustomTextStyle.w500(context, scale: 0.018, color: CustomColors.hint),
            hintText: hintText,
            suffixIcon: suffixIcon,
            contentPadding: padding ?? EdgeInsets.symmetric(vertical: mediaHeight(context, 0.015)),
            border: border,
            enabledBorder: border.copyWith(borderSide: const BorderSide(color: CustomColors.hint)),
            focusedBorder: border,
            helperStyle: helperStyle ?? Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.blueGrey, fontSize: mediaHeight(context, 0.012))
        ),
      ),
    );
  }
}

