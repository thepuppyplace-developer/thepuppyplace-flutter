import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/Board.dart';
import '../../repositories/board/board_repository.dart';

class BestBoardListController extends GetxController with StateMixin<List<Board>>{
  final BoardRepository _repository = BoardRepository();

  final RxInt pageIndex = RxInt(0);

  final RxList<Board> boardList = RxList<Board>([]);
  final RxInt limit = RxInt(12);

  final RefreshController refreshController = RefreshController();

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

  Future getBoardList() async{
    boardList.addAll(await _repository.getBoardList(
        limit: limit.value,
        order: 'view'
    ));
  }

  Future refreshBoardList() async{
    boardList.clear();
    boardList.value = await _repository.getBoardList(
      limit: limit.value,
      order: 'view',
    );
  }
}