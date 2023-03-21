import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../auth/api/auth_management.dart';
import 'call_enum/call_enum.dart';

const callingScreenRoute = 'callingScreenRoute';

class CallingScreen extends StatefulWidget {
  const CallingScreen({super.key, required this.id, required this.callEnum});

  final String id;
  final CallEnum callEnum;

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  final chatRooms = FirebaseFirestore.instance.collection('chat-rooms');
  final curUser = FirebaseFirestore.instance.collection('users').doc(AuthManagementUseCase.curUser);
  late final curRoom = chatRooms.doc(
    widget.callEnum == CallEnum.outgoing
        ? '${AuthManagementUseCase.curUser}+${widget.id}'
        : '${widget.id}+${AuthManagementUseCase.curUser}'
  );

  StreamSubscription? _roomSubs;


  final _localRenderer = RTCVideoRenderer();
  //final _remoteRenderer = RTCVideoRenderer();
  late MediaStream _localStream;

  Future<MediaStream> get _getUserMediaStream async{
    final mp = <String, dynamic>{
      'audio': false,
      'video': {
        'facingMode': 'user'
      }
    };
    final stream = await navigator.mediaDevices.getUserMedia(mp);
    _localRenderer.srcObject = stream;
    Future.delayed(const Duration(seconds: 1)).then((value){
      setState(() {

      });
    });
    return stream;
  }

  void _initRoom(){
    _roomSubs = curRoom.snapshots().listen((event) {
      final data = event.data();
      if(data == null) Navigator.pop(context);
    });
  }

  void _deleteRoomAndRecoverState(){
    curRoom.delete();
    curUser.update({
      'inAnotherCall': false,
      'incomingCallFrom': null
    });
    _roomSubs?.cancel();
  }

  Future<void> _initLocalRenderer() async{
    await _localRenderer.initialize();
    _localStream = await _getUserMediaStream;
  }

  Future<void> _disposeLocalRenderer() async{
    _localRenderer.dispose();
    _localStream.dispose();
  }

  Future<void> _initRemoteRenderer() async{

  }

  void _initRenderers() {
    _initLocalRenderer();
  }

  void _disposeRenderers(){
    _disposeLocalRenderer();
  }

  @override
  void dispose() {
    _deleteRoomAndRecoverState();
    _disposeRenderers();
    super.dispose();
  }

  @override
  void initState() {
    _initRenderers();
    _initRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('enum is: ${widget.callEnum}');
    return Scaffold(
      appBar: AppBar(title: const Text('Calling Screen')),
      body: Column(
        children: [
          Flexible(
            child: Container(
              key: const Key('local'),
              margin: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Colors.black),
              child: RTCVideoView(_localRenderer, mirror: true),
            ),
          ),
        ],
      ),
    );
  }
}
