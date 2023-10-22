import '../../index.dart';

class SdkHelper {
  const SdkHelper._();

  static Future<String> createRoom({int minutes = 15}) {
    return AnalyticaRTC.roomWork.autoCreateRoomId(minutes: minutes);
  }
}
