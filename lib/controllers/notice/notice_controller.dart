import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/notice/notice_list_controller.dart';

import '../../models/Notice.dart';
import '../../pages/notice_page/notice_list_page.dart';
import '../../repositories/notice/notice_repository.dart';

class NoticeController extends GetxController with StateMixin<Notice>{
  final int? notice_id;
  final BuildContext context;
  NoticeController(this.notice_id, this.context);

  final NoticeRepository _repository = NoticeRepository();
  final Rxn<Notice> _notice = Rxn<Notice>();

  @override
  void onReady() {
    super.onReady();
    ever(_notice, _noticeListener);
  }

  void _noticeListener(Notice? notice){
    try{
      change(null, status: RxStatus.loading());
      if(notice != null){
        change(notice, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }
}