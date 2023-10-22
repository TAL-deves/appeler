import 'realtime_repository.dart';
import 'socket_connection.dart';

abstract class RealTimeDB{
  void dispose();
  factory RealTimeDB.fromPath({required String path, required Function(Map<String, dynamic>) onGetData}){
    return _RealTimeDBImp(path, onGetData);
  }
}

class _RealTimeDBImp implements RealTimeDB{
  final String path;
  final Function(Map<String, dynamic>) onGetData;

  _RealTimeDBImp(this.path, this.onGetData){
    RealTimeRepository.instance.read(path: path).then((value){
      onGetData.call(value);
      SocketConnection.socket.on(path, (data){ onGetData.call(data); });
    });
  }

  @override
  void dispose() { SocketConnection.socket.off(path); }

}
