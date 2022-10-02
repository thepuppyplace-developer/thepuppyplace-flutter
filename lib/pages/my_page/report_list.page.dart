import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thepuppyplace_flutter/controllers/board/report_board_list.controller.dart';
import 'package:thepuppyplace_flutter/models/BoardReport.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_report_details.page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/enums.dart';
import 'package:thepuppyplace_flutter/views/status/rx_status_view.dart';
import 'package:thepuppyplace_flutter/widgets/loadings/refresh_contents.dart';

class ReportListPage extends StatefulWidget {
  static const String routeName = '/reportListPage';
  const ReportListPage({Key? key}) : super(key: key);

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {

  @override
  Widget build(BuildContext context) => GetBuilder<ReportBoardListController>(
    init: ReportBoardListController(),
    builder: (controller) {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: controller.obx((reportList) => _buildBody(context, controller, reportList!),
          onLoading: const LoadingView(message: '신고 내역을 불러오는 중입니다.'),
          onError: (error) => ErrorView(error),
          onEmpty: const EmptyView(message: '신고 내역이 없습니다.')
        )
      );
    }
  );

  AppBar _buildAppBar(BuildContext context) => AppBar(
    titleTextStyle: CustomTextStyle.appBarStyle(context),
    title: const Text('신고내역'),
  );

  Widget _buildBody(BuildContext context,ReportBoardListController controller, List<BoardReport> reportList) => SmartRefresher(
    header: CustomHeader(builder: (context, status) => RefreshContents(status)),
    footer: CustomFooter(builder: (context, status) => LoadContents(status)),
    onRefresh: () => controller.getReportList(isRefresh: true),
    controller: controller.refreshCtr,
    child: ListView.separated(
      padding: baseVerticalPadding(context),
      separatorBuilder: (context, index) => SizedBox(height: mediaHeight(context, 0.02)),
      itemCount: reportList.length,
      itemBuilder: (context, index) => _buildReportItem(context, reportList[index]),
    ),
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
