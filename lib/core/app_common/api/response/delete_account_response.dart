import 'dart:convert';

DeleteAccountResponse deleteAccountResponseFromMap(String str) => DeleteAccountResponse.fromMap(json.decode(str));

String deleteAccountResponseToMap(DeleteAccountResponse data) => json.encode(data.toMap());

class DeleteAccountResponse {
  DeleteAccountResponse({
    this.data,
    this.result,
  });

  final String? data;
  final DeleteResult? result;

  factory DeleteAccountResponse.fromMap(Map<String, dynamic> json) => DeleteAccountResponse(
    data: json["data"],
    result: json["result"] == null ? null : DeleteResult.fromMap(json["result"]),
  );

  Map<String, dynamic> toMap() => {
    "data": data,
    "result": result?.toMap(),
  };
}

class DeleteResult {
  DeleteResult({
    this.isError,
    this.status,
    this.errMsg,
  });

  final bool? isError;
  final int? status;
  final String? errMsg;

  factory DeleteResult.fromMap(Map<String, dynamic> json) => DeleteResult(
    isError: json["isError"],
    status: json["status"],
    errMsg: json["errMsg"],
  );

  Map<String, dynamic> toMap() => {
    "isError": isError,
    "status": status,
    "errMsg": errMsg,
  };
}
