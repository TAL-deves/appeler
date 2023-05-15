import 'package:dio/dio.dart';

class CustomDioError extends DioError{
  CustomDioError({
    required super.requestOptions,
    super.error,
    super.message,
    super.response,
    super.stackTrace,
    super.type,
  });

  @override
  String toString() {
    final errorType = super.type;
    switch (errorType) {
      case DioErrorType.cancel: return "Request to server was cancelled!";
      case DioErrorType.connectionTimeout: return "Connection timeout with server!";
      case DioErrorType.receiveTimeout: return "Receive timeout in connection with server!";
      case DioErrorType.sendTimeout: return "Send timeout in connection with server!";
      case DioErrorType.unknown: return 'Failed to connect with server!';
      case DioErrorType.connectionError: return 'Connection error occurred!';
      case DioErrorType.badCertificate: return 'Bad certificate!';
      case DioErrorType.badResponse: return 'Bad response!';
      default: return 'Unknown error!';
    }
  }


}
