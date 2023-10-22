import 'dart:convert';
import 'validation_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

final ValidationRepository validationRepository = _ValidationRepositoryImp();

abstract class ValidationRepository {
  Future<ValidationResponse> checkValidation({required String appId, required String token});
  Future<String> createRoom({required String appId, required String token, required String roomId, required int minutes});
  Future<String> joinLeaveRoom({required String appId, required String token, required String roomId, required String userId, required int type});
  Future<String> deleteRoom({required String appId, required String token, required String roomId});
}

class _ValidationRepositoryImp implements ValidationRepository {
  //static const _baseUrl = 'http://139.59.55.201:6001';
  static const _baseUrl = 'https://analyticartc.techanalyticaltd.com/rtc-service';

  final _dio = Dio(
    BaseOptions(
      baseUrl: '$_baseUrl/sdkaction',
      responseType: ResponseType.plain,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      validateStatus: (status) => status! < 500,
    ),
  );

  @override
  Future<ValidationResponse> checkValidation({required String appId, required String token}) async {
    try {
      final response = await _dio.post(
        '/check',
        queryParameters: {'option': 'details'},  //option: balance is another query
        data: {'appid': appId, 'token': token},
      );
      if (response.statusCode == 200) {
        return compute((responseData) => ValidationResponse.fromMap(jsonDecode(responseData)), response.data);
      }
      else { return Future.error('Invalid Credentials! Please check app Id and token'); }
    }
    catch (e) { return Future.error('Something wrong!'); }
  }

  @override
  Future<String> createRoom({required String appId, required String token, required String roomId, required int minutes}) async{
    try {
      final response = await _dio.post(
        '/room',
        data: {'appid': appId, 'token': token, 'roomid': roomId, 'duration': minutes},
      );
      if (response.statusCode == 200) { return response.data; }
      else{
        final curMap = await compute((data) => jsonDecode(data), response.data);
        return Future.error(curMap['encoded']['error']['errMsg']);
      }
    }
    catch (e) { return Future.error('Something wrong!'); }
  }

  @override
  Future<String> joinLeaveRoom({required String appId, required String token, required String roomId, required String userId, required int type}) async{
    try {
      final actionType = type == 0 ? 'join': 'leave';
      final response = await _dio.patch(
        '/room',
        data: {
          'appid': appId,
          'token': token,
          'roomid': roomId,
          'participant': {
            userId : { actionType: DateTime.now().toIso8601String() }
          }
        },
        queryParameters: { 'action':  actionType}
      );
      if (response.statusCode == 200) { return response.data; }
      else{
        final curMap = await compute((data) => jsonDecode(data), response.data);
        return Future.error(curMap['encoded']['error']['errMsg']);
      }
    }
    catch (e) { return Future.error('Something wrong!'); }
  }

  @override
  Future<String> deleteRoom({required String appId, required String token, required String roomId}) async{
    try {
      final response = await _dio.delete('/room', data: {'appid': appId, 'token': token, 'roomid': roomId});
      if (response.statusCode == 200) { return response.data; }
      else{
        final curMap = await compute((data) => jsonDecode(data), response.data);
        return Future.error(curMap['encoded']['error']['errMsg']);
      }
    }
    catch (e) { return Future.error('Something wrong!'); }
  }
}
