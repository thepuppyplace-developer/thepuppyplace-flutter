import 'package:get/get.dart';

import '../../models/Board.dart';

class CategoryController extends GetxController with StateMixin<List<Board>>{
  final String category;
  CategoryController(this.category);

  final RxList<Board> _boardList = RxList(<Board>[]);

  @override
  void onReady() {
    super.onReady();
    ever(_boardList, _boardListListener);
  }

  void _boardListListener(List<Board> boardList){
    try{
      change(null, status: RxStatus.loading());
      if(boardList.isNotEmpty){
        change(boardList, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch (error) {
      change(null, status: RxStatus.error(error.toString()));
    }
  }
}