import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:appeler/feature/presentation/pages/meeting/local_user.dart';
import 'package:appeler/feature/presentation/pages/meeting/meeting_view.dart';
import 'package:appeler/feature/presentation/pages/meeting/remote_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../../index.dart';
import 'dart:io';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  int _eventCount = 0;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;
    final customData = await FlutterForegroundTask.getData<String>(key: 'customData');
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    print('customData: $customData');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    FlutterForegroundTask.updateService(
      notificationTitle: 'Foreground Service',
      notificationText: 'Service event: $_eventCount',
    );

    sendPort?.send(_eventCount);

    _eventCount++;
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    print('onButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }
}

class MeetingFragment extends StatefulWidget {
  final MeetingInfo info;

  const MeetingFragment({
    super.key,
    required this.info,
  });

  @override
  State<MeetingFragment> createState() => MeetingFragmentState();
}

class MeetingFragmentState extends State<MeetingFragment> with WidgetsBindingObserver{
  late final controller = context.read<MeetingController>();
  late bool isCameraOn = widget.info.isCameraOn;
  late bool isMute = widget.info.isMuted;
  late bool isFrontCamera = widget.info.isFrontCamera;
  late bool isShareScreen = widget.info.isShareScreen;
  late SizeConfig config = SizeConfig.of(context, size: Size.zero);
  bool isRiseHand = false;
  bool isReserveMode = true;
  int crossAxisCount = 2;

  final _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;

  final _keyMap = <String, GlobalKey>{};
  final _widgetMap = <String, Widget>{};
  final _addedUser = <String>{};

  StreamSubscription? _roomSubs, _hostSubs;

  Future<MediaStream> get _getUserMediaStream async {
    final mp = <String, dynamic>{
      'audio': true,
      'video': kIsWeb
          ? {'facingMode': 'user'}
          : {
              'width': '320',
              'height': '240',
              'frameRate': '30',
              'facingMode': 'user',
              'optional': [],
            }
    };
    final mediaDevices = navigator.mediaDevices;
    final stream = await (isShareScreen ? mediaDevices.getDisplayMedia(mp) : mediaDevices.getUserMedia(mp));
    return stream;
  }

