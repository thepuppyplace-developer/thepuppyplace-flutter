import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class CustomFadeAnimationView extends StatelessWidget {
  Widget child;
  int? milliseconds;

  CustomFadeAnimationView({
    required this.child,
    this.milliseconds,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: Duration(milliseconds: milliseconds ?? 500),
      transitionBuilder: (Widget child, Animation<double> animation, Animation<double> secondaryAnimation){
        return FadeThroughTransition(animation: animation, secondaryAnimation: secondaryAnimation, child: child);
      },
      child: child,
    );
  }
}
