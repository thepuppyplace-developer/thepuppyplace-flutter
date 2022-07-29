import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:thepuppyplace_flutter/util/png_list.dart';
import '../../util/common.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageURL;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxFit? fit;
  final String? errorImage;
  final String? emptyImage;
  final BoxShape? shape;
  final BorderRadius? borderRadius;
  final double? opacity;
  final Color? opacityColor;
  final Color? backgroundColor;
  final Clip? clip;

  const CustomCachedNetworkImage(
      this.imageURL, {
        this.height,
        this.width,
        this.padding,
        this.margin,
        this.fit = BoxFit.cover,
        this.shape,
        this.errorImage,
        this.emptyImage,
        this.borderRadius,
        this.opacity = 0.0,
        this.opacityColor = Colors.black,
        this.backgroundColor = CustomColors.emptySide,
        this.clip,
        Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    margin: margin,
    height: height,
    width: width,
    clipBehavior: clip ?? Clip.antiAlias,
    foregroundDecoration: BoxDecoration(
        color: opacityColor?.withOpacity(opacity ?? 0.0),
        borderRadius: shape != null ? null : borderRadius,
        shape: shape ?? BoxShape.rectangle
    ),
    decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: shape != null ? null : borderRadius,
        shape: shape ?? BoxShape.rectangle
    ),
    child: CachedNetworkImage(
      fit: fit,
      errorWidget: _errorWidget,
      progressIndicatorBuilder: _progressIndicatorBuilder,
      imageUrl: imageURL,
    ),
  );

  Widget _errorWidget(BuildContext context, String url, dynamic error) => Container(
    margin: padding,
    decoration: BoxDecoration(
      shape: shape ?? BoxShape.rectangle,
        borderRadius: borderRadius,
        color: backgroundColor,
        image: DecorationImage(
          fit: fit,
            image: AssetImage(errorImage ?? PngList.default_profile)
        )
    ),
  );

  Widget _progressIndicatorBuilder(BuildContext context, String url, DownloadProgress downloadProgress) => SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: LayoutBuilder(
      builder: (context, constraints){
        final double radius = constraints.maxHeight / 15;
        return CircularPercentIndicator(
          animation: true,
          animateFromLastPercent: true,
          radius: radius,
          percent: downloadProgress.downloaded / (downloadProgress.totalSize ?? 0.0),
          lineWidth: radius / 5,
          backgroundColor: CustomColors.emptySide,
          progressColor: CustomColors.main,
        );
      },
    ),
    // child: CupertinoActivityIndicator.partiallyRevealed(progress: downloadProgress.progress ?? 1.0)
  );
}