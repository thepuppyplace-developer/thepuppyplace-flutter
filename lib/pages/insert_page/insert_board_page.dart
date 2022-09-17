import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thepuppyplace_flutter/controllers/board/board_list_controller.dart';
import 'package:thepuppyplace_flutter/views/photo_view/photo_list_view.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/Member.dart';
import '../../repositories/board/board_repository.dart';
import '../../util/common.dart';
import '../../util/location_list.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/buttons/custom_icon_button.dart';
import '../../widgets/buttons/select_button.dart';
import '../../widgets/tab_bars/select_category_tab_bar.dart';
import '../../widgets/text_fields/custom_text_field.dart';
import '../my_page/login_request_page.dart';

class InsertBoardPage extends StatefulWidget {
  static const String routeName = '/insertBoardPage';
  const InsertBoardPage({Key? key}) : super(key: key);

  @override
  _InsertBoardPageState createState() => _InsertBoardPageState();
}

class _InsertBoardPageState extends State<InsertBoardPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _categoryIndex = 0;
  int? _locationIndex;
  int _locationDetailIndex = 0;

  List<XFile?> photoList = <XFile?>[];

  final List<String> _categoryList = const <String>[
    '수다방', '카페', '음식점', '호텔', '운동장', '쇼핑몰'
  ];

  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        unFocus(context);
      },
      child: GetBuilder<UserController>(
          builder: (UserController controller) {
            return Scaffold(
              body: controller.obx((Member? user) => Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            elevation: 0.5,
                            snap: true,
                            floating: true,
                            pinned: true,
                            title: Text('글쓰기', style: CustomTextStyle.w600(context, scale: 0.02)),
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
                          if(_locationIndex != null) SliverToBoxAdapter(
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
                            padding: EdgeInsets.only(bottom: mediaWidth(context, 0.033)),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02), horizontal: mediaWidth(context, 0.033)),
                                      child: Text('글작성', style: CustomTextStyle.w600(context, scale: 0.018))),
                                  CustomTextField(
                                    autofocus: false,
                                    textFieldType: TextFieldType.underline,
                                    onChanged: (String title){
                                      setState(() {
                                        _title = title;
                                      });
                                    },
                                    margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                                    hintText: '제목을 입력해주세요.(최대 50자)',
                                    textInputAction: TextInputAction.next,
                                    maxLength: 50,
                                    validator: (title){
                                      if(title!.trim().isEmpty){
                                        return '제목을 입력해주세요.';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  CustomTextField(
                                    autofocus: false,
                                    textFieldType: TextFieldType.underline,
                                    onChanged: (String description){
                                      setState(() {
                                        _description = description;
                                      });
                                    },
                                    textStyle: CustomTextStyle.w500(context, height: 1.5),
                                    margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                                    minLines: 10,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    hintText: '내용을 입력해주세요.',
                                    validator: (description){
                                      if(description!.isEmpty){
                                        return '내용을 입력해주세요.';
                                      } else if(description.length < 10){
                                        return '내용을 10자 이상 입력해주세요.';
                                      } else {
                                        return null;
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
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
                                      XFile? image = await imagePicker(ImageSource.gallery);
                                      if(image != null){
                                        setState(() => photoList.add(image));
                                      }
                                    },
                                  ),
                                  if(photoList.isNotEmpty) for(int index = 0; index < photoList.length; index++) Stack(
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
                                                  image: FileImage(File(photoList[index]!.path))
                                              )
                                          ),
                                        ),
                                        onPressed: (){
                                          Get.to(() => PhotoListView(photoList.map((photo) => photo!.path).toList(), PhotoListType.file, currentIndex: index), fullscreenDialog: true);
                                        },
                                      ),
                                      GestureDetector(
                                        child: Container(
                                            margin: EdgeInsets.only(right: mediaWidth(context, 0.005)),
                                            child: Icon(Icons.cancel, size: mediaHeight(context, 0.03), color: CustomColors.main)),
                                        onTap: (){
                                          setState(() {
                                            photoList.remove(photoList[index]);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: CustomButton(
                          margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                          title: '등록하기',
                          onPressed: insertBoard
                      ),
                    )
                  ],
                ),
              ),
                  onEmpty: SafeArea(
                    child: Stack(
                      children: [
                        const LoginRequestPage(),
                        CustomIconButton(
                          icon: Icons.clear,
                          onTap: (){
                            Get.back();
                          },
                        )
                      ],
                    ),
                  )
              ),
            );
          }
      ),
    );
  }

  void insertBoard() {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      if(_locationIndex == null){
        showSnackBar(context, '지역을 선택해주세요.');
      } else {
        showIndicator(BoardRepository.from.insertBoard(
            context,
            title: _title,
            description: _description,
            location: '${LocationList.location[_locationIndex!]} ${LocationList.details(_locationIndex)[_locationDetailIndex]}',
            category: _categoryList[_categoryIndex],
            photoList: photoList
        ));
        BoardListController.to.refreshBoardList();
      }
    }
  }
}
