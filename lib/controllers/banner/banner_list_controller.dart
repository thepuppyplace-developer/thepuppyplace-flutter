import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/models/BannerModel.dart';
import 'package:thepuppyplace_flutter/repositories/banner/banner_repo.dart';

class BannerListController extends GetxController with StateMixin<List<BannerModel>>{
  final _repo = BannerRepo();

  final RxList<BannerModel> _bannerList = RxList<BannerModel>();

  @override
  void onReady(){
    super.onReady();
    ever(_bannerList, _bannerListListener);
    getBannerList;
  }

  void _bannerListListener(List<BannerModel> bannerList){
    change(null, status: RxStatus.loading());
    try{
      if(bannerList.isNotEmpty){
        change(bannerList, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future get getBannerList async{
    try{
      final Response res = await _repo.getBannerList;
      switch(res.statusCode){
        case 200:
          _bannerList.value = List.from(res.body['data']).map((banner) => BannerModel.fromJson(banner)).toList();
          break;
      }
    } catch(error){
      throw Exception(error);
    }
  }
}