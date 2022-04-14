import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../util/common.dart';

class NoneTextField extends StatelessWidget {
  TextEditingController? controller;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  TextStyle? textStyle;
  TextAlign? textAlign;
  bool? autofocus;
  bool? obscureText;
  bool? readOnly;
  bool? enabled;
  int? maxLength;
  int? maxLines;
  int? minLines;
  double? height;
  double? width;
  double? borderRadius;
  String? hintText;
  String? labelText;
  String? counterText;
  String? helperText;
  Widget? suffixIcon;
  Widget? prefixIcon;
  EdgeInsets? margin;
  EdgeInsets? padding;
  EdgeInsets? contentPadding;
  Color? sideColor;
  Color? fillColor;
  List<TextInputFormatter>? inputFormatters;
  Function()? onTap;
  Function(String value)? onFieldSubmitted;
  Function(String) onChanged;
  String? Function(String?)? validator;

  NoneTextField({
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.textAlign,
    this.textStyle,
    this.autofocus,
    this.obscureText,
    this.readOnly,
    this.enabled,
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
    this.prefixIcon,
    this.margin,
    this.padding,
    this.contentPadding,
    this.sideColor,
    this.fillColor,
    this.inputFormatters,
    this.onTap,
    required this.onFieldSubmitted,
    required this.onChanged,
    this.validator,
    Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? mediaHeight(context, 0.05),
      width: width,
      margin: margin,
      child: TextFormField(
        onChanged: onChanged,
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
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
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
          border: InputBorder.none,
        ),
      ),
    );
  }
}