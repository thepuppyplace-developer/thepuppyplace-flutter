import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/Board.dart';
import 'board_repository.dart';

class TalkBoardListController extends GetxController with StateMixin<List<Board>>{
  final BoardRepository _repository = BoardRepository();

  final RxList<Board> boardList = RxList<Board>([]);
  final RxInt page = RxInt(1);
  final RxString order = RxString('date');

  final RefreshController refreshController = RefreshController();

  @override
  void onReady() {
    super.onReady();
    ever(boardList, _boardListListener);
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

  Future get getBoardList => _repository.categoryBoardList(
      boardList,
      page: page.value,
      category: '수다방',
      order: order.value
  );

  Future refreshBoardList() async{
    boardList.value = await _repository.refreshCategoryBoardList(
        page: page.value,
        category: '수다방',
        order: order.value
    );
  }
}
