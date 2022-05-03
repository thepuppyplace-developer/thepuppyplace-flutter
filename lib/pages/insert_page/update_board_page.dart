import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thepuppyplace_flutter/models/Board.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/User.dart';
import '../../repositories/board/board_repository.dart';
import '../../util/common.dart';
import '../../util/location_list.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/buttons/select_button.dart';
import '../../widgets/tab_bars/select_category_tab_bar.dart';
import '../../widgets/text_fields/custom_text_field.dart';
import '../my_page/login_request_page.dart';

class UpdateBoardPage extends StatefulWidget {
  final Board board;
  const UpdateBoardPage(this.board, {Key? key}) : super(key: key);

  @override
  _UpdateBoardPageState createState() => _UpdateBoardPageState();
}

class _UpdateBoardPageState extends State<UpdateBoardPage> {
  int _categoryIndex = 0;
  int? _locationIndex;
  int _locationDetailIndex = 0;

  List<XFile> photoList = <XFile>[];

  final List<String> _categoryList = const <String>[
    '수다방', '카페', '음식점', '호텔', '운동장', '쇼핑몰'
  ];

  String _title = '';
  String _description = '';

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.board.title);
    _descriptionController = TextEditingController(text: widget.board.description);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        unFocus(context);
      },
      child: GetBuilder<UserController>(
          builder: (UserController controller) {
            return Scaffold(
              body: controller.obx((User? user) => Column(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CustomScrollView(
                          slivers: [
                            SliverAppBar(
                              elevation: 0.5,
                              snap: true,
                              floating: true,
                              pinned: true,
                              title: Text('글쓰기', style: CustomTextStyle.w600(context, scale: 0.02)),
                              actions: [
                                CupertinoButton(
                                  child: Text('등록', style: CustomTextStyle.w500(context, scale: 0.018, color: CustomColors.hint)),
                                  onPressed: null,
                                )
                              ],
                              bottom: SelectCategoryTabBar(mediaHeight(context, 0.06),
                                categoryIndex: _categoryIndex,
                                categoryList: _categoryList,
                                onChanged: (int index){
                                  setState(() {
                                    _categoryIndex = index;
                                  });
                                },
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Container(
                                  margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02), horizontal: mediaWidth(context, 0.033)),
                                  child: Text('지역태그', style: CustomTextStyle.w600(context, scale: 0.018))),
                            ),
                            SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                              sliver: SliverGrid(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisExtent: mediaHeight(context, 0.06),
                                    crossAxisSpacing: mediaWidth(context, 0.01)
                                ),
                                delegate: SliverChildBuilderDelegate((context, index){
                                  String text = LocationList.location[index];
                                  return SelectButton(
                                    text: text,
                                    currentIndex: _locationIndex,
                                    index: index,
                                    onChanged: (int index){
                                      setState(() {
                                        _locationIndex = index;
                                      });
                                    },
                                  );
                                },
                                    childCount: LocationList.location.length
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Container(
                                  margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02), horizontal: mediaWidth(context, 0.033)),
                                  child: Text('세부지역선택', style: CustomTextStyle.w600(context, scale: 0.018))),
                            ),
                            SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                              sliver: SliverGrid(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisExtent: mediaHeight(context, 0.06),
                                    crossAxisSpacing: mediaWidth(context, 0.01)
                                ),
                                delegate: SliverChildBuilderDelegate((context, index){
                                  String text = LocationList.details(_locationIndex)[index];
                                  return SelectButton(
                                    text: text,
                                    currentIndex: _locationDetailIndex,
                                    index: index,
                                    onChanged: (int index){
                                      setState(() {
                                        _locationDetailIndex = index;
                                      });
                                    },
                                  );
                                },
                                    childCount: LocationList.details(_locationIndex).length
                                ),
                              ),
                            ),
                            SliverPadding(
                              padding: EdgeInsets.only(bottom: mediaHeight(context, 0.15)),
                              sliver: SliverToBoxAdapter(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02), horizontal: mediaWidth(context, 0.033)),
                                        child: Text('글작성', style: CustomTextStyle.w600(context, scale: 0.018))),
                                    CustomTextField(
                                      textFieldType: TextFieldType.underline,
                                      onChanged: (String title){
                                        setState(() {
                                          _title = title;
                                        });
                                      },
                                      controller: _titleController,
                                      margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                                      keyboardType: TextInputType.text,
                                      hintText: '제목을 입력해주세요.(최대 20자)',
                                      textInputAction: TextInputAction.next,
                                      maxLength: 20,
                                    ),
                                    CustomTextField(
                                      textFieldType: TextFieldType.underline,
                                      onChanged: (String description){
                                        setState(() {
                                          _description = description;
                                        });
                                      },
                                      controller: _descriptionController,
                                      margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                                      minLines: 20,
                                      maxLines: 50,
                                      keyboardType: TextInputType.text,
                                      hintText: '내용을 입력해주세요.',
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: mediaHeight(context, 0.1),
                          margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
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
                                  photoList = await pickMultiImage();
                                  setState(() {});
                                },
                              ),
                              if(photoList.isNotEmpty) for(XFile photo in photoList) CupertinoButton(
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
                                          image: FileImage(File(photo.path))
                                      )
                                  ),
                                ),
                                onPressed: (){},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                    title: '수정하기',
                    onPressed: (){
                      showIndicator(BoardRepository.from.insertBoard(
                        context,
                        user!.jwt_token,
                        title: _title,
                        description: _description,
                        location: '${LocationList.location[_locationIndex!]} ${LocationList.details(_locationIndex)[_locationDetailIndex]}',
                        category: _categoryList[_categoryIndex],
                        board_photos: photoList
                      ));
                    },
                  )
                ],
              ),
                  onEmpty: const LoginRequestPage()
              ),
            );
          }
      ),
    );
  }
}
