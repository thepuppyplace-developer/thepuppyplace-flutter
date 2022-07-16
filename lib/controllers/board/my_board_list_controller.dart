import 'package:get/get.dart';

import '../../models/Board.dart';
import '../../repositories/board/board_repository.dart';
import '../user/user_controller.dart';

class MyBoardListController extends GetxController with StateMixin<List<Board>>{
  final _repository = BoardRepository();

  final _boardList = RxList<Board>();

  final page = RxInt(1);

  @override
  void onReady() {
    super.onReady();
    ever(_boardList, _boardListListener);
    getBoardList;
  }

  void _boardListListener(List<Board> boardList){
    try{
      change(null, status: RxStatus.loading());
      if(boardList.isNotEmpty){
        change(boardList, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future get getBoardList async{
    try{
      _boardList.value = await _repository.getBoardList(page: page.value, query: '${UserController.user?.id}', queryType: 'u');
    } catch(error){
      change(null, status: RxStatus.error('인터넷 연결을 확인해주새요.'));
      throw Exception(error);
    }
  }
}