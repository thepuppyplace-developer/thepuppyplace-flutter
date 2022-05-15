import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/terms_list_controller.dart';
import 'package:thepuppyplace_flutter/pages/my_page/terms_details_page.dart';
import 'package:thepuppyplace_flutter/views/sliver_rx_status_views.dart';

import '../../models/Term.dart';
import '../../util/common.dart';
import '../../widgets/buttons/custom_text_button.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TermsListController>(
      init: TermsListController(context),
      builder: (TermsListController controller) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, inner) => [
              SliverAppBar(
                snap: true,
                floating: true,
                pinned: true,
                elevation: 0.5,
                title: Text('서비스 이용약관', style: CustomTextStyle.w600(context, scale: 0.02)),
              )
            ],
            body: CustomScrollView(
              slivers: [
                controller.obx((termsList) => SliverList(
                  delegate: SliverChildBuilderDelegate((context, index){
                    final Term term = termsList![index];
                    return CupertinoButton(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(term.term_title, style: CustomTextStyle.w500(context)),
                            ),
                            Icon(Icons.arrow_forward_ios, size: mediaHeight(context, 0.025), color: CustomColors.hint)
                          ],
                        ),
                        onPressed: (){
                          Get.to(() => TermsDetailsPage(term));
                        }
                    );
                  },
                    childCount: termsList!.length
                  ),
                ),
                  onEmpty: const SliverEmpty('약관 동의 내용이 없습니다.'),
                  onError: (error) => SliverEmpty(error ?? 'error'),
                  onLoading: const SliverLoading(message: '약관 동의를 불러오는 중입니다.')
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
