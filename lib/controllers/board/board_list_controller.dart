import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/Board.dart';
import '../../repositories/board/board_repository.dart';

class BoardListController extends GetxController with StateMixin<List<Board>>{
  static BoardListController get to => Get.put(BoardListController());
  final BoardRepository _repository = BoardRepository();

  final RxList<Board> boardList = RxList<Board>([]);
  final Rxn<RefreshStatus> refreshStatus = Rxn<RefreshStatus>();
  final RxInt page = RxInt(1);

  @override
  void onReady() {
    super.onReady();
    ever(boardList, _boardListListener);
    getBoardList();
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

  Future refreshBoardList() async{
    page.value = 1;
    boardList.value = await _repository.getBoardList(page: page.value);
  }

  Future getBoardList() async{
    boardList.addAll(await _repository.getBoardList(page: page.value));
  }
}