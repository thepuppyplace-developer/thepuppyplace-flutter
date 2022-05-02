import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/Board.dart';
import '../../repositories/board/board_repository.dart';

class CafeBoardListController extends GetxController with StateMixin<List<Board>>{
  final String? queryString;
  CafeBoardListController(this.queryString);

  final BoardRepository _repository = BoardRepository();

  final RxList<Board> boardList = RxList<Board>([]);
  final RxInt page = RxInt(1);
  final RxString order = RxString('date');
  RxnString get query => RxnString(queryString);

  final RefreshController refreshController = RefreshController();

  @override
  void onReady() {
    super.onReady();
    ever(boardList, _boardListListener);
    refreshBoardList();
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
        page: page.value,
        category: '카페',
        order: order.value,
        query: query.value
    ));
  }

  Future refreshBoardList() async{
    page.value = 1;
    boardList.value = await _repository.getBoardList(
        page: page.value,
        category: '카페',
        order: order.value,
        query: query.value
    );
  }
}