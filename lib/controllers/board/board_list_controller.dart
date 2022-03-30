import 'package:get/get.dart';
import '../../models/Board.dart';
import 'board_repository.dart';

class BoardListController extends GetxController with StateMixin<List<Board>>{
  static BoardListController get to => Get.put(BoardListController());

  final BoardRepository _repository = BoardRepository();

  final RxList<Board> _boardList = RxList<Board>([]);
  final RxInt limit = RxInt(5);
  final RxBool _isLoading = RxBool(false);
  bool get isLoading => _isLoading.value;

  @override
  void onReady() {
    super.onReady();
    ever(_boardList, _boardListListener);
    try{
      refreshBoardList();
    } catch(error){
      getBoardList;
    }
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

  Future get getBoardList async{
    _boardList.value = await _repository.boardList;
  }

  Future refreshBoardList() => _repository.refreshBoardList().whenComplete(() => getBoardList);
}