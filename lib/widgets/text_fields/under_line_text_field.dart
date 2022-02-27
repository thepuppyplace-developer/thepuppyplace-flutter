import 'package:flutter/material.dart';

import '../../util/common.dart';

class UnderlineTextField extends StatefulWidget {
  TextEditingController controller;
  TextInputType keyboardType;
  TextStyle? textStyle, helperStyle;
  bool? obscureText;
  int? maxLength, maxLines, minLines;
  String? hintText, labelText, counterText, helperText;
  Widget? suffixIcon;
  EdgeInsets? margin, padding;
  Function(String)? onChanged;

  UnderlineTextField({
    required this.controller,
    required this.keyboardType,
    this.onChanged,
    this.obscureText,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.hintText,
    this.labelText,
    this.counterText,
    this.helperText,
    this.suffixIcon,
    this.margin,
    this.padding,
    Key? key}) : super(key: key);

  @override
  _UnderlineTextFieldState createState() => _UnderlineTextFieldState();
}

class _UnderlineTextFieldState extends State<UnderlineTextField> {

  UnderlineInputBorder border = const UnderlineInputBorder(
      borderSide: BorderSide(color: CustomColors.main, width: 1)
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.symmetric(vertical: mediaHeight(context, 0.005)),
      child: TextFormField(
        onChanged: widget.onChanged ?? (val){setState((){});},
        obscureText: widget.obscureText ?? false,
        controller: widget.controller,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.labelText,
            counterText: widget.counterText,
            helperText: widget.helperText,
            suffixIcon: widget.controller.text.isEmpty
                ? null
                : widget.suffixIcon ?? IconButton(
              color: CustomColors.hint,
              icon: const Icon(Icons.clear),
              onPressed: (){
                setState(() {
                  widget.controller.clear();
                });
              },
            ),
            contentPadding: widget.padding ?? EdgeInsets.symmetric(vertical: mediaHeight(context, 0.015)),
            border: border,
            enabledBorder: border.copyWith(borderSide: const BorderSide(color: CustomColors.hint)),
            focusedBorder: border,
            helperStyle: widget.helperStyle ?? Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.blueGrey, fontSize: mediaHeight(context, 0.012))
        ),
      ),
    );
  }
}