  ReceivePort? _receivePort;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('App state is: $state');
  }

  Future<void> _requestPermissionForAndroid() async {
    if (!Platform.isAndroid) {
      return;
    }

    if (!await FlutterForegroundTask.canDrawOverlays) {
      await FlutterForegroundTask.openSystemAlertWindowSettings();
    }

    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    final NotificationPermission notificationPermissionStatus = await FlutterForegroundTask.checkNotificationPermission();

    if (notificationPermissionStatus != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        id: 500,
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
        'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
          backgroundColor: Colors.orange,
        ),
        buttons: [
          const NotificationButton(id: 'sendButton', text: 'Send'),
          const NotificationButton(id: 'testButton', text: 'Test'),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<bool> _startForegroundTask() async {
    await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      print('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }
  }

  Future<bool> _stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((data) {
      if (data is int) {
        print('eventCount: $data');
      } else if (data is String) {
        if (data == 'onNotificationPressed') {
          //Navigator.of(context).pushNamed('/resume-route');
        }
      } else if (data is DateTime) {
        print('timestamp: ${data.toString()}');
      }
    });

    return _receivePort != null;
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  @override
  void initState() {
    print('meeting fragment is called');
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   if(!kIsWeb){
    //     await _requestPermissionForAndroid();
    //     _initForegroundTask();
    //     if (await FlutterForegroundTask.isRunningService) {
    //       final newReceivePort = FlutterForegroundTask.receivePort;
    //       _registerReceivePort(newReceivePort);
    //     }
    //     _startForegroundTask();
    //   }
    //   _initLocalRenderer();
    // });
    _initLocalRenderer();
  }

  void _initLocalRenderer() async {
    await _localRenderer.initialize();
    _localStream = await _getUserMediaStream;
    if (!widget.info.isFrontCamera) onCameraSwitch();
    onCameraOn();
    onMute();
    setState(() {
      _localRenderer.srcObject = _localStream;
      _widgetMap['local'] = ContributorCard(
        key: UniqueKey(),
        renderer: _localRenderer,
        meetingId: widget.info.id,
        uid: AuthHelper.uid,
        mirror: !isShareScreen,
      );
    });
    _setStatus();
    _offerAnswerHostUser();
  }

  void onSilent(bool silent) => Helper.setSpeakerphoneOn(!silent);

  void onCameraSwitch() {
    if (_localStream != null) {
      Helper.switchCamera(_localStream!.getVideoTracks()[0]);
    }
  }

  void onCameraOn() {
    if (_localStream != null) {
      _localStream?.getVideoTracks()[0].enabled = isCameraOn;
      _changeStatus(key: 'isCameraOn');
    }
  }

  void onMute() {
    if (_localStream != null && _localStream!.getAudioTracks().isNotEmpty) {
     _localStream?.getAudioTracks()[0].enabled = !isMute;
     _changeStatus(key: 'isMute');
    }
  }

  void onRiseHand() {
    _changeStatus(key: 'handUp');
  }

  void _offerAnswerHostUser() {
    _hostSubs = controller.handler
        .getMeetingReference(widget.info.id)
        .snapshots()
        .listen((event) {
      final mp = event.data();
      if (mp != null && mp is Map<String, dynamic>) {
        for (final item in mp.entries) {
          final curItem = item.key;
          if (curItem != AuthHelper.uid && !_addedUser.contains(curItem)) {
            final newKey = GlobalKey();
            _keyMap[curItem] = newKey;
            _addedUser.add(curItem);
            _widgetMap[curItem] = RemoteContributor(
              key: newKey,
              type: AuthHelper.uid.compareTo(curItem) > 0
                  ? ContributorType.outgoing
                  : ContributorType.incoming,
              uid: curItem,
              meetingId: widget.info.id,
              local: _localStream!,
            );
          }
        }
        final list = <String>[];
        for (final item in _widgetMap.entries) {
          if (item.key != 'local' && !mp.containsKey(item.key)) {
            list.add(item.key);
          }
        }
        for (final item in list) {
          _addedUser.remove(item);
          _keyMap.remove(item);
          _widgetMap.remove(item);
        }
        setState(() {});
      }
    });
  }

  void _changeStatus({required String key}) {
    controller.handler.changeStatus(
      id: widget.info.id,
      isMute: isMute,
      isRiseHand: isRiseHand,
      isCameraOn: isCameraOn,
      isFrontCamera: isFrontCamera,
    );
  }

  void _setStatus() {
    controller.handler.setStatus(
      id: widget.info.id,
      isMute: isMute,
      isRiseHand: isRiseHand,
      isCameraOn: isCameraOn,
      isFrontCamera: isFrontCamera,
    );
  }

  void _removeStatus() {
    controller.handler.removeStatus(widget.info.id);
  }

  int get snapCount {
    switch (itemCount) {
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return config.isMobile ? 2 : 3;
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
        return config.isMobile
            ? 2
            : config.isTab
                ? 3
                : 4;
      default:
        return config.isMobile
            ? 2
            : config.isTab
                ? 3
                : config.isLaptop
                    ? 4
                    : config.isDesktop
                        ? 5
                        : 6;
    }
  }

  List<Widget> get children {
    return _widgetMap.entries.map((e) => e.value).toList();
  }

  Widget childAt(int index) {
    return children[index];
  }

  double get ratio {
    switch (itemCount) {
      case 1:
        return 0.6;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    config = SizeConfig.of(context);
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: MeetingView(
              items: children,
              itemBackground: Colors.black.withAlpha(50),
              itemSpace: 5,
              frameBuilder: (context, layer, item) { return item; },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImageButton(
                  icon: Icons.call_end,
                  tint: Colors.white,
                  background: Colors.red,
                  size: 32,
                  onClick: () => Navigator.pop(context),
                ),
                ImageButton(
                  icon: isCameraOn
                      ? Icons.videocam_outlined
                      : Icons.videocam_off_outlined,
                  tint: isCameraOn ? Colors.black : Colors.white,
                  background: isCameraOn ? Colors.white : Colors.white12,
                  size: 32,
                  onClick: () {
                    isCameraOn = !isCameraOn;
                    setState(onCameraOn);
                  },
                ),
                ImageButton(
                  icon: isMute ? Icons.mic_off : Icons.mic,
                  tint: isMute ? Colors.white : Colors.black,
                  background: isMute ? Colors.white12 : Colors.white,
                  size: 32,
                  onClick: () {
                    isMute = !isMute;
                    setState(onMute);
                  },
                ),
                ImageButton(
                  icon: Icons.back_hand_outlined,
                  tint: isRiseHand ? Colors.black : Colors.white,
                  background: isRiseHand ? Colors.white : Colors.white12,
                  size: 32,
                  onClick: () {
                    isRiseHand = !isRiseHand;
                    setState(onRiseHand);
                  },
                ),
                ImageButton(
                  icon: Icons.more_vert,
                  tint: Colors.white,
                  background: Colors.white12,
                  size: 32,
                  onClick: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  int get itemCount => children.length;

  bool get isVerticalMode => config.width < config.height && config.isMobile;

  @override
  void dispose() {
    _disposeSubs();
    _removeStatus();
    _disposeLocalRenderer();
    _closeReceivePort();
    _stopForegroundTask();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _disposeLocalRenderer() {
    _localRenderer.dispose();
    _localStream?.getTracks().forEach((element) {
      element.stop();
    });
    _localStream?.dispose();
  }

  void _disposeSubs() {
    _hostSubs?.cancel();
    _roomSubs?.cancel();
  }
}
