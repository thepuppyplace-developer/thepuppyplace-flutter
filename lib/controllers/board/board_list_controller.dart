import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepuppyplace_flutter/controllers/database_controller.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../models/Board.dart';
import 'board_repository.dart';

class BoardListController extends GetxController with StateMixin<List<Board>>{
  static BoardListController get to => Get.put(BoardListController());
  final BoardRepository _repository = BoardRepository();

  final RxList<Board> _boardList = RxList<Board>([]);
  List<Board> get boardList => _boardList;
  final Rxn<RefreshStatus> refreshStatus = Rxn<RefreshStatus>();
  final RxInt limit = RxInt(5);
  final RxnString refreshDate = RxnString();

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
    _boardList.value = await _repository.boardList(limit.value);
  }

  Future refreshBoardList() async{
    SharedPreferences spf = await DatabaseController.spf;
    refreshStatus.value = await _repository.refreshBoardList();
    String? date = spf.getString('boardRefreshDate');
    if(date == null){
      refreshDate.value = '동기화되지 않음';
    } else {
      refreshDate.value = '동기화 날짜: ${beforeDate(DateTime.parse(date))}';
    }
    return getBoardList;
  }
}