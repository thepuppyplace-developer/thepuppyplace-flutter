import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thepuppyplace_flutter/controllers/user/user_controller.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_icon_button.dart';
import '../../repositories/notice/notice_repository.dart';
import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/buttons/custom_text_button.dart';
import '../../widgets/buttons/pick_image_button.dart';
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
  XFile? _image;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        unFocus(context);
      },
      child: Scaffold(
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
                  showIndicator(insertNotice);
                })
              ],
            )
          ],
          body: SingleChildScrollView(
            padding: EdgeInsets.all(mediaWidth(context, 0.033)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
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
                        return '5자 이상 입력해주세요.';
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomTextField(
                    contentPadding: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.015)),
                    textFieldType: TextFieldType.underline,
                    hintText: '내용을 입력해주세요.',
                    onChanged: (description){
                      setState(() {
                        _notice_main_text = description;
                      });
                    },
                    minLines: 20,
                    maxLines: null,
                    validator: (description){
                      if(_notice_main_text.isEmpty){
                        return '내용을 입력해주세요.';
                      } else {
                        return null;
                      }
                    },
                  ),
                  if (_image != null) AspectRatio(
                    aspectRatio: 3/4,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: mediaWidth(context, 0.033)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(_image!.path)))
                          ),
                        ),
                        Positioned(
                          top: mediaHeight(context, 0.01),
                          child: CustomIconButton(
                              icon: Icons.cancel,
                              color: Colors.black45,
                              onTap: (){
                                setState(() {
                                  _image = null;
                                });
                              }),
                        )
                      ],
                    ),
                  ),
                  PickImageButton(
                    margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.015)),
                    onTap: () async{
                      _image = await imagePicker(ImageSource.camera);
                      setState(() {});
                    },
                    text: _image == null ? null : '사진 변경',
                  ),
                  SizedBox(height: mediaHeight(context, 0.1))
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: CustomButton(
          margin: EdgeInsets.all(mediaWidth(context, 0.033)),
          title: '등록',
          onPressed: () {
            showIndicator(insertNotice);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      )
    );
  }

  Future get insertNotice async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      int? statusCode = await _repository.insertNotice(context, UserController.to.user!.jwt_token, image: _image, notice_title: _notice_title, notice_main_text: _notice_main_text);
      if(statusCode == 201){
        Get.until((route) => route.isFirst);
      }
    }
  }
}
