import 'package:get/get.dart';

import '../../models/Board.dart';
import 'board_repository.dart';

class BoardController extends GetxController with StateMixin<Board>{
  final int board_id;
  BoardController(this.board_id);

  final BoardRepository _repository = BoardRepository();

  final Rxn<Board> _board = Rxn<Board>();

  @override
  void onReady() {
    super.onReady();
    ever(_board, _boardListener);
    _findOneBoard();
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

  Future _findOneBoard() async{
    _board.value = await _repository.findOneBoard(board_id);
  }
}