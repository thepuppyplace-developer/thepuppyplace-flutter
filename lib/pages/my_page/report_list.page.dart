import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/models/BoardReport.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_report_details.page.dart';
import 'package:thepuppyplace_flutter/repositories/board/board_repository.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/enums.dart';
import 'package:thepuppyplace_flutter/views/status/future_list_view.dart';

class ReportListPage extends StatefulWidget {
  static const String routeName = '/reportListPage';
  const ReportListPage({Key? key}) : super(key: key);

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {

  final RefreshController _refreshCtr = RefreshController(initialRefresh: true);

  List<BoardReport> _reportList = <BoardReport>[];

  FutureState _state = FutureState.loading;

  Future _getReportList() => BoardRepository.instance.getReportBoardList(isAdmin)
      .then((res) {
    print(res.bodyString);
    switch(res.statusCode){
      case 200:
        final List<BoardReport> reportList = List.from(res.body['data']).map((report) => BoardReport.fromJson(report)).toList();
        setState((){
          _reportList.addAll(reportList);
          _state = FutureState.success;
        });
        _refreshCtr.refreshCompleted(resetFooterState: true);
        break;
      case null:
        setState(() => _state = FutureState.network);
        _refreshCtr.refreshFailed();
        break;
      default:
        setState(() => _state = FutureState.error);
        _refreshCtr.refreshFailed();
    }
  })
      .catchError((error){
    setState(() => _state = FutureState.error);
    _refreshCtr.refreshFailed();
    throw Exception(error);
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: _buildAppBar(context),
    body: _buildBody(context),
  );

  AppBar _buildAppBar(BuildContext context) => AppBar(
    titleTextStyle: CustomTextStyle.appBarStyle(context),
    title: const Text('신고내역'),
  );

  Widget _buildBody(BuildContext context) => FutureListStateView<BoardReport>(
    padding: baseVerticalPadding(context),
    refreshCtr: _refreshCtr,
    children: _reportList,
    itemBuilder: (context, report) => _buildReportItem(context, report),
    onRefresh: _getReportList,
    spacing: mediaHeight(context, 0.01),
  );

  Widget _buildReportItem(BuildContext context, BoardReport report) => CupertinoButton(
    padding: EdgeInsets.zero,
    onPressed: () => Get.toNamed(BoardReportDetailsPage.routeName, arguments: report.id),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: CustomColors.hint, blurStyle: BlurStyle.outer, blurRadius: 1)
        ]
      ),
      margin: baseHorizontalPadding(context),
      padding: basePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_typeToString(report.type), style: CustomTextStyle.w600(context, color: CustomColors.main), overflow: TextOverflow.ellipsis),
          SizedBox(height: mediaHeight(context, 0.005)),
          Text(report.description, style: CustomTextStyle.w500(context))
        ],
      ),
    ),
  );

  String _typeToString(ReportType type) {
    switch(type){
      case ReportType.abuse: return '과도한 욕설 또는 음란물';
      case ReportType.deference: return '성격에 맞지 않는 게시물';
      case ReportType.illegality: return '불법 광고, 또는 도배 게시물';
      case ReportType.service: return '서비스 품질 저해 게시물';
      case ReportType.infringement: return '권리침해 게시물';
      case ReportType.others: return '기타';
    }
  }
}
