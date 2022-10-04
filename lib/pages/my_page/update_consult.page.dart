import 'package:thepuppyplace_flutter/util/custom_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/controllers/consult/consult_list.controller.dart';
import 'package:thepuppyplace_flutter/models/Consult.dart';
import 'package:thepuppyplace_flutter/pages/my_page/consult_details.page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_text_button.dart';
import 'package:thepuppyplace_flutter/widgets/images/custom_cached_network.image.dart';
import 'package:thepuppyplace_flutter/widgets/text_fields/custom_text_field.dart';

import '../../views/photo_view/photo_list_view.dart';

class UpdateConsultPage extends StatefulWidget {
  static const String routeName = '/updateConsultPage';

  const UpdateConsultPage({Key? key}) : super(key: key);

  @override
  State<UpdateConsultPage> createState() => _UpdateConsultPageState();
}

class _UpdateConsultPageState extends State<UpdateConsultPage> {
  String _title = '';
  String _description = '';

  final Consult consult = Get.arguments;

  final TextEditingController _titleCtr = TextEditingController();
  final TextEditingController _descriptionCtr = TextEditingController();

  @override
  void initState() {
    super.initState();
    _title = consult.title;
    _description = consult.description;
    _titleCtr.text = consult.title;
    _descriptionCtr.text = consult.description;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => unFocus(context),
    child: Scaffold(
      appBar: AppBar(
        titleTextStyle: CustomTextStyle.appBarStyle(context),
        title: const Text('수정하기'),
        actions: [
          CustomTextButton('수정', !_check ? null : () => CustomIndicator.instance.show(context, _updateConsult), color: _check ? null : CustomColors.hint)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _titleCtr,
              margin: basePadding(context),
              autofocus: true,
              textFieldType: TextFieldType.underline,
              hintText: '제목',
              onChanged: (title) => setState(() => _title = title),
            ),
            CustomTextField(
              controller: _descriptionCtr,
              margin: baseHorizontalPadding(context),
              autofocus: true,
              textFieldType: TextFieldType.underline,
              hintText: '내용',
              onChanged: (description) => setState(() => _description = description),
              minLines: 10,
              maxLines: null,
            ),
            Container(
              height: mediaHeight(context, 0.1),
              margin: basePadding(context),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if(consult.photoList.isNotEmpty) for(int index = 0; index < consult.photoList.length; index++) Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.only(right: mediaWidth(context, 0.033)),
                        child: CustomCachedNetworkImage(
                          consult.photoList[index],
                          borderRadius: BorderRadius.circular(5),
                          height: mediaHeight(context, 0.1),
                          width: mediaHeight(context, 0.1),
                        ),
                        onPressed: (){
                          Get.to(() => PhotoListView(consult.photoList, PhotoListType.cached, currentIndex: index), fullscreenDialog: true);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Future get _updateConsult async{
    try{
      final Response res = await ConsultListController.instance.updateConsult(
          consultId: consult.consultId,
          title: _title,
          description: _description
      );
      switch(res.statusCode){
        case 200:
          Get.until((route) => route.settings.name == ConsultDetailsPage.routeName);
          return showSnackBar(context, '문의가 수정되었습니다.');
        case null:
          return network_check_message(context);
      }
    } catch(error){
      await unknown_message(context);
      throw Exception(error);
    }
  }

  bool get _check{
    if(_title.isNotEmpty && _description.isNotEmpty){
      return true;
    } else {
      return false;
    }
  }
}
