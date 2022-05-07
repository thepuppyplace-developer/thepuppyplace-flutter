import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/repositories/search/search_repository.dart';

import '../../models/Search.dart';

class RecommendSearchListController extends GetxController with StateMixin<List<Search>>{
  final BuildContext context;
  RecommendSearchListController(this.context);

  final SearchRepository _repo = SearchRepository();

  final RxList<Search> _searchList = RxList<Search>([]);

  @override
  void onReady() {
    super.onReady();
    ever(_searchList, _searchListListener);
    getSearchList('');
  }

  void _searchListListener(List<Search> searchList){
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

  Future getSearchList(String query) async{
    _searchList.value = await _repo.getRecommendSearchList(context, query);
  }
}