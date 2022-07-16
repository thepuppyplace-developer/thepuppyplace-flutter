import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../util/common.dart';
import '../../widgets/buttons/custom_icon_button.dart';
import '../rx_status_view.dart';

class PhotoListView extends StatefulWidget {
  final List<String> photoList;
  final PhotoListType photoType;
  final int currentIndex;

  const PhotoListView(this.photoList, this.photoType, {required this.currentIndex, Key? key}) : super(key: key);

  @override
  State<PhotoListView> createState() => _PhotoListViewState();
}

class _PhotoListViewState extends State<PhotoListView> {
  late PageController _pageController;
  final PhotoViewController _photoController = PhotoViewController();
  final PhotoViewScaleStateController _scaleController = PhotoViewScaleStateController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
    _photoController.dispose();
    _scaleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          foregroundColor: CustomColors.main,
          backgroundColor: Colors.transparent,
          titleTextStyle: CustomTextStyle.appBarStyle(context),
          title: Text('${_currentIndex + 1}/${widget.photoList.length}'),
          actions: [
            CustomIconButton(
                icon: Icons.clear,
                color: CustomColors.main,
                onTap: () => Navigator.of(_scaffoldKey.currentContext ?? context).pop()
            )
          ],
        ),
        body: PhotoViewGallery.builder(
          pageController: _pageController,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          itemCount: widget.photoList.length,
          builder: (context, index){
            final String photo = widget.photoList[index];
            return PhotoViewGalleryPageOptions(
                controller: _photoController,
                scaleStateController: _scaleController,
                initialScale: PhotoViewComputedScale.contained * 0.8,
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: 3.0,
                imageProvider: _imageProvider(photo),
                heroAttributes: PhotoViewHeroAttributes(tag: photo),
                errorBuilder: (context, object, trace) => const ErrorView('이미지가 삭제되었습니다.')
            );
          },
          loadingBuilder: (context, event) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularPercentIndicator(
                  radius: mediaWidth(context, 0.1),
                  progressColor: CustomColors.main,
                  fillColor: CustomColors.hint,
                  percent: (event?.cumulativeBytesLoaded ?? 0) * 0.01,
                  circularStrokeCap: CircularStrokeCap.round
              ),
              Text('${(event?.cumulativeBytesLoaded ?? 0) * 0.01}/100', style: CustomTextStyle.w500(context, color: Colors.white))
            ],
          ),
        )
    );
  }

  ImageProvider _imageProvider(String photo){
    switch(widget.photoType){
      case PhotoListType.asset: return AssetImage(photo);
      case PhotoListType.file : return FileImage(File(photo));
      default: return CachedNetworkImageProvider(photo);
    }
  }
}

enum PhotoListType{cached, file, asset}