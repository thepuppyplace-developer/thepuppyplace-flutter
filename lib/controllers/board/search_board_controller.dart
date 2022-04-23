import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../models/Board.dart';
import '../../models/Search.dart';
import '../../repositories/board_repository.dart';

class SearchBoardListController extends GetxController with StateMixin<List<Board>>{
  final BuildContext context;
  SearchBoardListController(this.context);

  final RxList<Board> _boardList = RxList<Board>([]);
  final BoardRepository _repository = BoardRepository();
  final Rx<TextEditingController> keywordController = Rx(TextEditingController());
  List<Board> get boardList => _boardList;

  final page = RxInt(1);

  @override
  void onReady() {
    super.onReady();
    ever(_boardList, _searchListListener);
    getSearchBoardList();
  }

  void _searchListListener(List<Board> searchList){
    try{
      change(null, status: RxStatus.loading());
      if(searchList.isNotEmpty){
        change(searchList, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future getSearchBoardList({String? keyword}) async{
    _boardList.value = <Board>[];
    change(null, status: RxStatus.loading());
    if(keyword != null){
      _boardList.addAll(await _repository.getBoardList(page: page.value, query: keyword));
    } else {
      _boardList.value = <Board>[];
    }
  }
}