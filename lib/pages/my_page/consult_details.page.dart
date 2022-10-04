import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/consult/consult_details_controller.dart';
import 'package:thepuppyplace_flutter/controllers/consult/consult_list.controller.dart';
import 'package:thepuppyplace_flutter/pages/my_page/update_consult.page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/views/photo_view/photo_list_view.dart';
import 'package:thepuppyplace_flutter/views/status/rx_status_view.dart';
import 'package:thepuppyplace_flutter/widgets/images/custom_cached_network.image.dart';
import '../../widgets/buttons/custom_text_button.dart';
import '../../widgets/dialogs/custom_dialog.dart';
import '../../widgets/text_fields/custom_text_field.dart';
import 'package:thepuppyplace_flutter/util/custom_indicator.dart';

class ConsultDetailsPage extends StatefulWidget {
  static const String routeName = '/consultDetailsPage';
  ConsultDetailsPage({Key? key}) : super(key: key);

  @override
  State<ConsultDetailsPage> createState() => _ConsultDetailsPageState();
}

class _ConsultDetailsPageState extends State<ConsultDetailsPage> {
  final RxInt _consultId = Get.arguments;

  final TextEditingController _answerCtr = TextEditingController();
  String _answer = '';

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => unFocus(context),
    child: GetBuilder<ConsultDetailsController>(
        init: ConsultDetailsController(_consultId),
        builder: (ConsultDetailsController controller) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                CupertinoButton(
                  child: const Icon(Icons.more_vert, color: CustomColors.hint),
                  onPressed: () => showDialog(context: context, builder: (context) => CupertinoAlertDialog(
                    title: const Text('문의 관리'),
                    content: Container(
                      margin: EdgeInsets.only(top: mediaHeight(context, 0.02)),
                      child: controller.obx((consult) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextButton('수정하기', (){
                            Get.back();
                            Get.toNamed(UpdateConsultPage.routeName, arguments: consult!);
                          },
                            color: Colors.black,
                          ),
                          CustomTextButton('삭제하기', (){
                            Get.back();
                            showDialog(context: context, builder: (context) => CustomDialog(
                                title: '정말로 문의를 삭제하시겠습니까?',
                                onTap: () => CustomIndicator.instance.show(context, _deleteConsult(context, _consultId.value))));
                          },
                            color: Colors.black,
                          ),
                          CustomTextButton('취소', () => Get.back(),
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                          ),
                        ],
                      )),
                    ),
                  )),
                )
              ],
            ),
            body: controller.obx((consult) => Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: basePadding(context),
                            child: Text(consult!.title, style: CustomTextStyle.w600(context, scale: 0.02))),
                        Container(
                            margin: baseHorizontalPadding(context).copyWith(bottom: mediaWidth(context, 0.033)),
                            child: Linkify(
                                text: consult.description,
                                style: CustomTextStyle.w500(context),
                              linkStyle: CustomTextStyle.w500(context, color: CustomColors.main, decoration: TextDecoration.underline),
                              onOpen: (url) => openURL(url: url.url),
                            )
                        ),
                        if(consult.photoList.isNotEmpty) for(int index = 0; index < consult.photoList.length; index++) GestureDetector(
                          onTap: () => Get.to(PhotoListView(consult.photoList, PhotoListType.cached, currentIndex: index), fullscreenDialog: true),
                          child: AspectRatio(
                            aspectRatio: 1/1,
                            child: CustomCachedNetworkImage(
                              consult.photoList[index],
                            ),
                          ),
                        ),
                        const Divider(),
                        Container(
                            margin: basePadding(context),
                            child: Text('답변', style: CustomTextStyle.w600(context))),
                        Container(
                            margin: baseHorizontalPadding(context),
                            child: Text(consult.answer ?? '아직 답변이 등록되지 않았습니다.', style: CustomTextStyle.w500(context, color: consult.answer != null ? null : CustomColors.hint)))
                      ],
                    ),
                  ),
                ),
                if(isAdmin)
                  SafeArea(
                    child: Container(
                      padding: basePadding(context).subtract(EdgeInsets.only(bottom: mediaWidth(context, 0.033))),
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: CustomColors.emptySide))
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _answerCtr,
                              margin: EdgeInsets.only(right: mediaWidth(context, 0.033)),
                              hintText: '답변',
                              textFieldType: TextFieldType.outline,
                              onFieldSubmitted: (answer) => CustomIndicator.instance.show(context, _answerConsult(controller)),
                              onChanged: (answer) => setState(() => _answer = answer),
                            ),
                          ),
                          CustomTextButton('작성', () => CustomIndicator.instance.show(context, _answerConsult(controller)))
                        ],
                      ),
                    ),
                  ),
              ],
            ),
                onLoading: const LoadingView(message: '문의 내용을 불러오는 중입니다...'),
                onError: (error) => ErrorView(error),
                onEmpty: const EmptyView(message: '문의가 삭제되었습니다.')
            ),
          );
        }
    ),
  );

  Future _deleteConsult(BuildContext context, int consultId) async{
    try{
      final Response res = await ConsultListController.instance.deleteConsult(consultId);
      switch(res.statusCode){
        case 200:
          Get.until((route) => route.settings.name == ConsultDetailsPage.routeName);
          return showSnackBar(context, '문의가 삭제되었습니다.');
        case null:
          return network_check_message(context);
      }
    } catch(error){
      await unknown_message(context);
      throw Exception(error);
    }
  }

  Future _answerConsult(ConsultDetailsController controller) async{
    try {
      final Response res = await controller.answerConsult(_consultId.value, _answer.trim());
      switch(res.statusCode){
        case 200:
          setState((){
            _answer = '';
            _answerCtr.clear();
          });
          ConsultListController.instance.addAnswer(_consultId.value, _answer);
          return showSnackBar(context, '상담이 등록되었습니다.');
        case null:
          return network_check_message(context);
      }
    } catch(error){
      await unknown_message(context);
      throw Exception(error);
    }
  }
}
