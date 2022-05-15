import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thepuppyplace_flutter/repositories/board/board_repository.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/views/photo_view/photo_list_view.dart';
import 'package:thepuppyplace_flutter/widgets/dialogs/custom_dialog.dart';
import '../../config/config.dart';
import '../../controllers/board/board_controller.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/Board.dart';
import '../../models/BoardComment.dart';
import '../../models/CommentLike.dart';
import '../../models/NestedComment.dart';
import '../../views/rx_status_view.dart';
import '../../widgets/buttons/tag_text.dart';
import '../../widgets/cards/comment_card.dart';
import '../../widgets/cards/user_profile_card.dart';
import '../../widgets/animations/like_animation.dart';
import '../../widgets/loadings/refresh_contents.dart';
import '../../widgets/text_fields/comment_field.dart';
import '../insert_page/update_board_page.dart';

class BoardDetailsPage extends StatefulWidget {
  static const String routeName = '/board_details_page';
  const BoardDetailsPage({Key? key}) : super(key: key);

  @override
  State<BoardDetailsPage> createState() => _BoardDetailsPageState();
}

class _BoardDetailsPageState extends State<BoardDetailsPage> {
  final RefreshController _refreshController = RefreshController();
  final int board_id = Get.arguments;
  int _photoIndex = 0;
  BoardComment? _selectComment;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoardController>(
        init: BoardController(board_id),
        builder: (BoardController controller) => controller.obx((Board? board) => GestureDetector(
          onTap: (){
            unFocus(context);
          },
          child: Scaffold(
            body: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (BuildContext context, bool inner) => [
                SliverAppBar(
                  snap: true,
                  floating: true,
                  pinned: true,
                  centerTitle: true,
                  elevation: 0.5,
                  leading: const BackButton(),
                  title: Text(board!.category, style: CustomTextStyle.w600(context, scale: 0.02),),
                  actions: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(Icons.ios_share, color: Colors.black, size: mediaHeight(context, 0.03),),
                      onPressed: () async{
                        final box = context.findRenderObject() as RenderBox?;

                        if (board.board_photos.isNotEmpty) {
                          await Share.shareFiles(board.board_photos,
                              text: board.title,
                              subject: board.description,
                              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
                        } else {
                          await Share.share(board.title,
                              subject: board.description,
                              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
                        }
                      },
                    ),
                    if(UserController.user != null && (UserController.user!.id == board.userId || Config.ADMIN_EMAIL == UserController.user!.email))CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: null,
                      child: PopupMenuButton(
                        child: Icon(Icons.more_vert, color: Colors.black, size: mediaHeight(context, 0.03)),
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('게시글 수정', style: CustomTextStyle.w500(context)),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('게시글 삭제', style: CustomTextStyle.w500(context)),
                          )
                        ],
                        onSelected: (String value){
                          switch(value){
                            case 'delete': {
                              showCupertinoDialog(context: context, builder: (context) => CustomDialog(
                                  title: '게시글을 삭제하시겠습니까?',
                                  content: '삭제한 게시글은 복원되지 않습니다.\n삭제하시겠습니까?',
                                  onTap: (){
                                    showIndicator(controller.deleteBoard(context));
                                  }
                              ));
                              break;
                            }
                            default: {
                              Get.to(() => UpdateBoardPage(board));
                            }
                          }
                        },
                      ),
                    )
                  ],
                )
              ],
              body: SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () => controller.getBoard.whenComplete((){
                    _refreshController.refreshCompleted(resetFooterState: true);
                  }),
                  header: CustomHeader(
                    builder: (BuildContext context, RefreshStatus? status) => RefreshContents(status),
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
                                  child: UserProfileCard(board!.user)
                              ),
                              Text(beforeDate(board.createdAt), style: CustomTextStyle.w500(context, color: CustomColors.hint))
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)),
                          child: Row(
                            children: [
                              TagText(board.category),
                              TagText(board.location)
                            ],
                          ),
                        ),
                        if(board.board_photos.isNotEmpty) Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            CarouselSlider.builder(
                              itemCount: board.board_photos.length,
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
                                String photo = board.board_photos[index];
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
                                    Get.to(() => PhotoListView(index, board.board_photos, PhotoType.cached), fullscreenDialog: true);
                                  },
                                );
                              },
                            ),
                            AnimatedSmoothIndicator(
                              activeIndex: _photoIndex,
                              count: board.board_photos.length,
                              effect: WormEffect(
                                activeDotColor: CustomColors.main,
                                dotColor: CustomColors.hint,
                                dotWidth: mediaWidth(context, 0.015),
                                dotHeight: mediaWidth(context, 0.015),
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
                        Container(
                          decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: CustomColors.emptySide, blurStyle: BlurStyle.outer, blurRadius: 5)
                              ]
                          ),
                          padding: EdgeInsets.all(mediaWidth(context, 0.033)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: mediaWidth(context, 0.02)),
                                      child: GetBuilder<UserController>(
                                          init: UserController(),
                                          builder: (UserController userController) => userController.obx((user) {
                                            if(board.likeList.where((like) => like.userId == user!.id).isEmpty){
                                              return GestureDetector(
                                                child: Icon(CupertinoIcons.heart, color: CustomColors.hint, size: mediaHeight(context, 0.025)),
                                                onTap: (){
                                                  showDialog(context: context, builder: (context) => LikeAnimation(CupertinoIcons.heart_fill, controller.likeBoard(context)));
                                                },
                                              );
                                            } else {
                                              return GestureDetector(
                                                child: Icon(CupertinoIcons.heart_fill, color: Colors.red, size: mediaHeight(context, 0.025)),
                                                onTap: (){
                                                  controller.likeBoard(context);
                                                },
                                              );
                                            }
                                          },
                                              onEmpty: GestureDetector(
                                                child: Icon(CupertinoIcons.heart, color: CustomColors.hint, size: mediaHeight(context, 0.025)),
                                                onTap: (){
                                                  showSnackBar(context, '로그인을 해주세요.');
                                                },
                                              )
                                          )
                                      ),
                                    ),
                                    Text(board.likeList.length.toString(), style: CustomTextStyle.w400(context, scale: 0.02, color: Colors.grey)),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.02)),
                                      child: GestureDetector(
                                        child: Icon(CupertinoIcons.bubble_left, color: CustomColors.hint, size: mediaHeight(context, 0.025)),
                                        onTap: (){},
                                      ),
                                    ),
                                    Text('${commentCount(board.commentList)}', style: CustomTextStyle.w400(context, scale: 0.02, color: Colors.grey))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //댓글 리스트
                        if(board.commentList.isNotEmpty) Container(
                          margin: EdgeInsets.all(mediaWidth(context, 0.033)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for(BoardComment comment in board.commentList) CommentCard(comment,
                                  onComment: (BoardComment boardComment){
                                    setState(() {
                                      _selectComment = boardComment;
                                    });
                                  },
                                  onLike: (BoardComment boardComment) => controller.likeComment(context, boardComment.commentId),
                                  onCommentDelete: () => controller.deleteComment(context, comment.commentId),
                                  onNestedCommentDelete: (NestedComment nestedComment) => controller.deleteNestedComment(context, nestedComment)
                                )
                              ]
                          ),
                        ),
                        SizedBox(height: mediaHeight(context, 0.1))
                      ],
                    ),
                  )
              ),
            ),
            bottomSheet: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(_selectComment != null) Opacity(
                  opacity: 0.5,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033), vertical: mediaHeight(context, 0.01)),
                      decoration: const BoxDecoration(
                        color: CustomColors.emptySide,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text:_selectComment!.user.nickname,
                                      style: CustomTextStyle.w600(context)
                                  ),
                                  TextSpan(
                                      text: '님에게 댓글 달기',
                                      style: CustomTextStyle.w500(context)
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            child: Text('취소', style: CustomTextStyle.w500(context)),
                            onTap: (){
                              setState(() {
                                _selectComment = null;
                              });
                            },
                          )
                        ],
                      )
                  ),
                ),
                CommentField(
                  commentController: _commentController,
                  onPressed: (comment) async{
                    if(_selectComment != null){
                      await controller.insertNestedComment(
                          context,
                          comment_id: _selectComment!.commentId,
                          comment: comment
                      );
                      setState(() {
                      });
                    } else {
                      await controller.insertComment(
                          context,
                          comment: comment
                      );
                    }
                    setState(() {
                      _selectComment = null;
                      _commentController.clear();
                    });
                  },
                )
              ],
            ),
          ),
        ),
            onLoading: Scaffold(
                appBar: AppBar(),
                body: const LoadingView(message: '게시글을 불러오는 중입니다...')),
            onEmpty: Scaffold(
                appBar: AppBar(
                    title: const Text('삭제된 게시글')
                ),
                body: const EmptyView(message: '등록된 게시글이 삭제되었습니다.'))
        )
    );
  }
}
