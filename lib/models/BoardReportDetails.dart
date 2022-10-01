import 'dart:convert';

import 'package:thepuppyplace_flutter/models/BoardItem.dart';
import 'package:thepuppyplace_flutter/models/MemberItem.dart';
import 'package:thepuppyplace_flutter/models/UserNicknameAndPhotoURL.dart';
import 'package:thepuppyplace_flutter/util/enums.dart';

class BoardReportDetails{
  final int id;
  final int boardId;
  final ReportType type;
  final String description;
  final UserNicknameAndPhotoURL targetMember;
  final UserNicknameAndPhotoURL reportMember;
  final BoardItem board;
  final DateTime createdAt;
  final DateTime updatedAt;

  BoardReportDetails({
    required this.id,
    required this.boardId,
    required this.type,
    required this.description,
    required this.targetMember,
    required this.reportMember,
    required this.board,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BoardReportDetails.fromJson(Map<String, dynamic> json) {

    ReportType _typeFromInt(int value) {
      switch(value){
        case 1: return ReportType.abuse;
        case 2: return ReportType.deference;
        case 3: return ReportType.illegality;
        case 4: return ReportType.service;
        case 5: return ReportType.infringement;
        default: return ReportType.others;
      }
    }

    return BoardReportDetails(
      id: json['id'],
      boardId: json['board_id'],
      type: _typeFromInt(json['report_type']),
      description: json['report_body'],
      targetMember: UserNicknameAndPhotoURL.fromJson(jsonDecode(json['target_user_info_json'])),
      reportMember: UserNicknameAndPhotoURL.fromJson(jsonDecode(json['report_user_info_json'])),
      board: BoardItem.fromJson(jsonDecode(json['board_info_json'])),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}