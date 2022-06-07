import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thepuppyplace_flutter/controllers/banner/banner_list_controller.dart';
import '../../models/BannerModel.dart';
import '../../util/common.dart';

class BannerCard extends StatefulWidget {
  const BannerCard({Key? key}) : super(key: key);

  @override
  _BannerCardState createState() => _BannerCardState();
}

class _BannerCardState extends State<BannerCard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) => GetBuilder<BannerListController>(
    autoRemove: false,
      init: BannerListController(),
      builder: (BannerListController controller) => controller.obx((bannerList) => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider.builder(
            itemCount: bannerList!.length,
            options: CarouselOptions(
                enableInfiniteScroll: false,
                viewportFraction: 1,
                aspectRatio: 8/3,
                onPageChanged: (int index, index2){
                  setState(() {
                    _currentIndex = index;
                  });
                }
            ),
            itemBuilder: (context, index, index2){
              final BannerModel banner = bannerList[index];
              return CupertinoButton(
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.zero,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(banner.imageURL)
                      )
                  ),
                ),
                onPressed: (){
                  switch(banner.linkType){
                    case 'web':
                      openURL(url: banner.linkURL);
                      break;
                    default:
                      Get.toNamed(banner.linkURL);
                  }
                },
              );
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.015)),
            child: AnimatedSmoothIndicator(
              activeIndex: _currentIndex,
              count: bannerList.length,
              effect: WormEffect(
                  activeDotColor: Colors.white,
                  dotColor: CustomColors.hint,
                  dotWidth: mediaWidth(context, 0.02),
                  dotHeight: mediaWidth(context, 0.02)
              ),
            ),
          )
        ],
      ),
          onEmpty: Container(),
          onError: (error) => Container(),
          onLoading: Container()
      )
  );
}
