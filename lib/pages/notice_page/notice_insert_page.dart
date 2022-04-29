import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../repositories/notice_repository.dart';
import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/buttons/custom_text_button.dart';
import '../../widgets/text_fields/custom_text_field.dart';

class NoticeInsertPage extends StatefulWidget {
  const NoticeInsertPage({Key? key}) : super(key: key);

  @override
  State<NoticeInsertPage> createState() => _NoticeInsertPageState();
}

class _NoticeInsertPageState extends State<NoticeInsertPage> {
  final NoticeRepository _repository = NoticeRepository();

  String _notice_title = '';
  String _notice_main_text = '';
  File? _image;

  final GlobalKey<FormState> _titleKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _descriptionKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        unFocus(context);
      },
      child:Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, inner) => [
            SliverAppBar(
              snap: true,
              floating: true,
              pinned: true,
              elevation: 0.5,
              title: Text('공지사항 글쓰기', style: CustomTextStyle.w600(context, scale: 0.02)),
              actions: [
                CustomTextButton('등록', (){

                })
              ],
            )
          ],
          body: SingleChildScrollView(
            padding: EdgeInsets.all(mediaWidth(context, 0.033)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _titleKey,
                  child: CustomTextField(
                    textFieldType: TextFieldType.underline,
                    hintText: '제목을 입력해주세요.(최대 20자)',
                    maxLength: 20,
                    onChanged: (title){
                      setState(() {
                        _notice_title = title;
                      });
                    },
                    validator: (title){
                      if(_notice_title.length < 5){
                        return '5';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Form(
                  key: _descriptionKey,
                  child: CustomTextField(
                    contentPadding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.015)),
                    textFieldType: TextFieldType.none,
                    hintText: '내용을 입력해주세요.',
                    onChanged: (description){
                      setState(() {
                        _notice_main_text = description;
                      });
                    },
                    minLines: 20,
                    maxLines: null,
                  ),
                ),
                SizedBox(height: mediaHeight(context, 0.1))
              ],
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              margin: EdgeInsets.all(mediaWidth(context, 0.033)),
              title: '등록',
              onPressed: () async{
                if(_titleKey.currentState!.validate()){
                  _titleKey.currentState!.save();
                  if(_descriptionKey.currentState!.validate()){
                    _descriptionKey.currentState!.save();
                    int? statusCode = await _repository.insertNotice(context, image: _image, notice_title: _notice_title, notice_main_text: _notice_main_text);
                    if(statusCode == 201){
                      Get.until((route) => route.isFirst);
                    }
                  }
                }
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      )
    );
  }
}
