import 'Board.dart';

class LikeBoard{
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int board_id;
  final int user_id;
  final Board board;

  LikeBoard({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.board_id,
    required this.user_id,
    required this.board,
  });

  factory LikeBoard.fromJson(Map<String, dynamic> json) => LikeBoard(
    id: json['id'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    board_id: json['board_id'],
    user_id: json['user_id'],
    board: Board.fromJson(json['Board']),
  );
}