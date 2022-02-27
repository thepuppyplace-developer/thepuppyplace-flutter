import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../util/common.dart';

class OutlineTextField extends StatefulWidget {
  TextEditingController controller;
  TextInputType keyboardType;
  TextStyle? textStyle;
  TextAlign? textAlign;
  bool? autofocus, obscureText;
  int? maxLength, maxLines, minLines;
  double? height, width;
  String? hintText, labelText, counterText, helperText;
  Widget? suffixIcon;
  EdgeInsets? margin, padding;
  Color? sideColor;
  List<TextInputFormatter>? inputFormatters;
  Function(String)? onChanged;

  OutlineTextField({
    required this.controller,
    required this.keyboardType,
    this.textAlign,
    this.textStyle,
    this.autofocus,
    this.obscureText,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.height,
    this.width,
    this.hintText,
    this.labelText,
    this.counterText,
    this.helperText,
    this.suffixIcon,
    this.margin,
    this.padding,
    this.sideColor,
    this.inputFormatters,
    this.onChanged,
    Key? key}) : super(key: key);

  @override
  State<OutlineTextField> createState() => _OutlineTextFieldState();
}

class _OutlineTextFieldState extends State<OutlineTextField> {
  OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: CustomColors.main)
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? mediaHeight(context, 0.05),
      width: widget.width,
      margin: widget.margin,
      child: TextFormField(
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged ?? (String value){setState((){});},
        textAlign: widget.textAlign ?? TextAlign.start,
        autofocus: widget.autofocus ?? true,
        cursorColor: CustomColors.main,
        obscureText: widget.obscureText ?? false,
        controller: widget.controller,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines ?? 1,
        minLines: widget.minLines,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white54,
          hintText: widget.hintText,
          labelText: widget.labelText,
          counterText: widget.counterText,
          helperText: widget.helperText,
          suffixIcon: widget.controller.text.isEmpty ? null : widget.suffixIcon ?? IconButton(
            iconSize: 15,
            icon: const Icon(Icons.cancel_outlined, color: CustomColors.hint),
            onPressed: (){
              setState(() {
                widget.controller.clear();
              });
            },
          ),
          contentPadding: widget.padding ?? EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.03)),
          border: border,
          enabledBorder: border.copyWith(borderSide: BorderSide(color: widget.sideColor ?? CustomColors.hint, width: 1)),
          focusedBorder: border,
        ),
      ),
    );
  }
}