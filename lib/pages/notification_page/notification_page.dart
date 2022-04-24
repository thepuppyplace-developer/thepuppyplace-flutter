import 'package:flutter/material.dart';

import '../../util/common.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, inner) => [
          SliverAppBar(
            snap: true,
            floating: true,
            pinned: true,
            title: Text('알람', style: CustomTextStyle.w600(context, scale: 0.02)),
          )
        ],
        body: CustomScrollView(),
      ),
    );
  }
}
