import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../models/Board.dart';
import '../../models/Search.dart';
import '../../repositories/board/board_repository.dart';

class SearchBoardListController extends GetxController with StateMixin<List<Board>>{
  final BuildContext context;
  SearchBoardListController(this.context);
  final BoardRepository _repository = BoardRepository();

  final RxList<Board> _boardList = RxList<Board>([]);
  final Rx<TextEditingController> keywordController = Rx(TextEditingController());
  List<Board> get boardList => _boardList;
  List<Board> get cafeList => _boardList.where((board) => board.category == '카페').map((board) => board).toList();
  List<Board> get foodList => _boardList.where((board) => board.category == '음식점').map((board) => board).toList();
  List<Board> get shoppingList => _boardList.where((board) => board.category == '쇼핑몰').map((board) => board).toList();
  List<Board> get hotelList => _boardList.where((board) => board.category == '호텔').map((board) => board).toList();
  List<Board> get groundList => _boardList.where((board) => board.category == '운동장').map((board) => board).toList();
  List<Board> get talkList => _boardList.where((board) => board.category == '수다방').map((board) => board).toList();

  final RxInt conditionIndex = RxInt(0);
  final RxString orderBy = RxString('date');

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