import 'dart:async';
import 'package:flutter/material.dart';

import '../../util/common.dart';

class TextTimer extends StatefulWidget {
  final int minute;
  final Function(String) onCancel;
  final TextStyle? textStyle;
  final EdgeInsets? margin;
  final Alignment? alignment;

  const TextTimer({
    required this.minute,
    required this.onCancel,
    this.textStyle,
    this.margin,
    this.alignment,
    Key? key}) : super(key: key);

  @override
  State<TextTimer> createState() => _TextTimerState();
}

class _TextTimerState extends State<TextTimer> {
  int _second = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _second = widget.minute * 60;
    if(_second > 0){
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if(_second > 0){
          setState(() => _second--);
        } else {
          widget.onCancel('세션이 만료되었습니다.');
          timer.cancel();
        }
      });
    } else {
      widget.onCancel('세션이 만료되었습니다.');
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.alignment,
      margin: widget.margin,
      child: Text('${(_second ~/ 60).toString().padLeft(2, '0')}:${(_second % 60).toString().padLeft(2, '0')}', style: widget.textStyle ?? CustomTextStyle.w500(context, scale: 0.015, color: CustomColors.main)),
    );
  }
}