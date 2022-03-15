import 'package:get/get.dart';

import '../../../models/Board.dart';
import 'board_repository.dart';

class BoardController extends GetxController with StateMixin<Board>{
  final BoardRepository _repository = BoardRepository();

  final Rxn<Board> _board = Rxn<Board>();


}