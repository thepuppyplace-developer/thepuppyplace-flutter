import 'package:flutter/material.dart';

import '../../util/customs.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({Key? key}) : super(key: key);

  @override
  _InsertPageState createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  @override
  Widget build(BuildContext context) {
    return LoadingView();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('게시글 작성'),
          )
        ],
      ),
    );
  }
}
