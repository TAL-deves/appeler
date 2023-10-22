import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'socket_connection.dart';

abstract interface class RealTimeRepository{

  Future<Map<String, dynamic>> read({required String path});
  Future<Map<String, dynamic>> set({required String path, required Map<String, dynamic> data});
  Future<Map<String, dynamic>> update({required String path, required Map<String, dynamic> data});
  Future<Map<String, dynamic>> delete({required String path});
  Future<Map<String, dynamic>> emitOnSocket({required String path});

  RealTimeRepository._();

  static RealTimeRepository? _instance;

  static RealTimeRepository get instance => _instance ??= _RealtimeRepositoryImp();

  static void dispose(){ _instance = null; }
}

class _RealtimeRepositoryImp with _CommonApiWork implements RealTimeRepository{

  @override
  Future<Map<String, dynamic>> delete({required String path}) {
    return _apiHeat(path: path, actionType: 1);
  }

  @override
  Future<Map<String, dynamic>> emitOnSocket({required String path}) {
    return _apiHeat(path: path, actionType: 2);
  }

  @override
  Future<Map<String, dynamic>> read({required String path}) {
    return _apiHeat(path: path, actionType: 3);
  }

  @override
  Future<Map<String, dynamic>> set({required String path, required Map<String, dynamic> data}) {
    return _apiHeat(path: path, actionType: 0, data: data);
  }

  @override
  Future<Map<String, dynamic>> update({required String path, required Map<String, dynamic> data}) {
    return _apiHeat(path: path, actionType: 4, data: data);
  }
}

mixin _CommonApiWork{
  final _dio = Dio(
    BaseOptions(
      baseUrl: SocketConnection.baseUrlSocket,
      responseType: ResponseType.plain,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      validateStatus: (status) => status! < 500,
    ),
  );

  Future<Map<String, dynamic>> _apiHeat({required String path, dynamic data, required int actionType}) async{
    try{
      final response = await _dio.post(
        '/realtime',
        data: {
          'path': path,
          'action': actionType,
          'data': data
        },
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return compute(_parseJsonDecode, response.data as String);
      }
      else { return Future.error({'statusCode': response.statusCode}); }
    }
    catch(e){ return Future.error({'error': e.toString()}); }
  }

  static Future<Map<String, dynamic>> _parseJsonDecode(String responseData) async{
    return jsonDecode(responseData);
  }

}