import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thepuppyplace_flutter/repositories/board/board_repository.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/customs.dart';
import 'package:thepuppyplace_flutter/widgets/dialogs/custom_dialog.dart';
import '../../controllers/board/board_controller.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/Board.dart';
import '../../models/BoardComment.dart';
import '../../models/CommentLike.dart';
import '../../models/NestedComment.dart';
import '../../util/custom_icons.dart';
import '../../widgets/buttons/tag_text.dart';
import '../../widgets/cards/comment_card.dart';
import '../../widgets/cards/user_profile_card.dart';
import '../../widgets/animations/like_animation.dart';
import '../../widgets/loadings/refresh_contents.dart';
import '../../widgets/text_fields/comment_field.dart';
import '../insert_page/update_board_page.dart';

class BoardDetailsPage extends StatefulWidget {
  int board_id;

  BoardDetailsPage(this.board_id, {Key? key}) : super(key: key);

  @override
  State<BoardDetailsPage> createState() => _BoardDetailsPageState();
}

class _BoardDetailsPageState extends State<BoardDetailsPage> {
  final RefreshController _refreshController = RefreshController();
  int _photoIndex = 0;
  BoardComment? _selectComment;
  final TextEditingController _commentController = TextEditingController();
  final repo = BoardRepository();

  @override
  void initState() {
    super.initState();
    widget.board_id = Get.arguments ?? widget.board_id;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoardController>(
        init: BoardController(widget.board_id),
        builder: (BoardController controller) => controller.obx((Board? board) => Scaffold(
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
                    onPressed: (){},
                  ),
                  if(UserController.user != null && UserController.user!.id == board.userId)CupertinoButton(
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
            body: Column(
              children: [
                Expanded(
                  child: SmartRefresher(
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
                                    return Container(
                                      margin: EdgeInsets.all(mediaWidth(context, 0.033)),
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
                                                    child: Icon(CustomIcons.heart, color: CustomColors.hint, size: mediaHeight(context, 0.025)),
                                                    onTap: (){
                                                      showDialog(context: context, builder: (context) => LikeAnimation(CupertinoIcons.heart_fill, controller.likeBoard(context)));
                                                    },
                                                  );
                                                } else {
                                                  return GestureDetector(
                                                    child: Icon(CustomIcons.heart, color: Colors.red, size: mediaHeight(context, 0.025)),
                                                    onTap: (){
                                                      showDialog(context: context, builder: (context) => LikeAnimation(CustomIcons.heart, controller.likeBoard(context)));
                                                    },
                                                  );
                                                }
                                              },
                                                  onEmpty: GestureDetector(
                                                    child: Icon(CustomIcons.heart, color: CustomColors.hint, size: mediaHeight(context, 0.025)),
                                                    onTap: (){
                                                      showSnackBar(context, '로그인을 해주세요.');
                                                    },
                                                  )
                                              )
                                          ),
                                        ),
                                        Text(board.likeList.length.toString(), style: CustomTextStyle.w400(context, scale: 0.02)),
                                        Container(
                                          margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.02)),
                                          child: GestureDetector(
                                            child: Icon(CustomIcons.comment, color: CustomColors.hint, size: mediaHeight(context, 0.025)),
                                            onTap: (){},
                                          ),
                                        ),
                                        Text(board.commentList.length.toString(), style: CustomTextStyle.w400(context, scale: 0.02))
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
                                      onLike: (BoardComment boardComment) async{
                                        final CommentLike? like = await repo.likeComment(context, comment_id: boardComment.commentId);
                                        if(like != null){
                                          setState(() {
                                            boardComment.commentLikeList.add(like);
                                          });
                                        }
                                      },
                                      onCommentDelete: () async{
                                        final BoardComment? bComment = await repo.deleteComment(context, comment_id: comment.commentId);
                                        if(bComment != null){
                                          setState(() {
                                            board.commentList.removeWhere((c) => c.commentId == bComment.commentId);
                                          });
                                        }
                                        controller.deleteComment(context, comment);
                                      },
                                      onNestedCommentDelete: (NestedComment nestedComment) async{
                                        final NestedComment? c = await repo.deleteNestedComment(context, nested_comment_id: nestedComment.id);
                                        if(c != null){
                                          setState(() {
                                            comment.nestedCommentList.removeWhere((com) => com.id == c.id);
                                          });
                                        }
                                      },
                                    )
                                  ]
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                ),
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
                  onPressed: () async{
                    if(_selectComment != null){
                      final int? statusCode = await repo.insertNestedComment(
                          context,
                          comment_id: _selectComment!.commentId,
                          comment: _commentController.text
                      );
                      if(statusCode != null){
                        controller.getBoard;
                      } else {
                        print('ho');
                      }
                    } else {
                      controller.insertComment(context, comment: _commentController.text);
                    }
                    setState(() {
                      _commentController.clear();
                      _selectComment == null;
                    });
                  },
                )
              ],
            ),
          ),
        ),
            onLoading: const LoadingView(message: '게시글을 불러오는 중입니다...'),
            onEmpty: Scaffold(
                appBar: AppBar(
                    title: const Text('삭제된 게시글')
                ),
                body: const EmptyView(message: '등록된 게시글이 삭제되었습니다.'))
        )
    );
  }
}
