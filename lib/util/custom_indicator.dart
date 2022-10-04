import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomIndicator{

  static CustomIndicator get instance => CustomIndicator();

  Widget _buildIndicator(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5)
      ),
      alignment: Alignment.center,
      child: const CupertinoActivityIndicator(),
    );
  }

  void show(BuildContext context,  Future future) {
    final OverlayEntry overlayEntry = OverlayEntry(builder: _buildIndicator);

    if(!overlayEntry.mounted){
      OverlayState overlayState = Overlay.of(context)!;
      
      overlayState.insert(overlayEntry);
      
      future.whenComplete(() => overlayEntry.remove());
    }
  }
}