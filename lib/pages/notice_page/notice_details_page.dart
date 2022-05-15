import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/pages/notice_page/notice_update_page.dart';

import '../../config/config.dart';
import '../../controllers/notice/notice_controller.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/Notice.dart';
import '../../util/common.dart';
import '../../widgets/buttons/custom_icon_button.dart';
import '../../widgets/dialogs/custom_dialog.dart';

class NoticeDetailsPage extends StatelessWidget {
  final Notice notice;

  const NoticeDetailsPage(this.notice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoticeController>(
      init: NoticeController(notice.id, context),
      builder: (NoticeController controller) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, inner) => [
              SliverAppBar(
                snap: true,
                floating: true,
                pinned: true,
                elevation: 0.5,
                title: Text('공지사항', style: CustomTextStyle.w600(context, scale: 0.02)),
                  actions: UserController.user!.email != Config.ADMIN_EMAIL ? null : [CustomIconButton(
                    icon: Icons.more_vert,
                    onTap: (){
                      showCupertinoModalPopup(context: context, builder: (context) => CupertinoActionSheet(
                        title: Text('관리자 권한', style: CustomTextStyle.w500(context)),
                        actions: [
                          CupertinoActionSheetAction(
                            child: Text('게시글 수정', style: CustomTextStyle.w500(context, scale: 0.02)),
                            onPressed: (){
                              Get.back();
                              Get.to(() => NoticeUpdatePage(notice));
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: Text('게시글 삭제', style: CustomTextStyle.w500(context, scale: 0.02)),
                            onPressed: (){
                              Get.back();
                              showCupertinoDialog(context: context, builder: (context) => CustomDialog(
                                title: '공지사항을 삭제하시겠습니까?',
                                content: '삭제한 공지사항은 복구되지 않습니다.\n삭제하시겠습니까?',
                                onTap: (){
                                  controller.deleteNotice;
                                },
                              ));
                            },
                          )
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text('취소', style: CustomTextStyle.w500(context, scale: 0.02, color: Colors.red)),
                          onPressed: (){
                            Get.back();
                          },
                        ),
                      ));
                    },
                  )]
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: mediaHeight(context, 0.01)),
                        padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.03), vertical: mediaHeight(context, 0.005)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(mediaHeight(context, 1)),
                            color: CustomColors.mainEmpty
                        ),
                        child: Text('공지사항', style: CustomTextStyle.w500(context, scale: 0.015, color: CustomColors.main)),
                      ),
                      Text(notice.notice_title, style: CustomTextStyle.w600(context, scale: 0.02)),
                      Container(
                          margin: EdgeInsets.only(top: mediaHeight(context, 0.02)),
                          child: Text(beforeDate(notice.createdAt), style: CustomTextStyle.w500(context, color: CustomColors.hint))
                      )
                    ],
                  ),
                ),
              )
            ],
            body: Container(
              padding: EdgeInsets.all(mediaWidth(context, 0.033)),
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: CustomColors.emptySide, blurStyle: BlurStyle.outer, blurRadius: 10)
                  ]
              ),
              child: CustomScrollView(
                slivers: [
                  if(notice.image_url != null) SliverToBoxAdapter(
                    child: AspectRatio(
                      aspectRatio: 3/2,
                      child: Container(
                        margin: EdgeInsets.only(bottom: mediaHeight(context, 0.02)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(notice.image_url!)
                          )
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Text(notice.notice_main_text, style: CustomTextStyle.w500(context)),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
