import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../models/Board.dart';
import 'board_repository.dart';

class BoardListController extends GetxController with StateMixin<List<Board>>{
  static BoardListController get to => Get.put(BoardListController());

  final BoardRepository _repository = BoardRepository();

  final RxList<Board> _boardList = RxList<Board>([]);
  final RxInt _limit = RxInt(5);
  int get limit => _limit.value;
  final RxBool _isLoading = RxBool(false);
  bool get isLoading => _isLoading.value;

  @override
  void onReady() {
    super.onReady();
    ever(_boardList, _boardListListener);
    _findAllBoard();
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

  Future _findAllBoard() async{
    List<Board> boardList = await _repository.findAllBoard();
    if(_limit.value < boardList.length){
      _boardList.value = List.generate(_limit.value, (index) => boardList[index]);
    } else {
      _boardList.value = await _repository.findAllBoard();
    }
    _isLoading.value = false;
  }
}