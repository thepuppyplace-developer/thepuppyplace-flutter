import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thepuppyplace_flutter/models/Notice.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_icon_button.dart';
import '../../repositories/notice/notice_repository.dart';
import '../../util/common.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/buttons/custom_text_button.dart';
import '../../widgets/buttons/pick_image_button.dart';
import '../../widgets/text_fields/custom_text_field.dart';
import 'notice_list_page.dart';

class NoticeUpdatePage extends StatefulWidget {
  final Notice notice;
  const NoticeUpdatePage(this.notice, {Key? key}) : super(key: key);

  @override
  State<NoticeUpdatePage> createState() => _NoticeUpdatePageState();
}

class _NoticeUpdatePageState extends State<NoticeUpdatePage> {
  final NoticeRepository _repository = NoticeRepository();

  String _notice_title = '';
  String _notice_main_text = '';

  final TextEditingController _titleCtr = TextEditingController();
  final TextEditingController _descriptionCtr = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleCtr.text = widget.notice.notice_title;
    _notice_title = widget.notice.notice_title;
    _descriptionCtr.text = widget.notice.notice_main_text;
    _notice_main_text = widget.notice.notice_main_text;
  }

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
                CustomTextButton('수정', (){
                  showIndicator(updateNotice);
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
                    controller: _titleCtr,
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
                    controller: _descriptionCtr,
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
                  if (widget.notice.image_url != null) AspectRatio(
                    aspectRatio: 3/4,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: mediaWidth(context, 0.033)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(widget.notice.image_url!))
                      ),
                    ),
                  ),
                  SizedBox(height: mediaHeight(context, 0.1))
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: CustomButton(
          margin: EdgeInsets.all(mediaWidth(context, 0.033)),
          title: '수정',
          onPressed: () {
            showIndicator(updateNotice);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      )
    );
  }

  Future get updateNotice async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      int? statusCode = await _repository.updateNotice(context,
          notice_id: widget.notice.id!,
          title: _notice_title,
          description: _notice_main_text);
      if(statusCode == 201){
        Get.until((route) => route.settings.name == NoticeListPage.routeName);
      }
    }
  }
}