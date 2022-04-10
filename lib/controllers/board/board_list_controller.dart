import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/Board.dart';
import 'board_repository.dart';

class BoardListController extends GetxController with StateMixin<List<Board>>{
  static BoardListController get to => Get.put(BoardListController());
  final BoardRepository _repository = BoardRepository();

  final RxList<Board> _boardList = RxList<Board>([]);
  List<Board> get boardList => _boardList;
  final Rxn<RefreshStatus> refreshStatus = Rxn<RefreshStatus>();
  final RxInt page = RxInt(1);

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

  Future get getBoardList => _repository.getBoardList(_boardList, page.value);
}