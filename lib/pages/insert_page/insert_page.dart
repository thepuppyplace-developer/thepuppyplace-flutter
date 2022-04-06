import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../util/common.dart';
import '../../widgets/buttons/select_button.dart';
import '../../widgets/tab_bars/select_category_tab_bar.dart';
import '../../widgets/text_fields/under_line_text_field.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({Key? key}) : super(key: key);

  @override
  _InsertPageState createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  int _categoryIndex = 0;
  int _locationIndex = 0;
  int _locationDetailIndex = 0;
  
  List<String> photoList = <String>[];
  
  Future pickImages() async{
    photoList = await pickMultiImage();
    setState(() {});
  }

  final List<String> _categoryList = const <String>[
    '수다방', '카페', '음식점', '호텔', '운동장', '쇼핑몰'
  ];
  final List<String> _locationList = const <String>[
    '서울', '경기/인천', '대전/충청', '대구/경북', '부산/경남', '광주/전라', '기타'
  ];
  final List<String> _locationDetailList = const <String>[
    '서울', '경기/인천', '대전/충청', '대구/경북', '부산/경남', '광주/전라', '기타'
  ];

  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        unFocus(context);
      },
      child: Scaffold(
        body: Column(
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
                        String text = _locationList[index];
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
                          childCount: _locationList.length
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
                        String text = _locationList[index];
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
                          childCount: _locationList.length
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02), horizontal: mediaWidth(context, 0.033)),
                            child: Text('글작성', style: CustomTextStyle.w600(context, scale: 0.018))),
                        UnderlineTextField(
                          margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                          controller: _title,
                          keyboardType: TextInputType.text,
                          hintText: '제목을 입력해주세요.(최대 20자)',
                          textInputAction: TextInputAction.next,
                          maxLength: 20,
                        ),
                        UnderlineTextField(
                          margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                          controller: _description,
                          minLines: 20,
                          maxLines: 50,
                          keyboardType: TextInputType.text,
                          hintText: '내용을 입력해주세요.',
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: mediaHeight(context, 0.1),
              margin: EdgeInsets.all(mediaWidth(context, 0.033)),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
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
                  for(String? photo in photoList) Container(
                    alignment: Alignment.center,
                    height: mediaHeight(context, 0.1),
                    width: mediaHeight(context, 0.1),
                    decoration: BoxDecoration(
                        color: CustomColors.empty,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: CustomColors.hint),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(photo!))
                      )
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
