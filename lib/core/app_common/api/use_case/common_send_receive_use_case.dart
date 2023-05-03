import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../index.dart';

abstract class CommonSendReceiveUseCase<R> {
  final Dio dio;
  final String apiPath;

  CommonSendReceiveUseCase({required this.apiPath, required this.dio});

  Future<R> getData(String? sendDataString) async {
    print('sent format: $sendDataString    api: $apiPath');
    final curData =
        await AppEncryptionUtilities.getPostMapForApi(sendDataString);
    //print('sent enc format: $curData    api: $apiPath');
    try {
      final responseData = (await dio.post(apiPath, data: curData)).data;
      return onCompute(responseData);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<R> onCompute(String responseData);
}
