import 'dart:convert' as converter;

import '../../../../index.dart';

class SignUpResponse {
  final bool? _success;
  final dynamic _data;
  final bool? _isError;
  final HttpError? _error;
  final String? _errMsg;

  bool get isSuccessful => _success ?? false;

  bool get isError => _isError ?? false;

  String get errorMessage => _errMsg ?? "";

  dynamic get data => _data;

  HttpError get error => _error ?? const HttpError();

  const SignUpResponse({
    bool? success,
    dynamic data,
    bool? isError,
    HttpError? error,
    String? errMsg,
  })  : _errMsg = errMsg,
        _error = error,
        _isError = isError,
        _data = data,
        _success = success;

  SignUpResponse copy({
    bool? success,
    dynamic data,
    bool? isError,
    HttpError? error,
    String? errMsg,
  }) {
    return SignUpResponse(
      success: success ?? _success,
      data: data ?? _data,
      isError: isError ?? _isError,
      error: error ?? _error,
      errMsg: errMsg ?? _errMsg,
    );
  }

  factory SignUpResponse.from(dynamic data) {
    var source = {};
    if (data is String) {
      source = converter.jsonDecode(data);
    }
    if (data is Map<String, dynamic>) {
      source = data;
    }
    return SignUpResponse(
      success: source["success"],
      data: source["data"],
      isError: source["isError"],
      errMsg: source["errMsg"],
      error: HttpError.from(source["error"]),
    );
  }

  Map<String, dynamic> get source {
    return {
      "success": _success,
      "data": _data,
      "isError": _isError,
      "error": _error?.source,
      "errMsg": _errMsg,
    };
  }

  String get json => converter.jsonEncode(source);
}
