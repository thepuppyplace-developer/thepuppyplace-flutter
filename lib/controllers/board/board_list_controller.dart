import 'package:get/get.dart';

import '../../models/Board.dart';
import 'board_repository.dart';

class BoardListController extends GetxController with StateMixin<List<Board>>{
  final BoardRepository _repository = BoardRepository();

  final RxList<Board> _boardList = RxList(<Board>[]);

  @override
  void onReady() {
    super.onReady();
    ever(_boardList, _boardListListener);
    findAllBoard();
  }

  void _boardListListener(List<Board> boardList){
    try{
      change(null, status: RxStatus.loading());
      if(boardList.isNotEmpty){
        change(boardList, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future findAllBoard() async{
    _boardList.value = <Board>[
      Board(userId: 1, title: 'test1', description: 'test1', location: '경기도 고양시 일산동구', photoList: [], tagList: ['카페'])
    ];
    // _boardList.value = await _repository.findAllBoard();
  }
}