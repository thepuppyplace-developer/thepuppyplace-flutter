import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/Notice.dart';
import '../../repositories/notice/notice_repository.dart';

class NoticeListController extends GetxController with StateMixin<List<Notice>>{
  static NoticeListController get instance => Get.put(NoticeListController());

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
    change(null, status: RxStatus.loading());
    try{
      final Response res = await _repository.getNoticeList;
      switch(res.statusCode){
        case 200:
          _noticeList.addAll(List.from(res.body['data']).map((notice) => Notice.fromJson(notice)).toList());
      }
    } catch(error){
      throw Exception(error);
    }
  }

  Future get refreshNoticeList async{
    change(null, status: RxStatus.loading());
    try{
      final Response res = await _repository.getNoticeList;
      switch(res.statusCode){
        case 200:
          _noticeList.value = List.from(res.body['data']).map((notice) => Notice.fromJson(notice)).toList();
      }
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> insertNotice({
    required XFile? image,
    required String notice_title,
    required String notice_main_text,
  }) async{
    change(null, status: RxStatus.loading());
    try{
      final Response res = await _repository.insertNotice(image: image, notice_title: notice_title, notice_main_text: notice_main_text);
      switch(res.statusCode){
        case 201:
          refreshNoticeList;
      }
      return res;
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> updateNotice({
    required int notice_id,
    required String title,
    required String description,
  }) async{
    change(null, status: RxStatus.loading());
    try{
      final Response res = await _repository.updateNotice(notice_id: notice_id, title: title, description: description);
      switch(res.statusCode){
        case 200:
          refreshNoticeList;
      }
      return res;
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> deleteNotice(int notice_id) async{
    change(null, status: RxStatus.loading());
    try{
      final Response res = await _repository.deleteNotice(notice_id);
      switch(res.statusCode){
        case 200:
          _noticeList.removeWhere((notice) => notice.id == notice_id);
          update();
      }
      return res;
    } catch(error){
      throw Exception(error);
    }
  }

  Future<Response> sortTopNotice(int noticeId) => _repository.sortTopNotice(noticeId).then((res){
    switch(res.statusCode){
      case 200:
        refreshNoticeList;
    }
    return res;
  });

  Future<Response> sortBottomNotice(int noticeId) => _repository.sortBottomNotice(noticeId).then((res){
    switch(res.statusCode){
      case 200:
        refreshNoticeList;
    }
    return res;
  });
}