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
  final String? suffixText;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Alignment? alignment;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final EdgeInsets? contentPadding;
  final Color? sideColor;
  final Color? fillColor;
  final Color? helperColor;
  final Color? labelColor;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextFieldType textFieldType;
  final FocusNode? focusNode;
  final AutovalidateMode? autoValidateMode;

  CustomTextField({Key? key,
    required this.textFieldType,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.textAlign,
    this.textStyle,
    this.autofocus = false,
    this.obscureText,
    this.readOnly,
    this.enabled,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.height,
    this.width,
    this.borderRadius,
    this.hintText,
    this.labelText,
    this.counterText = '',
    this.helperText,
    this.suffixText,
    this.suffixIcon,
    this.suffix,
    this.prefixIcon,
    this.alignment,
    this.margin,
    this.padding,
    this.contentPadding,
    this.sideColor,
    this.fillColor,
    this.helperColor,
    this.labelColor,
    this.inputFormatters,
    this.onTap,
    this.onFieldSubmitted,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.autoValidateMode,
  }) : super(key: key);

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
        focusNode: focusNode,
        validator: validator,
        enabled: enabled,
        textInputAction: textInputAction,
        style: textStyle ?? CustomTextStyle.w500(context),
        onTap: onTap,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        readOnly: readOnly ?? false,
        inputFormatters: inputFormatters,
        textAlign: textAlign ?? TextAlign.start,
        autofocus: autofocus ?? false,
        cursorColor: CustomColors.main,
        obscureText: obscureText ?? false,
        controller: controller,
        maxLength: maxLength,
        maxLines: maxLines,
        minLines: minLines,
        keyboardType: keyboardType,
        autovalidateMode: autoValidateMode,
        decoration: InputDecoration(
          isDense: true,
          hintStyle: CustomTextStyle.w500(context, color: CustomColors.hint),
          labelStyle: CustomTextStyle.w500(context, color: CustomColors.hint),
          floatingLabelStyle: CustomTextStyle.w500(context, color: labelColor ?? CustomColors.hint),
          errorStyle: CustomTextStyle.w500(context, scale: 0.015, color: Colors.red),
          helperStyle: CustomTextStyle.w500(context, scale: 0.015, color: helperColor),
          filled: true,
          fillColor: fillColor ?? Colors.white,
          hintText: hintText,
          labelText: labelText,
          counterText: counterText,
          helperText: helperText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          suffixText: suffixText,
          suffix: suffix,
          suffixStyle: CustomTextStyle.w500(context, scale: 0.015, color: CustomColors.hint),
          suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          contentPadding: _contentPadding(textFieldType),
          border: _border(textFieldType),
          enabledBorder: _border(textFieldType).copyWith(borderSide: BorderSide(color: sideColor ?? CustomColors.hint, width: 1)),
          disabledBorder: _border(textFieldType).copyWith(borderSide: const BorderSide(color: CustomColors.hint, width: 1)),
          focusedBorder: _border(textFieldType),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}

enum TextFieldType { outline, none, underline }