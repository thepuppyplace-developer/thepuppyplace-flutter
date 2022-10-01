import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/repositories/board/board_repository.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/enums.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_button.dart';
import 'package:thepuppyplace_flutter/widgets/text_fields/custom_text_field.dart';

class BoardReportPage extends StatefulWidget {
  static const routeName = '/boardReportPage';
  const BoardReportPage({Key? key}) : super(key: key);

  @override
  State<BoardReportPage> createState() => _BoardReportPageState();
}

class _BoardReportPageState extends State<BoardReportPage> {

  int board_id = Get.arguments;

  String _description = '';

  ReportType? _type;

  Future _reportBoard() => BoardRepository.instance.reportBoard(board_id: board_id, report_type: _typeToInt(_type), report_body: _description.trim()).then((res) {
    switch(res.statusCode){
      case 200:
        Navigator.pop(context);
        return showSnackBar(context, '신고가 성공적으로 접수되었습니다.');
      case null:
        return network_check_message(context);
      default:
        return unknown_message(context);
    }
  }).catchError((error){
    unknown_message(context);
    throw Exception(error);
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => unFocus(context),
    child: Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomButton(),
    ),
  );

  AppBar _buildAppBar() => AppBar(
    titleTextStyle: CustomTextStyle.appBarStyle(context),
    title: const Text('신고하기'),
  );

  Widget _buildBody() => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategorySelector(),
        const Divider(),
        _buildDescField(),
      ],
    ),
  );

  Widget _buildCategorySelector() {
    Color color = CustomColors.hint;

    return PopupMenuButton<ReportType>(
        onSelected: (type) => setState(() => _type = type),
        position: PopupMenuPosition.under,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(5)
          ),
          margin: basePadding(context),
          padding: basePadding(context),
          child: Row(
            children: [
              Expanded(child: Text(_typeToString(_type))),
              Icon(Icons.arrow_drop_down, color: color)
            ],
          ),
        ),
        itemBuilder: (BuildContext context) => ReportType.values.map((type) {
          return PopupMenuItem(
            value: type,
            child: Text(_typeToString(type), style: CustomTextStyle.w500(context)),
          );
        }).toList()
    );
  }

  Widget _buildDescField() {
    return CustomTextField(
      textStyle: CustomTextStyle.w500(context, height: 1.5),
      margin: baseHorizontalPadding(context),
      autofocus: true,
      textFieldType: TextFieldType.underline,
      hintText: '내용',
      onChanged: (description) => setState(() => _description = description),
      minLines: 10,
      maxLines: null,
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: CustomButton(
        margin: basePadding(context),
        title: '제출',
        onPressed: () => showIndicator(_reportBoard()),
      ),
    );
  }

  String _typeToString(ReportType? type) {
    switch(type){
      case ReportType.abuse: return '과도한 욕설 또는 음란물';
      case ReportType.deference: return '성격에 맞지 않는 게시물';
      case ReportType.illegality: return '불법 광고, 또는 도배 게시물';
      case ReportType.service: return '서비스 품질 저해 게시물';
      case ReportType.infringement: return '권리침해 게시물';
      case ReportType.others: return '기타';
      case null: return '신고 종류를 선택해주세요.';
    }
  }

  int _typeToInt(ReportType? type) {
    switch(type){
      case ReportType.abuse: return 1;
      case ReportType.deference: return 2;
      case ReportType.illegality: return 3;
      case ReportType.service: return 4;
      case ReportType.infringement: return 5;
      default: return 6;
    }
  }
}
