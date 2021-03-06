import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../config/config.dart';
import '../../models/Board.dart';
import '../../models/BoardComment.dart';
import '../../models/NestedComment.dart';
import '../../repositories/board/board_repository.dart';
import 'board_list_controller.dart';

class BoardController extends GetxController with StateMixin<Board>, Config{
  final int board_id;
  BoardController(this.board_id);

  final BoardRepository _repository = BoardRepository();

  final Rxn<Board> _board = Rxn<Board>();

  final RxInt page = RxInt(1);
  final Rx<TextEditingController> commentController = Rx(TextEditingController());
  final Rxn<RefreshStatus> refreshStatus = Rxn<RefreshStatus>();

  @override
  void onReady() {
    super.onReady();
    ever(_board, _boardListener);
    getBoard;
  }

  void _boardListener(Board? board){
    try{
      change(null, status: RxStatus.loading());
      if(board != null){
        change(board, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future get getBoard async{
    change(null, status: RxStatus.loading());
    _board.value = await _repository.getBoard(board_id);
  }

  Future deleteBoard(BuildContext context)
  => _repository.deleteBoard(context, board_id: board_id).whenComplete(()
  => BoardListController.to.refreshBoardList());

  Future likeBoard(BuildContext context) => _repository.likeBoard(context, board_id).whenComplete(()
  => getBoard);

  Future likeComment(BuildContext context, int comment_id) async{
    await _repository.likeComment(context, comment_id: comment_id);
    return getBoard;
  }

  Future insertComment(BuildContext context, {required String comment}) async{
    if(comment.trim().isNotEmpty){
      await _repository.insertComment(context, board_id: board_id, comment: comment);
      return getBoard;
    } else {
      return showSnackBar(context, '????????? ??????????????????.');
    }
  }

  Future deleteComment(BuildContext context, int comment_id) async{
    Get.back();
    await _repository.deleteComment(context, comment_id: comment_id);
    return getBoard;
  }

  Future insertNestedComment(BuildContext context, {required int comment_id, required String comment}) async{
    if(comment.trim().isNotEmpty){
      await _repository.insertNestedComment(context, comment_id: comment_id, comment: comment);
      return getBoard;
    } else {
      return showSnackBar(context, '????????? ??????????????????.');
    }
  }

  Future deleteNestedComment(BuildContext context, NestedComment comment) async{
    Get.back();
    final int? statusCode = await _repository.deleteNestedComment(context, nested_comment_id: comment.id);
    if(statusCode == 200){
      return getBoard;
    }
  }
}