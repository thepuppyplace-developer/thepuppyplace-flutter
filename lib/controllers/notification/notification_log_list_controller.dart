import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/models/NotificationLog.dart';
import 'package:thepuppyplace_flutter/repositories/notification/notification_repository.dart';

class NotificationLogListController extends GetxController with StateMixin<List<NotificationLog>>{
  static NotificationLogListController get to => Get.put(NotificationLogListController());

  final _repo = NotificationRepository();

  final refreshController = RefreshController();

  final _logList = RxList<NotificationLog>();

  final RxInt _page = RxInt(0);

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
    _page.value++;
    try{
      final Response res = await _repo.getNotificationLogList(_page.value);
      switch(res.statusCode){
        case 200:
          _logList.addAll(List.from(res.body['data']).map((log) => NotificationLog.fromJson(log)).toList());
      }
    } catch(error){
      throw Exception(error);
    }
  }

  Future get refreshLogList async{
    _page.value = 0;
    change(null, status: RxStatus.loading());
    try{
      final Response res = await _repo.getNotificationLogList(_page.value);
      switch(res.statusCode){
        case 200:
          _logList.clear();
          _logList.addAll(List.from(res.body['data']).map((log) => NotificationLog.fromJson(log)).toList());
      }
    } catch(error){
      throw Exception(error);
    }
  }
}