import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/enums.dart';
import 'package:thepuppyplace_flutter/util/error_messages.dart';
import 'package:thepuppyplace_flutter/views/status/rx_status_view.dart';
import 'package:thepuppyplace_flutter/widgets/loadings/refresh_contents.dart';

class FutureListStateView<T> extends StatelessWidget {

  final RefreshController refreshCtr;

  final List<T> children;

  final Function() onRefresh;

  final Function()? onLoading;

  final Widget Function(BuildContext, T) itemBuilder;

  final int? itemCount;

  final EdgeInsetsGeometry? padding;

  final Widget Function(BuildContext, int)? separatorBuilder;

  final double? spacing;

  const FutureListStateView({
    required this.refreshCtr,
    required this.children,
    required this.onRefresh,
    required this.itemBuilder,
    this.itemCount,
    this.padding,
    this.separatorBuilder,
    this.spacing,
    this.onLoading,
    Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) => SmartRefresher(
    controller: refreshCtr,
    onRefresh: onRefresh,
    onLoading: onLoading,
    header: CustomHeader(builder: (context, status) => RefreshContents(status)),
    footer: CustomFooter(builder: (context, status) => LoadContents(status)),
    child: Builder(
      builder: (context) {
        return Scrollbar(
          child: ListView.separated(
            padding: padding,
            separatorBuilder: separatorBuilder ?? (context, index) => SizedBox(height: spacing),
            itemCount: itemCount ?? children.length,
            itemBuilder: (context, index) {
              final T object = children[index];
              return itemBuilder(context, object);
            },
          ),
        );
      }
    ),
  );
}


