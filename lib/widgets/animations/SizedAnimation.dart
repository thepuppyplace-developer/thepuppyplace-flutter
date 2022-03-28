import 'package:flutter/material.dart';

class SizedAnimation extends StatefulWidget {
  Widget child;

  SizedAnimation({
    required this.child,
    Key? key}) : super(key: key);

  @override
  _SizedAnimationState createState() => _SizedAnimationState();
}

class _SizedAnimationState extends State<SizedAnimation> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
    _animation = Tween(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _controller, curve: const Interval(0, 1, curve: Curves.bounceOut)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}