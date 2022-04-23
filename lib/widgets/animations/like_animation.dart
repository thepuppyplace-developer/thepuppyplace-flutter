import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

class LikeAnimation extends StatefulWidget {
  final Future onCompleted;

  const LikeAnimation(this.onCompleted, {Key? key}) : super(key: key);

  @override
  _LikeAnimationState createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..forward(from: 0);
    _animation = Tween(begin: 1.0, end: 1.5).animate(CurvedAnimation(parent: _controller, curve: const Interval(0, 1, curve: Curves.bounceOut)));
    _animation.addStatusListener((status) {
      switch(status){
        case AnimationStatus.completed :
          Get.back();
          widget.onCompleted;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      alignment: Alignment.center,
      scale: _animation,
      child: Icon(CupertinoIcons.heart_fill, color: Colors.red, size: mediaHeight(context, 0.1)),
    );
  }
}