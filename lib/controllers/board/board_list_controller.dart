import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/models/User.dart';

import '../../models/Board.dart';
import 'board_repository.dart';

class BoardListController extends GetxController with StateMixin<List<Board>>{
  final BoardRepository _repository = BoardRepository();

  final RxList<Board> _boardList = RxList(<Board>[]);

  @override
  void onReady() {
    super.onReady();
    ever(_boardList, _boardListListener);
    findAllBoard();
  }

  void _boardListListener(List<Board> boardList){
    try{
      change(null, status: RxStatus.loading());
      if(boardList.isNotEmpty){
        change(boardList, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future findAllBoard() async{
    List<Board> boardList = _boardList;
    _boardList.value = <Board>[
      Board(userId: 1, title: '강아지 카페 추천! 서울 대치동!', description: '서울 대치동에 있는 애견카페 다녀왓는데요~\n생긴지 얼마 안되서 그런지 엄청 깔끔하고 수제간식도 팔더라구요~\n공유하면 좋을 것 같아서 리부 가지고 왔습니다~^^', location: '경기도 고양시 일산동구', photoList: [], category: '카페', user: User(nickname: 'hpodong')),
      Board(userId: 1, title: '강아지 카페 추천! 서울 대치동!', description: '서울 대치동에 있는 애견카페 다녀왓는데요~\n생긴지 얼마 안되서 그런지 엄청 깔끔하고 수제간식도 팔더라구요~\n공유하면 좋을 것 같아서 리부 가지고 왔습니다~^^', location: '경기도 고양시 일산동구', photoList: [], category: '카페', user: User(nickname: 'hpodong')),
      Board(userId: 1, title: '강아지 카페 추천! 서울 대치동!', description: '서울 대치동에 있는 애견카페 다녀왓는데요~\n생긴지 얼마 안되서 그런지 엄청 깔끔하고 수제간식도 팔더라구요~\n공유하면 좋을 것 같아서 리부 가지고 왔습니다~^^', location: '경기도 고양시 일산동구', photoList: [], category: '카페', user: User(nickname: 'hpodong')),
      Board(userId: 1, title: '강아지 카페 추천! 서울 대치동!', description: '서울 대치동에 있는 애견카페 다녀왓는데요~\n생긴지 얼마 안되서 그런지 엄청 깔끔하고 수제간식도 팔더라구요~\n공유하면 좋을 것 같아서 리부 가지고 왔습니다~^^', location: '경기도 고양시 일산동구', photoList: [], category: '카페', user: User(nickname: 'hpodong')),
      Board(userId: 1, title: '강아지 카페 추천! 서울 대치동!', description: '서울 대치동에 있는 애견카페 다녀왓는데요~\n생긴지 얼마 안되서 그런지 엄청 깔끔하고 수제간식도 팔더라구요~\n공유하면 좋을 것 같아서 리부 가지고 왔습니다~^^', location: '경기도 고양시 일산동구', photoList: [], category: '카페', user: User(nickname: 'hpodong')),
      Board(userId: 1, title: '강아지 카페 추천! 서울 대치동!', description: '서울 대치동에 있는 애견카페 다녀왓는데요~\n생긴지 얼마 안되서 그런지 엄청 깔끔하고 수제간식도 팔더라구요~\n공유하면 좋을 것 같아서 리부 가지고 왔습니다~^^', location: '경기도 고양시 일산동구', photoList: [], category: '카페', user: User(nickname: 'hpodong')),
      Board(userId: 1, title: '강아지 카페 추천! 서울 대치동!', description: '서울 대치동에 있는 애견카페 다녀왓는데요~\n생긴지 얼마 안되서 그런지 엄청 깔끔하고 수제간식도 팔더라구요~\n공유하면 좋을 것 같아서 리부 가지고 왔습니다~^^', location: '경기도 고양시 일산동구', photoList: [], category: '카페', user: User(nickname: 'hpodong')),
      Board(userId: 1, title: '강아지 카페 추천! 서울 대치동!', description: '서울 대치동에 있는 애견카페 다녀왓는데요~\n생긴지 얼마 안되서 그런지 엄청 깔끔하고 수제간식도 팔더라구요~\n공유하면 좋을 것 같아서 리부 가지고 왔습니다~^^', location: '경기도 고양시 일산동구', photoList: [], category: '카페', user: User(nickname: 'hpodong')),
      Board(userId: 1, title: '강아지 카페 추천! 서울 대치동!', description: '서울 대치동에 있는 애견카페 다녀왓는데요~\n생긴지 얼마 안되서 그런지 엄청 깔끔하고 수제간식도 팔더라구요~\n공유하면 좋을 것 같아서 리부 가지고 왔습니다~^^', location: '경기도 고양시 일산동구', photoList: [], category: '카페', user: User(nickname: 'hpodong')),
      Board(userId: 1, title: '강아지 카페 추천! 서울 대치동!', description: '서울 대치동에 있는 애견카페 다녀왓는데요~\n생긴지 얼마 안되서 그런지 엄청 깔끔하고 수제간식도 팔더라구요~\n공유하면 좋을 것 같아서 리부 가지고 왔습니다~^^', location: '경기도 고양시 일산동구', photoList: [], category: '카페', user: User(nickname: 'hpodong')),
      Board(userId: 1, title: '강아지 카페 추천! 서울 대치동!', description: '서울 대치동에 있는 애견카페 다녀왓는데요~\n생긴지 얼마 안되서 그런지 엄청 깔끔하고 수제간식도 팔더라구요~\n공유하면 좋을 것 같아서 리부 가지고 왔습니다~^^', location: '경기도 고양시 일산동구', photoList: [], category: '카페', user: User(nickname: 'hpodong')),
    ];
    // _boardList.value = await _repository.findAllBoard();
  }
}