import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../util/common.dart';
import '../../util/jpeg_list.dart';

class BannerCard extends StatefulWidget {
  const BannerCard({Key? key}) : super(key: key);

  @override
  _BannerCardState createState() => _BannerCardState();
}

class _BannerCardState extends State<BannerCard> {
  int _currentIndex = 0;

  final List<String> _bannerList = const <String>[
    JpegList.banner1,
    JpegList.banner2,
  ];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider.builder(
            itemCount: 2,
            options: CarouselOptions(
                viewportFraction: 1,
                height: 151,
                onPageChanged: (int index, index2){
                  setState(() {
                    _currentIndex = index;
                  });
                }
            ),
            itemBuilder: (context, index, index2){
              return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(_bannerList[index], fit: BoxFit.cover, width: mediaWidth(context, 0.9), height: 151));
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
            child: AnimatedSmoothIndicator(
              activeIndex: _currentIndex,
              count: _bannerList.length,
              effect: WormEffect(
                  activeDotColor: CustomColors.mainText,
                  dotColor: CustomColors.hint,
                  dotWidth: mediaWidth(context, 0.02),
                  dotHeight: mediaWidth(context, 0.02)
              ),
            ),
          )
        ],
      ),
    );
  }
}
