import 'dart:convert';

CommonReceiveResponse commonResponseFromMap(String str) => CommonReceiveResponse.fromMap(json.decode(str));

String commonResponseToMap(CommonReceiveResponse data) => json.encode(data.toMap());

class CommonReceiveResponse {
  CommonReceiveResponse({
    this.data,
    this.result,
  });

  final String? data;
  final CommonResult? result;

  factory CommonReceiveResponse.fromMap(Map<String, dynamic> json) => CommonReceiveResponse(
    data: json["data"],
    result: CommonResult.fromMap(json["result"]),
  );

  Map<String, dynamic> toMap() => {
    "data": data,
    "result": result?.toMap(),
  };
}

class CommonResult {
  CommonResult({
    this.isError,
    this.status,
    this.errMsg,
  });

  final bool? isError;
  final int? status;
  final String? errMsg;

  factory CommonResult.fromMap(Map<String, dynamic> json) => CommonResult(
    isError: json["isError"],
    status: json["status"],
    errMsg: json["errMsg"] ?? json['errorMsg'],
  );

  Map<String, dynamic> toMap() => {
    "isError": isError,
    "status": status,
    "errMsg": errMsg,
  };
}
