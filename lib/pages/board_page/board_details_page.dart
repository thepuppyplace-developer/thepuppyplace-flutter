import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thepuppyplace_flutter/config/kakao_talk_config.dart';
import 'package:thepuppyplace_flutter/controllers/board/board_list_controller.dart';
import 'package:thepuppyplace_flutter/repositories/board/board_repository.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/enums.dart';
import 'package:thepuppyplace_flutter/util/error_messages.dart';
import 'package:thepuppyplace_flutter/views/photo_view/photo_list_view.dart';
import 'package:thepuppyplace_flutter/views/status/future_state_builder.dart';
import 'package:thepuppyplace_flutter/views/status/rx_status_view.dart';
import 'package:thepuppyplace_flutter/widgets/dialogs/custom_dialog.dart';
import 'package:thepuppyplace_flutter/widgets/images/custom_cached_network.image.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/Board.dart';
import '../../models/BoardComment.dart';
import '../../models/NestedComment.dart';
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

class _BoardDetailsPageState extends State<BoardDetailsPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final BoardRepository _repository = BoardRepository();
  final RefreshController _refreshController = RefreshController();
  final RxInt board_id = Get.arguments;
  Board? _board;
  FutureState _state = FutureState.loading;
  int _photoIndex = 0;
  BoardComment? _selectComment;
  NestedComment? _selectNestedComment;
  final TextEditingController _commentController = TextEditingController();

  Future get _getBoard => _repository.getBoard(board_id.value).then((res) {
    setState(() => _state = FutureState.loading);
    switch(res.statusCode){
      case 200:
        setState(() {
          _board = Board.fromJson(res.body['data']);
          _state = FutureState.success;
        });
        break;
      case 204:
        setState(() => _state = FutureState.empty);
        break;
      case null:
        setState(() => _state = FutureState.network);
    }
  }).catchError((error){
    setState(() => _state = FutureState.error);
    throw Exception(error);
  });

  Future _deleteBoard(BuildContext context)
  => _repository.deleteBoard(context, board_id: board_id.value).whenComplete(()
  => BoardListController.to.refreshBoardList());

  Future _likeBoard(BuildContext context) => _repository.likeBoard(context, board_id.value).whenComplete(()
  => _getBoard);

  Future _likeComment(BuildContext context, int comment_id) async{
    await _repository.likeComment(context, comment_id: comment_id);
    return _getBoard;
  }

  Future _insertComment(BuildContext context, {required String comment}) async{
    if(comment.trim().isNotEmpty){
      await _repository.insertComment(context, board_id: board_id.value, comment: comment);
      return _getBoard;
    } else {
      return showSnackBar(context, '댓글을 입력해주세요.');
    }
  }

  Future _insertNestNestComment(BuildContext context, {
    required String comment,
    required int nested_comment_id
  }) async{
    if(comment.trim().isNotEmpty){
      await _repository.insertNestNestComment(context, nested_comment_id: nested_comment_id, comment: comment);
      return _getBoard;
    } else {
      return showSnackBar(context, '댓글을 입력해주세요.');
    }
  }

  Future _deleteComment(BuildContext context, int comment_id) async{
    Get.back();
    await _repository.deleteComment(context, comment_id: comment_id);
    return _getBoard;
  }

  Future _insertNestedComment(BuildContext context, {required int comment_id, required String comment}) async{
    if(comment.trim().isNotEmpty){
      await _repository.insertNestedComment(context, comment_id: comment_id, comment: comment);
      return _getBoard;
    } else {
      return showSnackBar(context, '댓글을 입력해주세요.');
    }
  }

  Future _deleteNestedComment(BuildContext context, NestedComment comment) async{
    Get.back();
    final int? statusCode = await _repository.deleteNestedComment(context, nested_comment_id: comment.id);
    if(statusCode == 200){
      return _getBoard;
    }
  }

  Future _deleteNestNestComment(BuildContext context, NestNestComment comment) async{
    Get.back();
    final int? statusCode = await _repository.deleteNestNestComment(context, nest_nest_comment_id: comment.id);
    if(statusCode == 200){
      return _getBoard;
    }
  }

  @override
  void initState() {
    super.initState();
    _getBoard;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: (){
        unFocus(context);
      },
      child: Scaffold(
        appBar: _state != FutureState.success ? AppBar() : null,
        body: FutureStateBuilder<Board>(
          state: _state,
          object: _board,
          builder: (context, state, board) {
            switch(state){
              case FutureState.empty:
                return const EmptyView();
              case FutureState.network:
                return const ErrorView(ErrorMessages.network_please);
              case FutureState.success:
                return NestedScrollView(
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
                          onPressed: () => showIndicator(KakaoTalkConfig.kakaoShareToMobile(board)),
                        ),
                        if(compareMemberId(board.userId))CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: null,
                          child: PopupMenuButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
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
                                        showIndicator(_deleteBoard(context));
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
                            onRefresh: () => _getBoard.whenComplete((){
                              _refreshController.refreshCompleted(resetFooterState: true);
                            }),
                            header: CustomHeader(
                              builder: (BuildContext context, RefreshStatus? status) => RefreshContents(status),
                            ),
                            footer: _state != FutureState.success ? null : CustomFooter(
                              loadStyle: LoadStyle.ShowWhenLoading,
                              builder: (BuildContext context, LoadStatus? status) => LoadContents(status,
                                noMoreText: '마지막 댓글입니다.',
                              ),
                            ),
                            child: Scrollbar(
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
                                          Text(beforeDate(board.createdAt), style: CustomTextStyle.w500(context, color: CustomColors.hint, scale: 0.016))
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
                                              aspectRatio: 1/1,
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
                                              child: CustomCachedNetworkImage(
                                                photo,
                                                borderRadius: BorderRadius.circular(10),
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                              onPressed: (){
                                                Get.to(() => PhotoListView(board.board_photos, PhotoListType.cached, currentIndex: index,), fullscreenDialog: true);
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
                                    // Container(
                                    //   margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)).copyWith(bottom: mediaWidth(context, 0.033)),
                                    //   child: Text(board.description, style: CustomTextStyle.w400(context, scale: 0.015)),
                                    // ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.033)).copyWith(bottom: mediaWidth(context, 0.033)),
                                      child: Linkify(
                                        text: board.description,
                                        style: CustomTextStyle.w500(context),
                                        linkStyle: CustomTextStyle.w600(context, color: CustomColors.main).copyWith(decoration: TextDecoration.underline),
                                        onOpen: (link) => openURL(url: link.url),
                                      ),
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
                                                              showDialog(context: context, builder: (context) => LikeAnimation(CupertinoIcons.heart_fill, _likeBoard(context)));
                                                            },
                                                          );
                                                        } else {
                                                          return GestureDetector(
                                                            child: Icon(CupertinoIcons.heart_fill, color: CustomColors.main, size: mediaHeight(context, 0.025)),
                                                            onTap: (){
                                                              _likeBoard(context);
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
                                                Text(board.likeList.length.toString(), style: CustomTextStyle.w400(context, color: Colors.grey)),
                                                Container(
                                                  margin: EdgeInsets.symmetric(horizontal: mediaWidth(context, 0.02)),
                                                  child: GestureDetector(
                                                    child: Icon(CupertinoIcons.bubble_left, color: CustomColors.hint, size: mediaHeight(context, 0.025)),
                                                    onTap: (){},
                                                  ),
                                                ),
                                                Text('${commentCount(board.commentList)}', style: CustomTextStyle.w400(context, color: Colors.grey)),
                                              ],
                                            ),
                                          ),
                                          Text('조회수 ${board.view_count}', style: CustomTextStyle.w500(context, color: CustomColors.main, scale: 0.015))
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
                                                  _selectNestedComment = null;
                                                  _selectComment = boardComment;
                                                });
                                              },
                                              onNestedComment: (nestedComment){
                                                setState(() {
                                                  _selectComment = null;
                                                  _selectNestedComment = nestedComment;
                                                });
                                              },
                                              onLike: (BoardComment boardComment) => _likeComment(context, boardComment.commentId),
                                              onCommentDelete: () => _deleteComment(context, comment.commentId),
                                              onNestedCommentDelete: (NestedComment nestedComment) => showIndicator(_deleteNestedComment(context, nestedComment)),
                                              onNestNestCommentDelete: (NestNestComment nestNestComment) => showIndicator(_deleteNestNestComment(context, nestNestComment)),
                                            )
                                          ]
                                      ),
                                    ),
                                    SizedBox(height: mediaHeight(context, 0.1))
                                  ],
                                ),
                              ),
                            )
                        ),
                      ),
                      SafeArea(
                        top: false,
                        child: Column(
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
                            if(_selectNestedComment != null) Opacity(
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
                                                  text: _selectNestedComment!.user.nickname,
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
                                            _selectNestedComment = null;
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
                                  await _insertNestedComment(
                                      context,
                                      comment_id: _selectComment!.commentId,
                                      comment: comment
                                  );
                                  setState(() {});
                                }
                                if(_selectNestedComment != null){
                                  await _insertNestNestComment(
                                      context,
                                      nested_comment_id: _selectNestedComment!.id,
                                      comment: comment
                                  );
                                  setState(() {});
                                }
                                if(_selectComment == null && _selectNestedComment == null){
                                  await _insertComment(
                                      context,
                                      comment: comment
                                  );
                                }
                                setState(() {
                                  _selectComment = null;
                                  _selectNestedComment = null;
                                  _commentController.clear();
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              default :
                return const LoadingView();
            }
          }
        ),
      ),
    );
  }
}
