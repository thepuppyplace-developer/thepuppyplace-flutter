import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/models/NotificationLog.dart';
import 'package:thepuppyplace_flutter/repositories/notification/notification_repository.dart';

class NotificationLogListController extends GetxController with StateMixin<List<NotificationLog>>{
  final BuildContext context;
  NotificationLogListController(this.context);

  final _repo = NotificationRepository();

  final refreshController = RefreshController();

  final _logList = RxList<NotificationLog>();
  List<NotificationLog> get logList => _logList;

  @override
  void onReady() {
    super.onReady();
    ever(_logList, _logListListener);
    getLogList;
  }

  void _logListListener(List<NotificationLog> logList){
    try{
      change(null, status: RxStatus.loading());
      if(logList.isNotEmpty){
        change(logList, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future get getLogList async{
    _logList.value = await _repo.getNotificationLogList(context);
  }

  Future get refreshLogList async{
    _logList.value = await _repo.getNotificationLogList(context);
  }
}