import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/config/config.dart';
import 'package:thepuppyplace_flutter/controllers/consult/consult_list.controller.dart';
import 'package:thepuppyplace_flutter/controllers/user/user_controller.dart';
import 'package:thepuppyplace_flutter/pages/my_page/consult_details.page.dart';
import 'package:thepuppyplace_flutter/pages/my_page/insert_consult.page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/views/rx_status_view.dart';

import '../../models/Consult.dart';

class ConsultPage extends GetView<ConsultListController> {
  static const String routeName = '/consultPage';
  const ConsultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<ConsultListController>(
      init: ConsultListController(),
      builder: (ConsultListController controller) {
        return Scaffold(
          appBar: AppBar(),
          body: controller.obx((consultList){
            final List<Consult> answerList = consultList!.where((consult) => consult.answer != null).toList();
            final List<Consult> noAnswerList = consultList.where((consult) => consult.answer == null).toList();
            return SingleChildScrollView(
              padding: basePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(noAnswerList.isNotEmpty) Container(
                      margin: EdgeInsets.only(bottom: mediaWidth(context, 0.033)),
                      child: Text('${Config.ADMIN_UID == UserController.user?.uid ? '' : '내 '}문의 대기', style: CustomTextStyle.w500(context, scale: 0.025))),
                  for(Consult consult in noAnswerList) _item(context, consult),
                  if(answerList.isNotEmpty) Container(
                      margin: EdgeInsets.only(bottom: mediaWidth(context, 0.033)),
                      child: Text('${Config.ADMIN_UID == UserController.user?.uid ? '' : '내 '}문의 완료', style: CustomTextStyle.w500(context, scale: 0.025))),
                  for(Consult consult in answerList) _item(context, consult)
                ],
              ),
            );
          },
              onEmpty: const EmptyView(message: '문의 내용이 없습니다'),
              onError: (error) => ErrorView(error),
              onLoading: const LoadingView(message: '문의 내역을 불러오는 중입니다...')
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: CustomColors.main,
            child: const Icon(Icons.add),
            onPressed: () => Get.toNamed(InsertConsultPage.routeName),
          ),
        );
      }
  );

  Widget _item(BuildContext context, Consult consult) => GestureDetector(
    onTap: () => Get.toNamed(ConsultDetailsPage.routeName, arguments: RxInt(consult.consultId)),
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: mediaWidth(context, 0.033)),
      padding: basePadding(context),
      foregroundDecoration: consult.answer == null ? null : BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.3),
          boxShadow: const [
            BoxShadow(color: CustomColors.emptySide, blurStyle: BlurStyle.outer, blurRadius: 5)
          ]
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: CustomColors.emptySide, blurStyle: BlurStyle.outer, blurRadius: 5)
          ]
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(consult.title, style: CustomTextStyle.w600(context, scale: 0.018)),
                Container(
                    margin: baseVerticalPadding(context) / 2,
                    child: Text(consult.description, style: CustomTextStyle.w500(context), maxLines: 1, overflow: TextOverflow.ellipsis)),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: beforeDate(consult.createdAt),
                          style: CustomTextStyle.w500(context, scale: 0.012, color: CustomColors.hint)
                      ),
                      if(consult.answer != null) TextSpan(
                        text: '   답변 완료',
                        style: CustomTextStyle.w600(context, scale: 0.012, color: CustomColors.main)
                      )
                    ]
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          if(consult.photoList.isNotEmpty) Container(
            height: mediaHeight(context, 0.1),
            width: mediaHeight(context, 0.1),
            decoration: BoxDecoration(
              color: CustomColors.emptySide,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(consult.photoList.first)
              )
            ),
          )
        ],
      ),
    ),
  );
}
