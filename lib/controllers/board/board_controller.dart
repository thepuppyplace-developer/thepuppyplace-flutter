import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/Board.dart';
import 'board_repository.dart';

class BoardController extends GetxController with StateMixin<Board>{
  final int board_id;
  BoardController(this.board_id);

  final BoardRepository _repository = BoardRepository();

  final Rxn<Board> _board = Rxn<Board>();
  Board? get board => _board.value;

  final RxInt page = RxInt(1);
  final Rx<TextEditingController> commentController = Rx(TextEditingController());
  final Rxn<RefreshStatus> refreshStatus = Rxn<RefreshStatus>();

  @override
  void onReady() {
    super.onReady();
    ever(_board, _boardListener);
    getBoard();
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

  Future getBoard() async{
    _board.value = await _repository.findOneBoard(board_id);
  }

  Future insertComment() async{
    _repository.insertComment(
        board_id: board_id,
        user_id: 1,
        comment: commentController.value.text).whenComplete(() => getBoard());
    commentController.value.clear();
  }
}