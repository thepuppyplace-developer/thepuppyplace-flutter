import 'package:get/get.dart';

import '../../models/Board.dart';
import 'board_repository.dart';

class HotelBoardListController extends GetxController with StateMixin<List<Board>>{
  final BoardRepository _repository = BoardRepository();

  final RxList<Board> _boardList = RxList<Board>([]);
  final RxInt limit = RxInt(5);

  List<Board> get boardList => _boardList;

  @override
  void onReady() {
    super.onReady();
    ever(_boardList, _boardListListener);
    getBoardList;
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

  Future refreshBoardList() => _repository.refreshBoardList().whenComplete(() => getBoardList);

  Future get getBoardList async{
    _boardList.value = await _repository.hotelBoardList;
  }
}