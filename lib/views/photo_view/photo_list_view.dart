import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/views/rx_status_view.dart';

class PhotoListView extends StatefulWidget {
  final int initIndex;
  final List<String> photoList;
  final PhotoType photoType;
  const PhotoListView(this.initIndex, this.photoList, this.photoType, {Key? key}) : super(key: key);

  @override
  State<PhotoListView> createState() => _PhotoListViewState();
}

class _PhotoListViewState extends State<PhotoListView> {
  late PageController _pageController;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initIndex;
    _pageController = PageController(initialPage: widget.initIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          foregroundColor: CustomColors.main,
          backgroundColor: Colors.transparent,
          titleTextStyle: CustomTextStyle.w600(context, color: CustomColors.main),
          title: Text('${_currentIndex + 1}/${widget.photoList.length}'),
        ),
        body: PhotoViewGallery.builder(
          pageController: _pageController,
          onPageChanged: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          itemCount: widget.photoList.length,
          builder: (context, index){
            final String photo = widget.photoList[index];
            return PhotoViewGalleryPageOptions(
                imageProvider: _imageProvider(photo),
                errorBuilder: (context, object, trace) => CustomErrorView(error: '이미지가 삭제되었습니다.')
            );
          },
          loadingBuilder: (context, event) => const LoadingView(message: '이미지를 불러오는 중입니다.'),
        )
    );
  }

  ImageProvider _imageProvider(String photo){
    switch(widget.photoType){
      case PhotoType.asset: return AssetImage(photo);
      case PhotoType.file : return FileImage(File(photo));
      default: return CachedNetworkImageProvider(photo);
    }
  }
}

enum PhotoType{cached, file, asset}
