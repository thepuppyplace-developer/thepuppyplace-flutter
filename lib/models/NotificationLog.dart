class NotificationLog{
  final int id;
  final String log_body;
  final String log_action_type;
  final String log_action;
  final int log_action_id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int user_id;

  NotificationLog({
    required this.id,
    required this.log_body,
    required this.log_action_type,
    required this.log_action,
    required this.log_action_id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.user_id,
  });

  factory NotificationLog.fromJson(Map<String, dynamic> json) => NotificationLog(
      id: json[ID],
      log_body: json[LOG_BODY],
      log_action_type: json[LOG_ACTION_TYPE],
      log_action: json[LOG_ACTION],
      log_action_id: json[LOG_ACTION_ID].runtimeType == int ? json[LOG_ACTION_ID] : int.parse(json[LOG_ACTION_ID]),
      createdAt: DateTime.parse(json[CREATED_AT]),
      updatedAt: DateTime.parse(json[UPDATED_AT]),
      deletedAt: json[DELETED_AT] == null ? null : DateTime.parse(json[DELETED_AT]),
      user_id: json[USER_ID]
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    ID: id,
    LOG_BODY: log_body,
    LOG_ACTION_TYPE: log_action_type,
    LOG_ACTION: log_action,
    LOG_ACTION_ID: log_action_id,
    CREATED_AT: createdAt.toIso8601String(),
    UPDATED_AT: updatedAt.toIso8601String(),
    DELETED_AT: deletedAt == null ? null : deletedAt!.toIso8601String(),
    USER_ID: user_id,
  };

  static String TABLE = 'NotificationLog';

  static String ID = 'id';
  static String LOG_BODY = 'log_body';
  static String LOG_ACTION_TYPE = 'log_action_type';
  static String LOG_ACTION = 'log_action';
  static String LOG_ACTION_ID = 'log_action_id';
  static String CREATED_AT = 'createdAt';
  static String UPDATED_AT = 'updatedAt';
  static String DELETED_AT = 'deletedAt';
  static String USER_ID = 'user_id';
}