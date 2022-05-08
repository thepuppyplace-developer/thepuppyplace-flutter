import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../models/Board.dart';
import '../../models/Search.dart';
import '../../repositories/board/board_repository.dart';

class SearchBoardListController extends GetxController with StateMixin<Map<String, List<Board>>>{
  final BuildContext context;
  final String query;

  SearchBoardListController(this.context, this.query);

  final BoardRepository _repository = BoardRepository();

  final RxMap<String, List<Board>> _searchBoardList = RxMap<String, List<Board>>();

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

  int searchListLength(){
    int length = 0;
    for(String category in _searchBoardList.keys){
      length += _searchBoardList[category]!.length;
    }
    return length;
  }

  @override
  void onReady() {
    super.onReady();
    ever(_searchBoardList, _searchBoardListListener);
    ever(conditionIndex, _conditionListener);
    ever(orderBy, _orderByListener);
    getSearchBoardList();
  }

  void _conditionListener(int condition){
    change(null, status: RxStatus.loading());
    getSearchBoardList();
  }

  void _orderByListener(String orderBy){
    change(null, status: RxStatus.loading());
    getSearchBoardList();
  }

  void _searchBoardListListener(Map<String, List<Board>> searchList){
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

  Future getSearchBoardList() async{
    _searchBoardList.value = await _repository.getSearchBoardList(query: query, queryType: queryType().value, order: orderBy.value);
  }
}