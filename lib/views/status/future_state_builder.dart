import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/enums.dart';
import 'package:thepuppyplace_flutter/util/error_messages.dart';
import 'package:thepuppyplace_flutter/views/status/rx_status_view.dart';

class FutureStateBuilder<T> extends StatelessWidget {
  final FutureState state;
  final T? object;
  final Widget Function(BuildContext context, FutureState, T?) builder;
  final EdgeInsetsGeometry? padding;

  const FutureStateBuilder({
    required this.state,
    required this.object,
    required this.builder,
    this.padding,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try{
      if(object == null) return const LoadingView();
      switch(state){
        case FutureState.network:
          return const EmptyView(message: ErrorMessages.network_please);
        default:
          return Container(
              padding: padding,
              child: builder(context, state, object)
          );
      }
    } catch(error){
      return builder(context, FutureState.error, object);
    }
  }
}

