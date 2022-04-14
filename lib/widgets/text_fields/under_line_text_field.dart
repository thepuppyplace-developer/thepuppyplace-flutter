import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../util/common.dart';

class UnderlineTextField extends StatelessWidget {
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
  final double? width;
  final double? borderRadius;
  final String? hintText;
  final String? labelText;
  final String? counterText;
  final String? helperText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? counter;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final EdgeInsets? contentPadding;
  final Color? sideColor;
  final Color? fillColor;
  final Color? helperColor;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;
  final Function(String value)? onFieldSubmitted;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final Alignment? alignment;

  UnderlineTextField({
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
    this.width,
    this.borderRadius,
    this.hintText,
    this.labelText,
    this.counterText,
    this.helperText,
    this.suffixIcon,
    this.prefixIcon,
    this.counter,
    this.margin,
    this.padding,
    this.contentPadding,
    this.sideColor,
    this.fillColor,
    this.helperColor,
    this.inputFormatters,
    this.onTap,
    this.onFieldSubmitted,
    required this.onChanged,
    this.validator,
    this.alignment,
  });
  @override
  Widget build(BuildContext context) {
    UnderlineInputBorder border = UnderlineInputBorder(
        borderSide: BorderSide(color: sideColor ?? CustomColors.main)
    );
    return Container(
      width: width,
      margin: margin,
      padding: padding,
      alignment: alignment,
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
          helperStyle: CustomTextStyle.w500(context, color: helperColor ?? CustomColors.hint),
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
          contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: mediaHeight(context, 0.015)),
          border: border,
          enabledBorder: border.copyWith(borderSide: BorderSide(color: sideColor ?? CustomColors.hint, width: 1)),
          disabledBorder: border.copyWith(borderSide: const BorderSide(color: CustomColors.hint, width: 1)),
          focusedBorder: border,
          counter: counter
        ),
      ),
    );
  }
}