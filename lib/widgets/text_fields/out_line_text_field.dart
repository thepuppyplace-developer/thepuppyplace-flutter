import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../util/common.dart';

class OutlineTextField extends StatelessWidget {
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

  OutlineTextField({
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
    this.onFieldSubmitted,
    required this.onChanged,
    this.validator});
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
        borderSide: BorderSide(color: sideColor ?? CustomColors.main)
    );
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      child: TextFormField(
        validator: validator,
        enabled: enabled,
        textInputAction: textInputAction,
        style: CustomTextStyle.w500(context),
        onTap: onTap,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
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
          isDense: true,
          floatingLabelStyle: CustomTextStyle.w500(context, color: CustomColors.main),
          focusColor: Colors.green,
          hintStyle: CustomTextStyle.w500(context, color: CustomColors.hint),
          labelStyle: CustomTextStyle.w500(context, color: CustomColors.hint),
          errorStyle: CustomTextStyle.w500(context, color: Colors.red),
          filled: true,
          fillColor: fillColor ?? Colors.white,
          hintText: hintText,
          labelText: labelText,
          counterText: counterText ?? '',
          helperText: helperText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.03), vertical: mediaHeight(context, 0.015)),
          border: border,
          enabledBorder: border.copyWith(borderSide: BorderSide(color: sideColor ?? CustomColors.hint, width: 1)),
          disabledBorder: border.copyWith(borderSide: const BorderSide(color: CustomColors.hint, width: 1)),
          focusedBorder: border,
        ),
      ),
    );
  }
}