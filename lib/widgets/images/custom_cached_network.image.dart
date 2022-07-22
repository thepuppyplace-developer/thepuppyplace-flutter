import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'error.image.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageURL;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxFit? fit;
  final Alignment? alignment;

  const CustomCachedNetworkImage(
      this.imageURL, {
        this.height,
        this.width,
        this.padding,
        this.margin,
        this.fit,
        this.alignment,
        Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: CachedNetworkImage(
        alignment: alignment ?? Alignment.center,
        fit: fit,
        errorWidget: (context, url, error) => ErrorImage(height: height, width: width),
        progressIndicatorBuilder: (context, url, downloadProgress){
          return CupertinoActivityIndicator.partiallyRevealed(progress: downloadProgress.progress ?? 1.0);
        },
        height: height,
        width: width,
        imageUrl: imageURL,
      ),
    );
  }
}