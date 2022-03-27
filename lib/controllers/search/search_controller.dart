import 'package:get/get.dart';

import '../../models/Search.dart';
import 'search_repository.dart';

class SearchController extends GetxController with StateMixin<List<Search>>{
  final SearchRepository _repository = SearchRepository();

  final RxList<Search> _searchList = RxList<Search>([]);

  @override
  void onReady() {
    super.onReady();
    ever(_searchList, _searchListListener);
    _findAllSearch();
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

  Future _findAllSearch() async{
    _searchList.value = await _repository.findAllSearch();
  }
}