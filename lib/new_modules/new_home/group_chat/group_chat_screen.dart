import 'dart:async';

import 'package:appeler/core/app_constants/app_color.dart';
import 'package:appeler/modules/auth/api/auth_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../modules/calling/screen/call_enum/call_enum.dart';
import '../../../modules/group_calling/screen/for_remote/group_calling_remote_screen.dart';

const kGroupChatScreenRoute = 'groupChatScreen';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key, required this.groupId});

  final String groupId;

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _groupChatRooms = FirebaseFirestore.instance.collection('group-chat-rooms');
  late final _userDoc = _groupChatRooms.doc(widget.groupId);

  final _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;

  final _widgetMap = <String, Widget>{};
  final _addedUser = <String>{};

  StreamSubscription? _roomSubs, _hostSubs;

  Future<MediaStream> get _getUserMediaStream async {
    final mp = <String, dynamic>{
      'audio': false,
      'video': kIsWeb
          ? {'facingMode': 'user'}
          : {
              'width': '640',
              'height': '480',
              'frameRate': '30',
              'facingMode': 'user',
              'optional': [],
            }
    };
    final stream = await navigator.mediaDevices.getUserMedia(mp);
    return stream;
  }

  void _initLocalRenderer() async{
    await _localRenderer.initialize();
    _localStream = await _getUserMediaStream;
    setState(() {
      _localRenderer.srcObject = _localStream;
      _widgetMap['local'] = Flexible(
        key: UniqueKey(),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Colors.black),
              child: RTCVideoView(_localRenderer, mirror: true),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Text(AuthManagementUseCase.curUser!, style: const TextStyle(color: kRedColor, fontSize: 20),),
            ),
            PositionThumbsWidget(
              top: 20,
              right: 20,
              userId: AuthManagementUseCase.curUser!,
              groupId: widget.groupId,
            ),
            PositionMicWidget(
              bottom: 20,
              right: 20,
              userId: AuthManagementUseCase.curUser!,
              groupId: widget.groupId,
            ),
            PositionCameraWidget(
              bottom: 20,
              left: 20,
              userId: AuthManagementUseCase.curUser!,
              groupId: widget.groupId,
            ),
          ],
        ),
      );
    });
    _addCurrentUser();
    _offerAnswerHostUser();
  }

  void _addCurrentUser() {
    _userDoc.get().then((value) {
      final curMap = value.data()!;
      curMap[AuthManagementUseCase.curUser!] = {
        'isMute': true,
        'handUp': false,
        'isCameraOn': true,
      };
      _userDoc.set(curMap);
    });
  }

  void _removeCurrentUser() {
    _userDoc.get().then((value) {
      final curMap = value.data()!;
      curMap.remove(AuthManagementUseCase.curUser!);
      if (curMap.isEmpty) {
        _userDoc.delete();
      } else {
        _userDoc.set(curMap);
      }
    });
  }

  void _disposeLocalRenderer() {
    _localRenderer.dispose();
    _localStream?.getTracks().forEach((element) {
      element.stop();
    });
    _localStream?.dispose();
  }

  void _disposeSubs(){
    _hostSubs?.cancel();
    _roomSubs?.cancel();
  }

  void _offerAnswerHostUser(){
    _hostSubs = _userDoc.snapshots().listen((event) {
      final mp = event.data();
      if(mp != null){
        for(final item in mp.entries){
          final curItem = item.key;
          if(curItem != AuthManagementUseCase.curUser && !_addedUser.contains(curItem)){
            _addedUser.add(curItem);
            _widgetMap[curItem] = Flexible(
              key: UniqueKey(),
              child: Stack(
                children: [
                  GroupCallingRemoteScreen(
                    key: ValueKey(curItem),
                    callEnum: AuthManagementUseCase.curUser!.compareTo(curItem) > 0
                        ? CallEnum.outgoing
                        : CallEnum.incoming,
                    id: curItem,
                    localStream: _localStream!,
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Text(curItem, style: const TextStyle(color: kRedColor, fontSize: 20),),
                  ),
                  PositionThumbsWidget(
                    top: 20,
                    right: 20,
                    userId: curItem,
                    groupId: widget.groupId,
                  ),
                  PositionMicWidget(
                    bottom: 20,
                    right: 20,
                    userId: curItem,
                    groupId: widget.groupId,
                  ),
                  PositionCameraWidget(
                    bottom: 20,
                    left: 20,
                    userId: curItem,
                    groupId: widget.groupId,
                  ),
                ],
              ),
            );
          }
        }
        final list = <String>[];
        for(final item in _widgetMap.entries){
          if(item.key != 'local' && !mp.containsKey(item.key)) list.add(item.key);
        }
        for (final item in list){
          _addedUser.remove(item);
          _widgetMap.remove(item);
        }
        setState(() {

        });
      }
    });
  }

  @override
  void dispose() {
    _disposeSubs();
    _removeCurrentUser();
    _disposeLocalRenderer();
    super.dispose();
  }

  @override
  void initState() {
    _initLocalRenderer();
    //_addCurrentUser();
    //_offerAnswerHostUser();
    super.initState();
  }

  void _commonStatusChangeWork({required String workKey}){
    _userDoc.get().then((value) {
      final curMap = value.data()!;
      curMap[AuthManagementUseCase.curUser!][workKey] = !curMap[AuthManagementUseCase.curUser!][workKey];
      _userDoc.set(curMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ID: ${widget.groupId}'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InnerIconButton(
                icon: Icons.thumb_up_off_alt_sharp,
                onPressed: (){
                  _commonStatusChangeWork(workKey: 'handUp');
                },
                enabled: false,
              ),
              const SizedBox(width: 5),
              InnerIconButton(
                icon: Icons.mic,
                onPressed: (){
                  _commonStatusChangeWork(workKey: 'isMute');
                },
                enabled: true,
              ),
              const SizedBox(width: 5),
              InnerIconButton(
                icon: Icons.video_call,
                onPressed: (){
                  _commonStatusChangeWork(workKey: 'isCameraOn');
                },
                enabled: true,
              ),
            ],
          ),
          Expanded(
            child: _localStream == null
                ? const Center(child: CircularProgressIndicator(),)
                : Column(
              children: _widgetMap.entries.map((e) => e.value).toList(),
            ),
          )
        ],
      )
    );
  }
}

