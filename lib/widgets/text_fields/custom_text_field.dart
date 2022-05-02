import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../util/common.dart';

class CustomTextField extends StatelessWidget {

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final bool? autofocus;
  final bool? obscureText;
  final bool? readOnly;
  final bool? enabled;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final double? height;
  final double? width;
  final double? borderRadius;
  final String? hintText;
  final String? labelText;
  final String? counterText;
  final String? helperText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Alignment? alignment;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final EdgeInsets? contentPadding;
  final Color? sideColor;
  final Color? fillColor;
  final Color? helperColor;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;
  final Function(String value)? onFieldSubmitted;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextFieldType textFieldType;

  const CustomTextField({Key? key,
    required this.textFieldType,
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
    this.maxLines = 1,
    this.minLines = 1,
    this.height,
    this.width,
    this.borderRadius,
    this.hintText,
    this.labelText,
    this.counterText,
    this.helperText,
    this.suffixIcon,
    this.prefixIcon,
    this.alignment,
    this.margin,
    this.padding,
    this.contentPadding,
    this.sideColor,
    this.fillColor,
    this.helperColor,
    this.inputFormatters,
    this.onTap,
    this.onFieldSubmitted,
    this.onChanged,
    this.validator}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    InputBorder _border(textFieldType){
      switch(textFieldType){
        case TextFieldType.underline: return UnderlineInputBorder(
            borderSide: BorderSide(color: sideColor ?? CustomColors.main)
        );
        case TextFieldType.outline: return OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            borderSide: BorderSide(color: sideColor ?? CustomColors.main)
        );
        default: return InputBorder.none;
      }
    }

    EdgeInsets _contentPadding(textFieldType){
      switch(textFieldType){
        case TextFieldType.underline: return contentPadding ?? EdgeInsets.symmetric(vertical: mediaWidth(context, 0.03));
        case TextFieldType.outline: return contentPadding ?? EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.03), vertical: mediaHeight(context, 0.015));
        default: return contentPadding ?? EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.03));
      }
    }

    return Container(
      width: width,
      height: height,
      alignment: alignment ?? Alignment.center,
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
        maxLines: maxLines,
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
          helperStyle: CustomTextStyle.w500(context, color: helperColor),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: _contentPadding(textFieldType),
          border: _border(textFieldType),
          enabledBorder: _border(textFieldType).copyWith(borderSide: BorderSide(color: sideColor ?? CustomColors.hint, width: 1)),
          disabledBorder: _border(textFieldType).copyWith(borderSide: const BorderSide(color: CustomColors.hint, width: 1)),
          focusedBorder: _border(textFieldType),
        ),
      ),
    );
  }
}

enum TextFieldType { outline, none, underline }