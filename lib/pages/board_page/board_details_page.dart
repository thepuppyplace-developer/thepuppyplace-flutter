import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../controllers/board/board_controller.dart';
import '../../models/Board.dart';
import '../../util/custom_icons.dart';
import '../../widgets/buttons/tag_text.dart';
import '../../widgets/cards/comment_card.dart';
import '../../widgets/cards/user_profile_card.dart';
import '../../widgets/loadings/refresh_contents.dart';
import '../../widgets/text_fields/comment_field.dart';

class BoardDetailsPage extends StatefulWidget {
  final int board_id;

  const BoardDetailsPage(this.board_id, {Key? key}) : super(key: key);

  @override
  State<BoardDetailsPage> createState() => _BoardDetailsPageState();
}

class _BoardDetailsPageState extends State<BoardDetailsPage> {
  final RefreshController _refreshController = RefreshController();
  int _photoIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<BoardController>(
            init: BoardController(widget.board_id),
            builder: (BoardController controller) => controller.obx((Board? board) => NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (BuildContext context, bool inner) => [
                SliverAppBar(
                  snap: true,
                  floating: true,
                  pinned: true,
                  centerTitle: true,
                  elevation: 0.5,
                  title: Text(controller.board!.category, style: CustomTextStyle.w600(context, scale: 0.02),),
                  actions: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(Icons.ios_share, color: Colors.black, size: mediaHeight(context, 0.03),),
                      onPressed: (){},
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(Icons.more_vert, color: Colors.black, size: mediaHeight(context, 0.03),),
                      onPressed: (){},
                    )
                  ],
                ),
              ],
              body: Column(
                children: [
                  Expanded(
                    child: SmartRefresher(
                        controller: _refreshController,
                        enablePullUp: true,
                        onRefresh: () async{
                          controller.getBoard().whenComplete((){
                            _refreshController.refreshCompleted(resetFooterState: true);
                          });
                        },
                        onLoading: () async{
                          controller.page.value += 5;
                          controller.getBoard().whenComplete((){
                            _refreshController.refreshCompleted(resetFooterState: true);
                          });
                        },
                        header: CustomHeader(
                          builder: (BuildContext context, RefreshStatus? status) => RefreshContents(status),
                          readyToRefresh: () async{

                          },
                        ),
                        footer: controller.status.isEmpty ? null : CustomFooter(
                          loadStyle: LoadStyle.ShowWhenLoading,
                          builder: (BuildContext context, LoadStatus? status) => LoadContents(status,
                            noMoreText: '마지막 댓글입니다.',
                          ),
                        ),
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: UserProfileCard(board!.user!)
                                    ),
                                    Text(beforeDate(board.createdAt ?? DateTime.now()), style: CustomTextStyle.w500(context, color: CustomColors.hint))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033), vertical: mediaHeight(context, 0.01)),
                                child: Row(
                                  children: [
                                    TagText(board.category),
                                    TagText(board.location)
                                  ],
                                ),
                              ),
                              if(board.board_photos!.isNotEmpty) Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  CarouselSlider.builder(
                                    itemCount: board.board_photos!.length,
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
                                      String photo = board.board_photos![index];
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: CachedNetworkImageProvider(photo),
                                            )
                                        ),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    bottom: mediaHeight(context, 0.02),
                                    child: AnimatedSmoothIndicator(
                                      activeIndex: _photoIndex,
                                      count: board.board_photos!.length,
                                      effect: WormEffect(
                                        activeDotColor: CustomColors.main,
                                        dotWidth: mediaWidth(context, 0.015),
                                        dotHeight: mediaWidth(context, 0.015),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                                  child: Text(board.title, style: CustomTextStyle.w600(context, scale: 0.02))),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)).copyWith(bottom: mediaWidth(context, 0.033)),
                                child: Text(board.description, style: CustomTextStyle.w400(context)),
                              ),
                              const Divider(height: 0, color: CustomColors.emptySide,),
                              Container(
                                margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: mediaWidth(context, 0.02)),
                                            child: GestureDetector(
                                              child: Icon(CustomIcons.heart, color: CustomColors.hint, size: mediaHeight(context, 0.025)),
                                              onTap: (){},
                                            ),
                                          ),
                                          Text(board.likeList!.length.toString(), style: CustomTextStyle.w400(context, scale: 0.02)),
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.02)),
                                            child: GestureDetector(
                                              child: Icon(CustomIcons.comment, color: CustomColors.hint, size: mediaHeight(context, 0.025)),
                                              onTap: (){},
                                            ),
                                          ),
                                          Text(board.commentList!.length.toString(), style: CustomTextStyle.w400(context, scale: 0.02))
                                        ],
                                      ),
                                    ),
                                    Text(board.view_count.toString())
                                  ],
                                ),
                              ),
                              const Divider(height: 0, thickness: 5, color: CustomColors.empty),

                              //댓글 리스트
                              if(board.commentList!.isNotEmpty) Container(
                                margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(controller.page.value < board.commentList!.length
                                        ? controller.page.value
                                        : board.commentList!.length, (index) => CommentCard(board.commentList![index]))
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  CommentField(
                      controller.commentController.value,
                          (){
                        controller.insertComment();
                      })
                ],
              ),
            ))
        ));
  }
}
