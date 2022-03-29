import 'package:flutter/cupertino.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

class HeaderDelegate extends SliverPersistentHeaderDelegate{
  double max;
  double min;
  final Widget child;

  HeaderDelegate({required this.child, required this.max, required this.min});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => max;

  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}