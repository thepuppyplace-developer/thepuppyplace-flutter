import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/common.dart';

class SelectButton extends StatelessWidget {
  final String text;
  final int? currentIndex;
  final int index;
  final Function(int) onChanged;

  const SelectButton({
    required this.text,
    required this.currentIndex,
    required this.index,
    required this.onChanged,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mediaHeight(context, 0.06),
      padding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: currentIndex == index ? CustomColors.main : CustomColors.hint)
            ),
            child: Text(text, style: CustomTextStyle.w500(context, color: currentIndex == index ? CustomColors.main : CustomColors.hint, scale: 0.012))),
        onPressed: (){
          onChanged(index);
        },
      ),
    );
  }
}
