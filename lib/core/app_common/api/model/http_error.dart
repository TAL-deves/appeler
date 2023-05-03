import 'dart:convert' as converter;

class HttpError {
  final int? _code;
  final String? _message;

  const HttpError({
    int? code,
    String? message,
  })  : _message = message,
        _code = code;

  HttpError copy({
    int? code,
    String? message,
  }) {
    return HttpError(
      code: code ?? _code,
      message: message ?? _message,
    );
  }

  factory HttpError.from(dynamic data) {
    var source = {};
    if (data is String) {
      source = converter.jsonDecode(data);
    }
    if (data is Map<String, dynamic>) {
      source = data;
    }
    return HttpError(
      code: source["code"],
      message: source["message"],
    );
  }

  Map<String, dynamic> get source {
    return {
      "code": _code,
      "message": _message,
    };
  }

  String get json => converter.jsonEncode(source);
}
