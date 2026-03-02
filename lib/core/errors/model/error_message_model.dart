class ErorrMessageModel {
  final int statusCode;
  final String statusMessage;
  final bool success;
  final bool? isVerfiedPhone;
  ErorrMessageModel({
    required this.statusCode,
    required this.statusMessage,
    required this.success,
    this.isVerfiedPhone,
  });

  factory ErorrMessageModel.fromJson(Map<String, dynamic> json) {
    return ErorrMessageModel(
      isVerfiedPhone: json['isPhoneVerified'],
      statusCode: json['status_code'] ?? 0,
      statusMessage: json['message'] ?? json['messageAr'] ?? 'Unknown error',
      success: json['success'] ?? false,
    );
  }
}
