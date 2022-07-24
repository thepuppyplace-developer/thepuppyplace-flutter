import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thepuppyplace_flutter/controllers/banner/banner_list_controller.dart';
import 'package:thepuppyplace_flutter/widgets/images/custom_cached_network.image.dart';
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
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider.builder(
            itemCount: bannerList!.length,
            options: CarouselOptions(
              clipBehavior: Clip.antiAlias,
              autoPlay: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 500),
                autoPlayInterval: const Duration(seconds: 5),
                enableInfiniteScroll: false,
                viewportFraction: 1,
                height: mediaHeight(context, 0.15),
                aspectRatio: 5/2,
                onPageChanged: (int index, index2){
                  setState(() {
                    _currentIndex = index;
                  });
                }
            ),
            itemBuilder: (context, index, index2){
              final BannerModel banner = bannerList[index];
              return GestureDetector(
                onTap: (){
                  switch(banner.linkType){
                    case 'web':
                      openURL(url: banner.linkURL);
                      break;
                    default:
                      Get.toNamed(banner.linkURL);
                  }
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  margin: basePadding(context),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(banner.imageURL)
                      )
                  ),
                ),
              );
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.03)),
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
