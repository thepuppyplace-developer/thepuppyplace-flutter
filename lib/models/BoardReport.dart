import 'package:thepuppyplace_flutter/util/enums.dart';

class BoardReport{
  final int id;
  final ReportType type;
  final String description;

  BoardReport({
    required this.id,
    required this.type,
    required this.description,
  });

  factory BoardReport.fromJson(Map<String, dynamic> json) {

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

    return BoardReport(
      id: json['id'],
      type: _typeFromInt(json['report_type']),
      description: json['report_body'],
    );
  }
}