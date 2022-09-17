import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thepuppyplace_flutter/controllers/consult/consult_list.controller.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_text_button.dart';
import 'package:thepuppyplace_flutter/widgets/text_fields/custom_text_field.dart';

import '../../views/photo_view/photo_list_view.dart';

class InsertConsultPage extends StatefulWidget {
  static const String routeName = '/insertConsultPage';
  const InsertConsultPage({Key? key}) : super(key: key);

  @override
  State<InsertConsultPage> createState() => _InsertConsultPageState();
}

class _InsertConsultPageState extends State<InsertConsultPage> {
  String _title = '';
  String _description = '';
  List<XFile?> _photoList = <XFile?>[];

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => unFocus(context),
    child: Scaffold(
      appBar: AppBar(
        titleTextStyle: CustomTextStyle.appBarStyle(context),
        title: const Text('문의하기'),
        actions: [
          CustomTextButton('등록', !_check ? null : () => showIndicator(_insertConsult), color: _check ? null : CustomColors.hint)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              margin: basePadding(context),
              autofocus: true,
              textFieldType: TextFieldType.underline,
              hintText: '제목',
              onChanged: (title) => setState(() => _title = title),
            ),
            CustomTextField(
              textStyle: CustomTextStyle.w500(context, height: 1.5),
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
                  CupertinoButton(
                    padding: EdgeInsets.only(right: mediaWidth(context, 0.033)),
                    child: Container(
                      alignment: Alignment.center,
                      height: mediaHeight(context, 0.1),
                      width: mediaHeight(context, 0.1),
                      decoration: BoxDecoration(
                          color: CustomColors.empty,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: CustomColors.hint)
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.image_outlined, size: mediaHeight(context, 0.03), color: CustomColors.hint),
                          Text('사진 올리기', style: CustomTextStyle.w500(context, color: CustomColors.hint, scale: 0.012))
                        ],
                      ),
                    ),
                    onPressed: () async{
                      XFile? image = await imagePicker(ImageSource.gallery);
                      if(image != null){
                        setState(() => _photoList.add(image));
                      } else if(_photoList.length >= 3){
                        showSnackBar(context, '사진은 최대 3개까지 등록이 가능합니다.');
                      }
                    },
                  ),
                  if(_photoList.isNotEmpty) for(int index = 0; index < _photoList.length; index++) Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.only(right: mediaWidth(context, 0.033)),
                        child: Container(
                          alignment: Alignment.center,
                          height: mediaHeight(context, 0.1),
                          width: mediaHeight(context, 0.1),
                          decoration: BoxDecoration(
                              color: CustomColors.empty,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: CustomColors.hint),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(_photoList[index]!.path))
                              )
                          ),
                        ),
                        onPressed: (){
                          Get.to(() => PhotoListView(_photoList.map((photo) => photo!.path).toList(), PhotoListType.file, currentIndex: index), fullscreenDialog: true);
                        },
                      ),
                      GestureDetector(
                        child: Container(
                            margin: EdgeInsets.only(right: mediaWidth(context, 0.005)),
                            child: Icon(Icons.cancel, size: mediaHeight(context, 0.03), color: CustomColors.main)),
                        onTap: (){
                          setState(() {
                            _photoList.remove(_photoList[index]);
                          });
                        },
                      )
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

  Future get _insertConsult async{
    try{
      final Response res = await ConsultListController.instance.insertConsult(title: _title, description: _description, photoList: _photoList);
      switch(res.statusCode){
        case 201:
          Get.until((route) => route.settings.name == InsertConsultPage.routeName);
          return showSnackBar(context, '문의가 등록되었습니다.');
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
