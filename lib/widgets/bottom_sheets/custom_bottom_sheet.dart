import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButtonsBottomSheet extends StatelessWidget {
  final List<Widget> actions;

  const CustomButtonsBottomSheet({required this.actions, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [

      ],
    );
  }
}
