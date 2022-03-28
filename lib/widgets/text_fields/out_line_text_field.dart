import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../util/common.dart';

class OutlineTextField extends StatelessWidget {
  TextEditingController? controller;
  TextInputType? keyboardType;
  TextStyle? textStyle;
  TextAlign? textAlign;
  bool? autofocus, obscureText, readOnly;
  int? maxLength, maxLines, minLines;
  double? height, width, borderRadius;
  String? hintText, labelText, counterText, helperText;
  Widget? suffixIcon;
  EdgeInsets? margin, padding;
  Color? sideColor, fillColor;
  List<TextInputFormatter>? inputFormatters;
  Function()? onTap;

  OutlineTextField({
    required this.controller,
    required this.keyboardType,
    this.textAlign,
    this.textStyle,
    this.autofocus,
    this.obscureText,
    this.readOnly,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.height,
    this.width,
    this.borderRadius,
    this.hintText,
    this.labelText,
    this.counterText,
    this.helperText,
    this.suffixIcon,
    this.margin,
    this.padding,
    this.sideColor,
    this.fillColor,
    this.inputFormatters,
    this.onTap,
    Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
        borderSide: BorderSide(color: sideColor ?? Colors.grey)
    );
    return Container(
      height: height ?? mediaHeight(context, 0.05),
      width: width,
      margin: margin,
      child: TextFormField(
        style: CustomTextStyle.w500(context),
        onTap: onTap,
        readOnly: readOnly ?? false,
        inputFormatters: inputFormatters,
        textAlign: textAlign ?? TextAlign.start,
        autofocus: autofocus ?? true,
        cursorColor: CustomColors.main,
        obscureText: obscureText ?? false,
        controller: controller,
        maxLength: maxLength,
        maxLines: maxLines ?? 1,
        minLines: minLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintStyle: CustomTextStyle.w500(context, color: CustomColors.hint),
          filled: true,
          fillColor: fillColor ?? Colors.white54,
          hintText: hintText,
          labelText: labelText,
          counterText: counterText,
          helperText: helperText,
          suffixIcon: suffixIcon,
          contentPadding: padding ?? EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.03)),
          border: border,
          enabledBorder: border.copyWith(borderSide: BorderSide(color: sideColor ?? CustomColors.hint, width: 1)),
          focusedBorder: border,
        ),
      ),
    );
  }
}