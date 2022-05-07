import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/views/rx_status_view.dart';

class PhotoListView extends StatelessWidget {
  final List<String> photoList;
  final PhotoType photoType;
  const PhotoListView(this.photoList, this.photoType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          foregroundColor: CustomColors.main,
          backgroundColor: Colors.transparent,
        ),
        body: PhotoViewGallery.builder(
          itemCount: photoList.length,
          builder: (context, index){
            final String photo = photoList[index];
            return PhotoViewGalleryPageOptions(
                imageProvider: _imageProvider(photo),
                heroAttributes: PhotoViewHeroAttributes(tag: photo),
                errorBuilder: (context, object, trace) => CustomErrorView(error: '이미지가 삭제되었습니다.')
            );
          },
          loadingBuilder: (context, event) => const LoadingView(message: '이미지를 불러오는 중입니다.'),
        )
    );
  }

  ImageProvider _imageProvider(String photo){
    switch(photoType){
      case PhotoType.asset: return AssetImage(photo);
      case PhotoType.file : return FileImage(File(photo));
      default: return CachedNetworkImageProvider(photo);
    }
  }
}

enum PhotoType{cached, file, asset}
