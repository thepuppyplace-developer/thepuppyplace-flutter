import 'package:get/get.dart';
import '../../models/BoardCategory.dart';
import '../../repositories/board/board_repository.dart';

class CategoryController extends GetxController with StateMixin<List<BoardCategory>>{
  final BoardRepository _repository = BoardRepository();

  final RxList<BoardCategory> _categoryList = RxList<BoardCategory>();

  @override
  void onReady() {
    super.onReady();
    ever(_categoryList, _categoryListListener);
  }

  void _categoryListListener(List<BoardCategory> categoryList){
    try{
      change(null, status: RxStatus.loading());
      if(categoryList.isNotEmpty){
        change(categoryList, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  // Future getCategories() async{
  //   if((await CATEGORY_LIST()).isNotEmpty){
  //     _categoryList.value = await CATEGORY_LIST();
  //   } else {
  //     _categoryList.value = await _repository.getBoardCategory();
  //   }
  // }
}