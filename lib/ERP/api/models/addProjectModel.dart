class BaseResponse {
  String? code;
  String? massage;
  String? prijectId;
  String? otp;
  String? gen_no;
  String? grn_no;

  BaseResponse({
    this.code,
    this.massage,
    this.prijectId,
    this.otp,
    this.gen_no,
    this.grn_no,
  });

  // Convert JSON map to BaseResponse object
  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      code: json['code']?.toString(),
      massage: json['massage']?.toString(),
      prijectId: json['prijectId']?.toString(),
      otp: json['otp']?.toString(),
      gen_no: json['gen_no']?.toString(),
      grn_no: json['grn_no']?.toString(),
    );
  }

  // Convert BaseResponse object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'massage': massage,
      'prijectId': prijectId,
      'otp': otp,
      'gen_no': gen_no,
      'grn_no': grn_no,
    };
  }
}
