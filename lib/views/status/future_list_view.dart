import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/enums.dart';
import 'package:thepuppyplace_flutter/util/error_messages.dart';
import 'package:thepuppyplace_flutter/views/status/rx_status_view.dart';

class FutureListView<T> extends StatelessWidget {
  final FutureState state;
  final List<T> children;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget? onEmpty;
  final Widget? onLoading;
  final Widget Function(String)? onError;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final ScrollController? scrollCtr;

  const FutureListView({
    required this.state,
    required this.children,
    required this.itemBuilder,
    this.onEmpty,
    this.onLoading,
    this.onError,
    this.padding,
    this.spacing,
    this.scrollCtr,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch(state){
      case FutureState.loading :
        return onLoading ?? const LoadingView(message: '');
      case FutureState.error :
        if(onError == null) {
          return Container();
        } else {
          return onError!('error');
        }
      case FutureState.empty :
        return onEmpty ?? Container();
      case FutureState.success :
        return ListView.separated(
          controller: scrollCtr,
          padding: padding,
          separatorBuilder: (context, index) =>
              SizedBox(height: spacing ?? 20),
          itemCount: children.length,
          itemBuilder: itemBuilder,
        );
      case FutureState.network:
        return const EmptyView(message: ErrorMessages.network_please);
    }
  }
}

