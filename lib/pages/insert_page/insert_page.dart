import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/common.dart';
import '../../util/customs.dart';
import '../../widgets/buttons/select_button.dart';
import '../../widgets/delegates/header_delegate.dart';
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
    return Scaffold(
      body: CustomScrollView(
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
                child: Text('지역태그', style: CustomTextStyle.w500(context, scale: 0.018))),
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
                child: Text('세부지역선택', style: CustomTextStyle.w500(context, scale: 0.018))),
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
          SliverFillRemaining(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02), horizontal: mediaWidth(context, 0.033)),
                    child: Text('글작성', style: CustomTextStyle.w500(context, scale: 0.018))),
                UnderlineTextField(
                  margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                  controller: _title,
                  keyboardType: TextInputType.text,
                  hintText: '제목을 입력해주세요.(최대 20자)',
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
