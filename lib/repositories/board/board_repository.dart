import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thepuppyplace_flutter/models/BoardCategory.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import '../../../config/config.dart';
import '../../../models/Board.dart';
import '../../controllers/board/board_list_controller.dart';
import '../../models/BoardComment.dart';
import '../../models/CommentLike.dart';
import '../../models/LikeBoard.dart';
import '../../models/Search.dart';

class BoardRepository extends GetConnect with Config{
  static BoardRepository get from => BoardRepository();

  Future insertBoard(BuildContext context, {
    required String title,
    required String description,
    required String location,
    required String category,
    required List<XFile?> photoList
  }) async{
    if(await JWT_TOKEN != null){
      final FormData formData = FormData({
        'title': title.trim(),
        'description': description.trim(),
        'location': location.trim(),
        'category': category.trim(),
      });

      for(XFile? photo in photoList){
        if(photo != null){
          formData.files.addAll([
            MapEntry('images', MultipartFile(await photo.readAsBytes(), filename: photo.path))
          ]);
        }
      }

      final Response res = await post('$API_URL/board/insert', formData, headers: await headers);

      switch(res.statusCode){
        case 201: {
          Get.until((route) => route.isFirst);
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

  Future updateBoard(BuildContext context, {
    required int board_id,
    required String title,
    required String description,
    required String category,
}) async{
    try{
      if(await JWT_TOKEN != null){
        final Response res = await patch('$API_URL/board/$board_id', {
          'title': title.trim(),
          'description': description.trim(),
          'category': category.trim(),
        }, headers: await headers);


        switch(res.statusCode){
          case 200:
            await showSnackBar(context, '게시글이 업데이트 되었습니다.');
            return Get.until((route) => route.isFirst);
          default: return network_check_message(context);
        }
      } else {
        return expiration_token_message(context);
      }
    } catch(error){
      throw unknown_message(context);
    }
  }

  Future<List<LikeBoard>> getLikeBoardList(BuildContext context, int? user_id) async{
    try{
      if(await JWT_TOKEN != null){
        final Response res = await post('$API_URL/board/like', {
          'like_user_id': user_id
        });
        switch(res.statusCode){
          case 200: {
            return List.from(res.body['data']).map((board) => LikeBoard.fromJson(board)).toList();
          }
          case 204: {
            return <LikeBoard>[];
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
      final Response res = await get('$API_URL/search/top');

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

  Future<Response> getSearchBoardList({required String? query, required String? queryType, required String? order}) async{
    final Response res = await post('$API_URL/board', {
      'query': query,
      'order': order,
      'queryType': queryType
    });
    return res;
  }

  Future<List<Board>> getBoardList({int? page, int? limit,  String? category , String? order, int? userId, String? query, String? queryType}) async{
    final Response res = await post('$API_URL/board', {
      'page': page,
      'category': category,
      'order': order,
      'user_id': userId,
      'query': query,
      'limit': limit,
      'queryType': queryType
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
    if(await JWT_TOKEN != null){
      final Response res = await delete('$API_URL/board/${board_id}', headers: await headers);

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
    if(await JWT_TOKEN != null){
      Response res = await post('$API_URL/like/board/$board_id', {}, headers: await headers);
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
    if(await JWT_TOKEN != null){
      Response res = await post('$API_URL/comment', {
        'board_id': board_id,
        'comment': comment.trim()
      }, headers: await headers);
      print(res.body);
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

  Future<BoardComment?> deleteComment(BuildContext context, {required int comment_id}) async{
    try{
      if(await JWT_TOKEN != null){
        final Response res = await delete('$API_URL/comment/$comment_id', headers: await headers);

        switch(res.statusCode) {
          case 200:
            await showSnackBar(context, '댓글이 삭제되었습니다.');
            return res.body['data'];
          case 204:
            await unknown_message(context);
            return null;
          default:
            await network_check_message(context);
            return null;
        }
      } else {
        await expiration_token_message(context);
        return null;
      }
    } catch(error){
      throw unknown_message(context);
    }
  }

  Future<CommentLike?> likeComment(BuildContext context, {required int comment_id}) async{
    try{
      if(await JWT_TOKEN != null){
        final Response res = await post('$API_URL/like/comment/$comment_id', {}, headers: await headers);

        switch(res.statusCode) {
          case 200:
            return CommentLike.fromJson(res.body['data']);
          default:
            await network_check_message(context);
            return null;
        }
      } else {
        await expiration_token_message(context);
        return null;
      }
    } catch(error){
      await unknown_message(context);
      throw Exception(error);
    }
  }

  Future<int?> insertNestedComment(BuildContext context, {required int comment_id, required String comment}) async{
    if(await JWT_TOKEN != null){
      Response res = await post('$API_URL/comment/nested', {
        'comment': comment.trim(),
        'comment_id': comment_id,
      }, headers: await headers);
      switch(res.statusCode){
        case 201:
          await showSnackBar(context, '댓글이 등록되었습니다.');
          return res.statusCode;
        case 204:
          await unknown_message(context);
          return res.statusCode;
        default:
          await network_check_message(context);
          return res.statusCode;
      }
    } else {
      await expiration_token_message(context);
      return null;
    }
  }

  Future<int?> deleteNestedComment(BuildContext context, {required int nested_comment_id}) async{
    if(await JWT_TOKEN != null){
      final Response res = await delete('$API_URL/comment/nested/$nested_comment_id', headers: await headers);
      print(res.statusCode);
      switch(res.statusCode) {
        case 200:
          await showSnackBar(context, '댓글이 삭제되었습니다.');
          return res.statusCode;
        case 204:
          await unknown_message(context);
          return null;
        default:
          await network_check_message(context);
          return null;
      }
    } else {
      await expiration_token_message(context);
      return null;
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