import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/Board.dart';
import '../../models/BoardComment.dart';
import '../../repositories/board_repository.dart';

class BoardController extends GetxController with StateMixin<Board>{
  final Board board;
  BoardController(this.board);

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
    _board.value = await _repository.getBoard(board.id);
  }

  Future insertComment(BuildContext context, String comment)
  => _repository.insertComment(context, BoardComment(
      comment: comment,
      boardId: board.id
  )).whenComplete(()
  => getBoard);
}