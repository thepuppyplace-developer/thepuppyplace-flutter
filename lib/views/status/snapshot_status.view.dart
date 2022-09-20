import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/views/status/rx_status_view.dart';

class SnapshotStatusView<T> extends StatelessWidget {
  final AsyncSnapshot<T> snapshot;
  final Widget Function(BuildContext, T?) builder;
  final Widget? onLoading;
  final Widget? onEmpty;
  final Widget Function(String? error)? onError;

  const SnapshotStatusView({
    required this.snapshot,
    required this.builder,
    this.onLoading,
    this.onEmpty,
    this.onError,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    if(snapshot.connectionState == ConnectionState.waiting){
      return onLoading ?? const LoadingView(message: '');
    } else if(!snapshot.hasData){
      return onEmpty ?? Container();
    } else if(snapshot.hasError){
      if(onError != null){
        return onError!(snapshot.error.toString());
      } else {
        return Container();
      }
    } else {
      return builder(context, snapshot.data);
    }
  }
}
