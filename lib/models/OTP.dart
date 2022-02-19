class OTP{
  String? otpId, email, otpCode;
  DateTime? createAt, updateAt;

  OTP({
    this.otpId,
    this.email,
    this.otpCode,
    this.createAt,
    this.updateAt
  });

  factory OTP.fromJson(Map<String, dynamic> json) => OTP(
    otpId: json['_id'],
    email: json['email'],
    otpCode: json['otpCode'],
    createAt: DateTime(json['createAt']).toLocal(),
    updateAt: DateTime(json['updateAt']).toLocal(),
  );

  Map<String, dynamic> toJson() => {
    '_id': otpId,
    'email': email,
    'otpCode': otpCode,
    'createAt': createAt,
    'updateAt': updateAt,
  };
}