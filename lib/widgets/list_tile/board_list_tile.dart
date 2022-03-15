import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/board/board/board_binding.dart';

import '../../models/Board.dart';
import '../../pages/board_page/board_details_page.dart';

class BoardListTile extends StatelessWidget {
  final Board board;

  const BoardListTile({
    required this.board,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: (){
          Get.to(() => BoardDetailsPage(), binding: BoardBinding(board.board_id!));
        },
        title: Text(board.title),
        subtitle: Column(
          children: [
            Text(board.user!.nickname ?? ''),
          ],
        ),
      ),
    );
  }
}
