import 'package:get/get.dart';
import '../../.config.dart';
import '../../models/Board.dart';

class CategoryRepository extends GetConnect with Config{
  Future<List<Board>> findCategoryBoard(String category) async{
    Response res = await get('$API_URL/board/$category');

    switch(res.statusCode){
      case 200:
        return List.from(res.body['data']).map((board) => Board.fromJson(board)).toList();
      case 500:
        return [];
      default:
        return [];
    }
  }
}