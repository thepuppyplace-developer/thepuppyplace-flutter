import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/Notice.dart';
import '../../repositories/notice_repository.dart';

class NoticeListController extends GetxController with StateMixin<List<Notice>>{
  final BuildContext context;
  NoticeListController(this.context);

  final NoticeRepository _repository = NoticeRepository();
  final RxList<Notice> _noticeList = RxList<Notice>();

  @override
  void onReady() {
    super.onReady();
    ever(_noticeList, _boardListListener);
    getNoticeList;
  }

  void _boardListListener(List<Notice> noticeList){
    try{
      change(null, status: RxStatus.loading());
      if(noticeList.isNotEmpty){
        change(noticeList, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future get getNoticeList async{
    _noticeList.addAll(await _repository.getNoticeList(context));
  }
}