import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thepuppyplace_flutter/models/Board.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/Member.dart';
import '../../repositories/board/board_repository.dart';
import '../../util/common.dart';
import '../../views/photo_view/photo_list_view.dart';
import '../../widgets/buttons/custom_button.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _categoryIndex = 0;
  int _photoIndex = 0;

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
    _title = widget.board.title;
    _description = widget.board.description;
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
              body: controller.obx((Member? user) => Form(
                key: _formKey,
                child: Column(
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
                                title: Text('게시글 수정', style: CustomTextStyle.w600(context, scale: 0.02)),
                                actions: [
                                  CupertinoButton(
                                    child: Text('수정', style: CustomTextStyle.w500(context, scale: 0.018, color: CustomColors.main)),
                                    onPressed: updateBoard,
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
                              // SliverToBoxAdapter(
                              //   child: Container(
                              //       margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02), horizontal: mediaWidth(context, 0.033)),
                              //       child: Text('지역태그', style: CustomTextStyle.w600(context, scale: 0.018))),
                              // ),
                              // SliverPadding(
                              //   padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                              //   sliver: SliverGrid(
                              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              //         crossAxisCount: 4,
                              //         mainAxisExtent: mediaHeight(context, 0.06),
                              //         crossAxisSpacing: mediaWidth(context, 0.01)
                              //     ),
                              //     delegate: SliverChildBuilderDelegate((context, index){
                              //       String text = LocationList.location[index];
                              //       return SelectButton(
                              //         text: text,
                              //         currentIndex: _locationIndex,
                              //         index: index,
                              //         onChanged: (int index){
                              //           setState(() {
                              //             _locationIndex = index;
                              //           });
                              //         },
                              //       );
                              //     },
                              //         childCount: LocationList.location.length
                              //     ),
                              //   ),
                              // ),
                              // if(_locationIndex != null) SliverToBoxAdapter(
                              //   child: Container(
                              //       margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.02), horizontal: mediaWidth(context, 0.033)),
                              //       child: Text('세부지역선택', style: CustomTextStyle.w600(context, scale: 0.018))),
                              // ),
                              // SliverPadding(
                              //   padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                              //   sliver: SliverGrid(
                              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              //         crossAxisCount: 4,
                              //         mainAxisExtent: mediaHeight(context, 0.06),
                              //         crossAxisSpacing: mediaWidth(context, 0.01)
                              //     ),
                              //     delegate: SliverChildBuilderDelegate((context, index){
                              //       String text = LocationList.details(_locationIndex)[index];
                              //       return SelectButton(
                              //         text: text,
                              //         currentIndex: _locationDetailIndex,
                              //         index: index,
                              //         onChanged: (int index){
                              //           setState(() {
                              //             _locationDetailIndex = index;
                              //           });
                              //         },
                              //       );
                              //     },
                              //         childCount: LocationList.details(_locationIndex).length
                              //     ),
                              //   ),
                              // ),
                              if(widget.board.board_photos.isNotEmpty) SliverToBoxAdapter(
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    CarouselSlider.builder(
                                      itemCount: widget.board.board_photos.length,
                                      options: CarouselOptions(
                                          height: mediaWidth(context, 1),
                                          enableInfiniteScroll: false,
                                          viewportFraction: 1,
                                          onPageChanged: (int index, index2){
                                            setState(() {
                                              _photoIndex = index;
                                            });
                                          }
                                      ),
                                      itemBuilder: (context, index, index2){
                                        String photo = widget.board.board_photos[index];
                                        return CupertinoButton(
                                          padding: EdgeInsets.all(mediaWidth(context, 0.033)),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: CachedNetworkImageProvider(photo),
                                                )
                                            ),
                                          ),
                                          onPressed: (){
                                            Get.to(() => PhotoListView(widget.board.board_photos, PhotoListType.cached, currentIndex: index), fullscreenDialog: true);
                                          },
                                        );
                                      },
                                    ),
                                    AnimatedSmoothIndicator(
                                      activeIndex: _photoIndex,
                                      count: widget.board.board_photos.length,
                                      effect: WormEffect(
                                        activeDotColor: CustomColors.main,
                                        dotColor: CustomColors.hint,
                                        dotWidth: mediaWidth(context, 0.015),
                                        dotHeight: mediaWidth(context, 0.015),
                                      ),
                                    )
                                  ],
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
                                        textStyle: CustomTextStyle.w500(context, height: 1.5),
                                        controller: _descriptionController,
                                        margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                                        minLines: 20,
                                        maxLines: 50,
                                        keyboardType: TextInputType.multiline,
                                        hintText: '내용을 입력해주세요.',
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
                      child: CustomButton(
                        margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                        title: '수정하기',
                        onPressed: updateBoard
                      ),
                    )
                  ],
                ),
              ),
                  onEmpty: const LoginRequestPage()
              ),
            );
          }
      ),
    );
  }

  void updateBoard() {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      showIndicator(BoardRepository.from.updateBoard(
        context,
        board_id: widget.board.id,
        title: _title,
        description: _description,
        category: _categoryList[_categoryIndex],
      ));
    }
  }
}
