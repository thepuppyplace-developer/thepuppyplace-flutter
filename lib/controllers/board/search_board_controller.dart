import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../models/Board.dart';
import '../../models/Search.dart';
import '../../repositories/board/board_repository.dart';

class SearchBoardListController extends GetxController with StateMixin<List<Board>>{
  final BuildContext context;
  final String query;
  SearchBoardListController(this.context, this.query);
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

  RxInt conditionIndex = RxInt(0);
  final RxString orderBy = RxString('date');


  RxnString queryType(){
    switch(conditionIndex.value){
      case 1: return RxnString('t');
      case 2: return RxnString('d');
      case 3: return RxnString('td');
      default: return RxnString();
    }
  }

  @override
  void onReady() {
    super.onReady();
    ever(_boardList, _searchListListener);
    ever(conditionIndex, _conditionListener);
    ever(orderBy, _orderByListener);
    getSearchBoardList(query);
  }

  void _conditionListener(int condition){
    getSearchBoardList(query);
  }

  void _orderByListener(String orderBy){
    getSearchBoardList(query);
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

  Future getSearchBoardList(String query) async{
    _boardList.value = <Board>[];
    change(null, status: RxStatus.loading());
    if(query.isNotEmpty){
      _boardList.addAll(await _repository.getBoardList(
          query: query,
          order: orderBy.value,
          queryType: queryType().value
      ));
    } else {
      _boardList.value = <Board>[];
    }
  }
}