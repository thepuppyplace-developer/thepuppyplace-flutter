import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../models/Board.dart';
import '../../repositories/board/board_repository.dart';

class SearchBoardListController extends GetxController with StateMixin<List<Board>>{
  final BuildContext context;
  final String query;

  SearchBoardListController(this.context, this.query);

  final BoardRepository _repository = BoardRepository();

  final RxList<Board> _searchBoardList = RxList<Board>();

  List<Board> get cafeList => _searchBoardList.where((board) => board.category == '카페').toList();
  List<Board> get foodList => _searchBoardList.where((board) => board.category == '음식점').toList();
  List<Board> get shoppingList => _searchBoardList.where((board) => board.category == '쇼핑몰').toList();
  List<Board> get hotelList => _searchBoardList.where((board) => board.category == '호텔').toList();
  List<Board> get groundList => _searchBoardList.where((board) => board.category == '운동장').toList();
  List<Board> get talkList => _searchBoardList.where((board) => board.category == '수다방').toList();

  RxInt conditionIndex = RxInt(0);

  final RxString orderBy = RxString('date');

  final RxString queryString = RxString('');

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
    ever(conditionIndex, _conditionListener);
    ever(orderBy, _orderByListener);
    ever(queryString, _queryListener);
    ever(_searchBoardList, _searchBoardListListener);
    queryString.value = query;
  }

  void _queryListener(String query){
    getSearchBoardList;
  }

  void _conditionListener(int condition){
    getSearchBoardList;
  }

  void _orderByListener(String orderBy){
    getSearchBoardList;
  }

  int get searchListLength => _searchBoardList.length;

  void _searchBoardListListener(List<Board> searchList){
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

  Future get getSearchBoardList async{
    change(null, status: RxStatus.loading());
    final Response res  = await _repository.getSearchBoardList(query: queryString.value, queryType: queryType().value, order: orderBy.value);
    switch(res.statusCode){
      case 200:
        final List<Board> boardList = List.from(res.body['data']).map((board) => Board.fromJson(board)).toList();
        _searchBoardList.value = boardList;
        break;
      case 204:
        _searchBoardList.clear();
        break;
      case null:
        change(null, status: RxStatus.error('인터넷 연결을 확인해주세요.'));
    }
  }
}