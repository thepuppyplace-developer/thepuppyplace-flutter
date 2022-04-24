import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../models/Search.dart';
import '../../repositories/board_repository.dart';

class PopularSearchListController extends GetxController with StateMixin<List<Search>>{
  final BuildContext context;
  PopularSearchListController(this.context);

  final BoardRepository _repository = BoardRepository();

  final RxList<Search> _searchList = RxList<Search>([]);

  @override
  void onReady() {
    super.onReady();
    ever(_searchList, _boardListListener);
    getSearchList();
  }

  void _boardListListener(List<Search> searchList){
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

  Future getSearchList() async{
    _searchList.value = await _repository.getPopularSearchList(context);
  }
}