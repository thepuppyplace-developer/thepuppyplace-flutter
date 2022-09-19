import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/repositories/search/search_repository.dart';
import '../../models/Search.dart';
import '../../repositories/board/board_repository.dart';

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

  Future<Response> onSearchDelete(Search search) => SearchRepository.instance.deleteSearch(search.id).then((res) {
    switch(res.statusCode){
      case 200:
        if(_searchList.contains(search)) _searchList.remove(search);
        getSearchList();
        update();
        break;
    }
    return res;
  });
}