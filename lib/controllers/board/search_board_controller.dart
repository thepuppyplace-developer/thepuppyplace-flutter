import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../models/Board.dart';
import '../../models/Search.dart';
import '../../repositories/board_repository.dart';

class SearchController extends GetxController with StateMixin<List<Board>>{
  final RxList<Board> _boardList = RxList<Board>([]);
  final RxList<Search> _searchList = RxList<Search>([]);
  final BoardRepository _repository = BoardRepository();
  final Rx<TextEditingController> keywordController = Rx(TextEditingController());

  List<Search> get searchList => _searchList;

  @override
  void onReady() {
    super.onReady();
    ever(_boardList, _searchListListener);
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
}