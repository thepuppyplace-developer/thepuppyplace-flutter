import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/models/BoardCategory.dart';
import 'package:thepuppyplace_flutter/pages/board_page/board_details_page.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../config/config.dart';
import '../../config/local_db.dart';
import '../../models/Board.dart';
import '../controllers/board/board_list_controller.dart';
import '../models/BoardComment.dart';
import '../models/LikeBoard.dart';
import '../models/NestedComment.dart';
import '../models/Search.dart';

class BoardRepository extends GetConnect with Config, LocalConfig{
  static BoardRepository get from => BoardRepository();

  Future insertBoard(BuildContext context, {
    required String title,
    required String description,
    required String location,
    required String category,
    required List<File> board_photos
  }) async{
    if(await jwt != null){
      Response res = await post('$API_URL/board/insert', FormData({
        'title': title.trim(),
        'description': description.trim(),
        'location': location.trim(),
        'category': category.trim(),
        'images': board_photos
      }), headers: headers(await jwt));

      switch(res.statusCode){
        case 201: {
          final Board? board = await getBoard(res.body['data']['id']);
          if(board != null){
            Get.offUntil(MaterialPageRoute(builder: (context) => BoardDetailsPage(board.id)), (route) => route.isFirst);
          } else {
            Get.until((route) => route.isFirst);
          }
          return showSnackBar(context, '게시글이 업로드되었습니다!');
        }
        case 204: {
          return unknown_message(context);
        }
        default: {
          return network_check_message(context);
        }
      }
    } else {
      return expiration_token_message(context);
    }
  }

  Future<List<LikeBoard>> getLikeBoardList(BuildContext context, int? user_id) async{
    try{
      if(await jwt != null){
        final Response res = await post('$API_URL/board/like', {
          'user_like_id': user_id
        });

        switch(res.statusCode){
          case 200: {
            return List.from(res.body['data']).map((board) => LikeBoard.fromJson(board)).toList();
          }
          default: {
            await network_check_message(context);
            return <LikeBoard>[];
          }
        }
      } else {
        await expiration_token_message(context);
        return <LikeBoard>[];
      }
    } catch(error) {
      throw unknown_message(context);
    }
  }

  Future<List<Search>> getPopularSearchList(BuildContext context) async{
    try{
      final Response res = await get('$API_URL/search');

      switch(res.statusCode){
        case 200: return List.from(res.body['data']).map((search) => Search.fromJson(search)).toList();
        default:
          await network_check_message(context);
          return <Search>[];
      }
    } catch(error){
      throw unknown_message(context);
    }
  }

  Future<List<Board>> getBoardList({required int page, String? category , String? order, int? userId, String? query}) async{
    final Response res = await post('$API_URL/board', {
      'page': page,
      'category': category,
      'order': order,
      'user_id': userId,
      'query': query
    });

    switch(res.statusCode){
      case 200: {
        return List.from(res.body['data']).map((board) => Board.fromJson(board)).toList();
      }
      default: {
        return [];
      }
    }
  }

  Future<Board?> getBoard(int board_id) async{
    final Response res = await get('$API_URL/board/$board_id');

    switch(res.statusCode){
      case 200: {
        return Board.fromJson(res.body['data']);
      }
      default: {
        return null;
      }
    }
  }

  Future deleteBoard(BuildContext context, {required int board_id}) async{
    if(await jwt != null){
      final Response res = await delete('$API_URL/board/${board_id}', headers: headers(await jwt));

      switch(res.statusCode){
        case 200: {
          BoardListController.to.refreshBoardList();
          Get.until((route) => route.isFirst);
          return showSnackBar(context, '게시글이 삭제되었습니다.');
        }
        case 204: {
          return unknown_message(context);
        }
        default: {
          return network_check_message(context);
        }
      }
    } else {
      return expiration_token_message(context);
    }
  }

  Future likeBoard(BuildContext context, int board_id) async{
    if(await jwt != null){
      Response res = await post('$API_URL/like/board/$board_id', {}, headers: headers(await jwt));
      switch(res.statusCode){
        case 200:
          return null;
        case 204:
          return unknown_message(context);
        default:
          return network_check_message(context);
      }
    } else {
      return expiration_token_message(context);
    }
  }

  Future insertComment(BuildContext context, {required int board_id, required String comment}) async{
    if(await jwt != null){
      Response res = await post('$API_URL/comment', {
        'board_id': board_id,
        'comment': comment.trim()
      }, headers: headers(await jwt));
      switch(res.statusCode){
        case 201:
          return showSnackBar(context, '댓글이 등록되었습니다.');
        case 204:
          return unknown_message(context);
        default:
          return network_check_message(context);
      }
    } else {
      return expiration_token_message(context);
    }
  }

  Future deleteComment(BuildContext context, {required int comment_id}) async{
    if(await jwt != null){
      final Response res = await delete('$API_URL/comment/$comment_id');

      switch(res.statusCode) {
        case 201:
          return showSnackBar(context, '댓글이 삭제되었습니다.');
        case 204:
          return unknown_message(context);
        default:
          return network_check_message(context);
      }
    } else {
      return expiration_token_message(context);
    }
  }

  Future insertNestedComment(BuildContext context, {required int comment_id, required String comment}) async{
    if(await jwt != null){
      Response res = await post('$API_URL/comment/nested', {
        'comment_id': comment_id,
        'comment': comment.trim()
      }, headers: headers(await jwt));
      switch(res.statusCode){
        case 201:
          return showSnackBar(context, '댓글이 등록되었습니다.');
        case 204:
          return unknown_message(context);
        default:
          return network_check_message(context);
      }
    } else {
      return expiration_token_message(context);
    }
  }

  Future deleteNestedComment(BuildContext context, {required int comment_id}) async{
    if(await jwt != null){
      final Response res = await delete('$API_URL/comment/nested/$comment_id');

      switch(res.statusCode) {
        case 201:
          return showSnackBar(context, '댓글이 삭제되었습니다.');
        case 204:
          return unknown_message(context);
        default:
          return network_check_message(context);
      }
    } else {
      return expiration_token_message(context);
    }
  }

  Future<List<BoardCategory>> getBoardCategory() async{
    final Response res = await get('$API_URL/board_category');

    switch(res.statusCode){
      case 200: return List.from(res.body['data']).map((category) => BoardCategory.fromJson(category)).toList();
      default: return <BoardCategory>[];
    }
  }
}