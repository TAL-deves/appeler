library analytica_rtc;

import 'dart:developer' show log;

import 'package:wakelock/wakelock.dart';

import 'realtime_repository.dart' show RealTimeRepository;
import 'realtime_socket.dart';
import 'room_work.dart';
import 'socket_connection.dart';
import 'use_cases.dart' show checkValidationUseCase;

export 'realtime_repository.dart' hide RealTimeRepository;
export 'realtime_socket.dart';
export 'room_work.dart' show RoomWork;
export 'socket_connection.dart' hide SocketConnection;

class AnalyticaRTC {
  static String appId = '';
  static String token = '';

  AnalyticaRTC._();

  static void init({
    required String appId,
    required String token,
  }) {
    AnalyticaRTC.appId = appId;
    AnalyticaRTC.token = token;
    Wakelock.enable();
    SocketConnection.init();
    _sdkValidate();
  }

  static void _sdkValidate() async {
    try {
      final response = await checkValidationUseCase.checkValidation();
      //final featureList = response.encoded?.data?.details?.features;
      log(response.toString());
      log('Credential validated!');
      // if(featureList != null){
      //   log([featureList.map((e) => e.toMap())].toString());
      // }
    } catch (e) {
      log(e.toString());
    }
  }

  static void dispose() {
    SocketConnection.dispose();
    RealTimeRepository.dispose();
    RoomWork.dispose();
  }

  static RealTimeRepository repository = RealTimeRepository.instance;

  static RoomWork roomWork = RoomWork.instance;

  static RealTimeDB getRealTimeDB({
    required String path,
    required Function(Map<String, dynamic>) onGetData,
  }) {
    return RealTimeDB.fromPath(path: path, onGetData: onGetData);
  }
}
