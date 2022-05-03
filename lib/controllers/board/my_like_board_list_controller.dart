import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/LikeBoard.dart';
import '../../repositories/board/board_repository.dart';
import '../user/user_controller.dart';

class MyLikeBoardListController extends GetxController with StateMixin<List<LikeBoard>> {
  final BuildContext context;
  MyLikeBoardListController(this.context);

  final _repository = BoardRepository();
  final RxList<LikeBoard> _boardList = RxList<LikeBoard>();

  @override
  void onReady() {
    super.onReady();
    ever(_boardList, _boardListListener);
    getBoardList;
  }

  void _boardListListener(List<LikeBoard> boardList){
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
    _boardList.value = await _repository.getLikeBoardList(context, UserController.to.user!.id);
  }
}