import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/board/board_list_controller.dart';
import 'package:thepuppyplace_flutter/controllers/board/report_board_list.controller.dart';
import 'package:thepuppyplace_flutter/models/BoardItem.dart';
import 'package:thepuppyplace_flutter/models/BoardReportDetails.dart';
import 'package:thepuppyplace_flutter/models/UserNicknameAndPhotoURL.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_details_page.dart';
import 'package:thepuppyplace_flutter/repositories/board/board_repository.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/enums.dart';
import 'package:thepuppyplace_flutter/views/status/future_state_builder.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_button.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_icon_button.dart';
import 'package:thepuppyplace_flutter/widgets/dialogs/custom_dialog.dart';
import 'package:thepuppyplace_flutter/widgets/images/custom_cached_network.image.dart';

class BoardReportDetailsPage extends StatefulWidget {
  static const String routeName = '/boardReportDetailsPage';
  const BoardReportDetailsPage({Key? key}) : super(key: key);

  @override
  State<BoardReportDetailsPage> createState() => _BoardReportDetailsPageState();
}

class _BoardReportDetailsPageState extends State<BoardReportDetailsPage> {

  final int _reportId = Get.arguments;

  FutureState _state = FutureState.loading;

  BoardReportDetails? _report;

  Future _getBoardReport() async{
    setState(() => _state = FutureState.loading);
    return BoardRepository.instance.getReportBoard(_reportId)
        .then((res) {
      switch(res.statusCode){
        case 200:
          final BoardReportDetails report = BoardReportDetails.fromJson(res.body['data']);
          setState(() {
            _report = report;
            _state = FutureState.success;
          });
          break;
        case 204:
          setState(() => _state = FutureState.empty);
          break;
        case null:
          setState(() => _state = FutureState.network);
          break;
        default:
          setState(() => _state = FutureState.error);
      }
    })
        .catchError((error){
      setState(() => _state = FutureState.error);
      throw Exception(error);
    });
  }

  Future _deleteReport(BuildContext context, int reportId, {bool? isBack}) async{
    return ReportBoardListController.instance.deleteReport(reportId)
        .then((res){
      switch(res.statusCode){
        case 200:
          if(isBack == true) Navigator.of(context).pop();
          return showSnackBar(context, '신고 내역이 삭제되었습니다.');
        case null:
          return network_check_message(context);
        default:
          return unknown_message(context);
      }
    })
        .catchError((error){
      unknown_message(context);
      throw Exception(error);
    });
  }

  Future _deleteBoard(BuildContext _, int boardId) async{
    if(isAdmin) {
      return BoardRepository.instance.deleteBoardFromReport(boardId).then((res) {
        switch(res.statusCode){
          case 200:
            Navigator.of(context).pop();
            return showSnackBar(context, '게시글이 삭제되었습니다.');
          case null:
            return network_check_message(context);
          default:
            return unknown_message(context);
        }
      }).catchError((error){
        unknown_message(context);
        throw Exception(error);
      });
    } else {
      return showSnackBar(context, '권한이 없습니다.');
    }
  }

  void _showDialog(int reportId) => showDialog(context: context, builder: (_) => CustomDialog(title: '신고내역을 삭제하시겠습니까?', onTap: () {
    Navigator.of(_).pop();
    return showIndicator(_deleteReport(context, reportId, isBack: true));
  }));

  void _showBoardDeleteDialog(int boardId) => showDialog(context: context, builder: (_) => CustomDialog(title: '게시글을 삭제하시겠습니까?', onTap: () {
    Navigator.of(_).pop();
    return showIndicator(_deleteBoard(context, boardId));
  }));

  @override
  void initState() {
    super.initState();
    _getBoardReport();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: _buildAppBar(context),
    body: _buildBody(context),
    bottomNavigationBar: !isAdmin || _report?.boardId == null ? null : Container(
        color: CustomColors.main,
        child: SafeArea(
            child: CustomButton(
                title: '게시글 삭제',
                onPressed: () => _showBoardDeleteDialog(_report!.boardId)
            )
        )
    ),
  );

  AppBar _buildAppBar(BuildContext context) => AppBar(
    actions: [
      if(_report?.id != null) CustomIconButton(icon: Icons.delete_forever, onTap: () => _showDialog(_report!.id))
    ],
  );

  Widget _buildBody(BuildContext context) => FutureStateBuilder<BoardReportDetails>(state: _state, object: _report, builder: (context, state, report) {
    return SingleChildScrollView(
      padding: basePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUser(report!.reportMember),
          _buildBoard(report.boardId, report.targetMember, report.board),
          Text(_typeToString(report.type), style: CustomTextStyle.w600(context, color: CustomColors.main, scale: 0.02)),
          Text(report.description, style: CustomTextStyle.w500(context, height: 1.5)),
          Container(
              margin: baseVerticalPadding(context),
              child: Text(beforeDate(report.createdAt), style: CustomTextStyle.w500(context, scale: 0.012, color: CustomColors.hint)))
        ],
      ),
    );
  });

  Widget _buildUser(UserNicknameAndPhotoURL user) => Row(
    children: [
      CustomCachedNetworkImage(
        user.photo_url,
        height: mediaHeight(context, 0.05),
        width: mediaHeight(context, 0.05),
        shape: BoxShape.circle,
        margin: EdgeInsets.only(right: mediaWidth(context, 0.03)),
      ),
      Text(user.nickname, style: CustomTextStyle.w600(context))
    ],
  );

  Widget _buildBoard(int boardId, UserNicknameAndPhotoURL user, BoardItem board) => Container(
    margin: EdgeInsets.only(top: mediaHeight(context, 0.02)),
    child: CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => Get.toNamed(BoardDetailsPage.routeName, arguments: RxInt(boardId)),
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.only(bottom: mediaHeight(context, 0.03)),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: CustomColors.hint, blurStyle: BlurStyle.outer, blurRadius: 1)
            ]
        ),
        child: Column(
          children: [
            Container(
                margin: baseHorizontalPadding(context).add(baseVerticalPadding(context) / 2),
                child: _buildUser(user)),
            if(board.photoList.isNotEmpty) AspectRatio(
              aspectRatio: 3/1,
              child: CustomCachedNetworkImage(
                  board.photoList.first
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: basePadding(context),
                child: Text(board.title, style: CustomTextStyle.w500(context))
            )
          ],
        ),
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