class PositionThumbsWidget extends StatefulWidget {
  const PositionThumbsWidget({super.key, this.left, this.bottom, this.right, this.top, required this.userId, required this.groupId});

  final double? left, top, right, bottom;
  final String userId, groupId;
  
  @override
  State<PositionThumbsWidget> createState() => _PositionThumbsWidgetState();
}

class _PositionThumbsWidgetState extends State<PositionThumbsWidget> {
  final _groupChatRooms = FirebaseFirestore.instance.collection('group-chat-rooms');
  late final _userDoc = _groupChatRooms.doc(widget.groupId);
  var _isEnabled = false;
  
  StreamSubscription? _sub;
  
  @override
  void initState() {
    _sub = _userDoc.snapshots().listen((event) {
      final mp = event.data()?[widget.userId];
      if(mp != null){
        setState(() {
          _isEnabled = mp['handUp'];
        });
      }
    });
    super.initState();
  }
  
  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      left: widget.left,
      right: widget.right,
      bottom: widget.bottom,
      child: Icon(Icons.thumb_up_off_alt_sharp, color: _isEnabled ? kYellowColor : kWhiteColor)
    );
  }
}

class PositionMicWidget extends StatefulWidget {
  const PositionMicWidget({super.key, this.left, this.bottom, this.right, this.top, required this.userId, required this.groupId});

  final double? left, top, right, bottom;
  final String userId, groupId;

  @override
  State<PositionMicWidget> createState() => _PositionMicWidgetState();
}

class _PositionMicWidgetState extends State<PositionMicWidget> {
  final _groupChatRooms = FirebaseFirestore.instance.collection('group-chat-rooms');
  late final _userDoc = _groupChatRooms.doc(widget.groupId);
  var _isEnabled = true;

  StreamSubscription? _sub;

  @override
  void initState() {
    _sub = _userDoc.snapshots().listen((event) {
      final mp = event.data()?[widget.userId];
      if(mp != null){
        setState(() {
          _isEnabled = mp['isMute'];
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      left: widget.left,
      right: widget.right,
      bottom: widget.bottom,
      child: Icon(_isEnabled ? Icons.mic : Icons.mic_off, color: kWhiteColor),
    );
  }
}

class PositionCameraWidget extends StatefulWidget {
  const PositionCameraWidget({super.key, this.left, this.bottom, this.right, this.top, required this.userId, required this.groupId});

  final double? left, top, right, bottom;
  final String userId, groupId;

  @override
  State<PositionCameraWidget> createState() => _PositionCameraWidgetState();
}

class _PositionCameraWidgetState extends State<PositionCameraWidget> {
  final _groupChatRooms = FirebaseFirestore.instance.collection('group-chat-rooms');
  late final _userDoc = _groupChatRooms.doc(widget.groupId);
  var _isEnabled = true;

  StreamSubscription? _sub;

  @override
  void initState() {
    _sub = _userDoc.snapshots().listen((event) {
      final mp = event.data()?[widget.userId];
      if(mp != null){
        setState(() {
          _isEnabled = mp['isCameraOn'];
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      left: widget.left,
      right: widget.right,
      bottom: widget.bottom,
      child: Icon(_isEnabled ? Icons.video_camera_front : Icons.videocam_off , color: kWhiteColor),
    );
  }
}

class InnerIconButton extends StatefulWidget {
  const InnerIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.enabled,
  });

  final IconData icon;
  final Function() onPressed;
  final bool enabled;

  @override
  State<InnerIconButton> createState() => _InnerIconButtonState();
}

class _InnerIconButtonState extends State<InnerIconButton> {
  late var _isActive = widget.enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          _isActive = !_isActive;
          widget.onPressed.call();
        });
      },
      child: AbsorbPointer(
        child: Icon(widget.icon, color: _isActive ? kGreenColor : null),
      ),
    );
  }
}

