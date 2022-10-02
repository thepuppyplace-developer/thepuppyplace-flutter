import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/models/BoardReport.dart';
import 'package:thepuppyplace_flutter/repositories/board/board_repository.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/error_messages.dart';

class ReportBoardListController extends GetxController with StateMixin<List<BoardReport>>{

  static ReportBoardListController get instance => Get.put(ReportBoardListController());

  final _repo = BoardRepository();

  final RxList<BoardReport> _reportList = RxList([]);

  final RefreshController refreshCtr = RefreshController(initialRefresh: true);

  @override
  void onReady() {
    super.onReady();
    ever(_reportList, _reportListListener);
    getReportList(isRefresh: true);
  }

  void _reportListListener(List<BoardReport> reportList){
    change(null, status: RxStatus.loading());
    try{
      if(reportList.isNotEmpty){
        change(reportList, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future<Response> getReportList({bool? isRefresh}) async{
    return _repo.getReportBoardList(isAdmin).then((res){
      print(res.bodyString);
      switch(res.statusCode){
        case 200:
          final List<BoardReport> reportList = List.from(res.body['data']).map((report) => BoardReport.fromJson(report)).toList();
          if(isRefresh == true){
            _reportList.clear();
            refreshCtr.refreshCompleted(resetFooterState: true);
            _reportList.addAll(reportList);
            break;
          } else {
            refreshCtr.loadComplete();
            _reportList.addAll(reportList);
          }
          break;
        case 204:
          if(isRefresh == true) {
            refreshCtr.refreshCompleted();
            change(null, status: RxStatus.empty());
          } else {
            refreshCtr.loadNoData();
          }
          break;
        case null:
          if(isRefresh == true){
            refreshCtr.refreshFailed();
          } else {
            refreshCtr.loadFailed();
          }
          change(null, status: RxStatus.error(ErrorMessages.network_please));
          break;
        default:
          if(isRefresh == true){
            refreshCtr.refreshFailed();
          } else {
            refreshCtr.loadFailed();
          }
      }
      return res;
    }).catchError((error){
      change(null, status: RxStatus.error(error.toString()));
      throw Exception(error);
    });
  }

  Future<Response> deleteReport(int reportId) => _repo.deleteReportBoard(reportId)
      .then((res) {
    switch(res.statusCode){
      case 200:
        _reportList.removeWhere((report) => report.id == reportId);
    }
    return res;
  })
      .catchError((error){
    throw Exception(error);
  });
}