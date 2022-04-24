import 'package:flutter/material.dart';

import '../../util/common.dart';
import '../../widgets/buttons/custom_text_button.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, inner) => [
          SliverAppBar(
            snap: true,
            floating: true,
            pinned: true,
            elevation: 0.5,
            title: Text('서비스 이용약관', style: CustomTextStyle.w600(context, scale: 0.02)),
          )
        ],
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index){
              }),
            )
          ],
        ),
      ),
    );
  }
}
