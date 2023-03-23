import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
  final _chatRooms = FirebaseFirestore.instance.collection('chat-rooms');
  final _curUser = FirebaseFirestore.instance.collection('users').doc(AuthManagementUseCase.curUser);
  late final _curRoom = _chatRooms.doc(
    widget.callEnum == CallEnum.outgoing
        ? '${AuthManagementUseCase.curUser}+${widget.id}'
        : '${widget.id}+${AuthManagementUseCase.curUser}'
  );

  late final _curRoomSelfCandidates = _curRoom.collection(widget.callEnum == CallEnum.outgoing ? 'callerCandidate': 'callieCandidate');
  late final _curRoomRemoteCandidates = _curRoom.collection(widget.callEnum == CallEnum.outgoing ? 'callieCandidate' : 'callerCandidate');

  StreamSubscription? _roomSubs;

  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  MediaStream? _localStream, _remoteStream;
  late RTCPeerConnection _peerConnection;

  StreamSubscription? _curRoomSubs, _candidateSubs;

  void _refreshWithDelay(){
    Future.delayed(const Duration(seconds: 1)).then((value){
      setState(() {

      });
    });
  }

  Future<MediaStream> get _getUserMediaStream async{
    final mp = <String, dynamic>{
      'audio': false,
      'video': kIsWeb ? {
        'facingMode': 'user'
      } : {
        'width': '640',
        'height': '480',
        'frameRate': '30',
        'facingMode': 'user',
        'optional': [],
      }
    };
    final stream = await navigator.mediaDevices.getUserMedia(mp);
    _localRenderer.srcObject = stream;
    _refreshWithDelay();
    return stream;
  }

  Future<RTCPeerConnection> _createPeerConnection() async{
    final config = <String, dynamic>{
      "sdpSemantics": "plan-b", //this line is added
      'iceServers': [
        //{ "url": "stun:34.143.165.178:3478" },
        {
          "url": "turn:34.143.165.178:3478?transport=udp",
          "username": "test",
          "credential": "test123",
        },
        // {
        //   "url": "turn:180.210.129.103:3478?transport=udp",
        //   "username": "citlrtc",
        //   "credential": "c1tlr7c",
        // }
      ]
    };

    final pc = await createPeerConnection(config);
    await pc.addStream(_localStream!);

    pc.onIceCandidate = (e){
      if(e.candidate != null){
        _curRoomSelfCandidates.add(e.toMap());
      }
    };

    pc.onAddStream = (stream){
      _remoteRenderer.srcObject = stream;
      _remoteStream = stream;
      _refreshWithDelay();
    };
    return pc;
  }

  void _initRoom(){
    _roomSubs = _curRoom.snapshots().listen((event) {
      final data = event.data();
      if(data == null) Navigator.pop(context);
    });
  }

  Future<void> _deleteInnerCollection() async{
    final innerCollection = await _curRoomSelfCandidates.get();
    for(var item in innerCollection.docs){
      await item.reference.delete();
    }
  }

  void _deleteRoomAndRecoverState() async{
    await _deleteInnerCollection();
    _curRoom.delete();
    _curUser.update({
      'inAnotherCall': false,
      'incomingCallFrom': null
    });
  }

  Future<void> _initPeerConnection() async{
    _peerConnection = await _createPeerConnection();
  }

  Future<void> _setRemoteDescription({required Map<String, dynamic> sdpMap}) async{
    final description = RTCSessionDescription(sdpMap['sdp'], sdpMap['type']);
    return await _peerConnection.setRemoteDescription(description);
  }

  void _createOffer() async{
    final offer = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(offer);
    _curRoom.set({'offer': offer.toMap()});
    _curRoomSubs = _curRoom.snapshots().listen((snapshot) async{
      final sdpMap = snapshot.data()?['answer'];
      if(await _peerConnection.getRemoteDescription() == null && sdpMap != null){
        await _setRemoteDescription(sdpMap: sdpMap);
      }
    });
  }

  void _createAnswer() async{
    _curRoomSubs = _curRoom.snapshots().listen((snapshot) async {
      final sdpMap = snapshot.data()?['offer'];
      if(await _peerConnection.getRemoteDescription() == null && sdpMap != null){
        await _setRemoteDescription(sdpMap: sdpMap);
        final answer = await _peerConnection.createAnswer();
        await _peerConnection.setLocalDescription(answer);
        _curRoom.update({'answer': answer.toMap()});
      }
    });
  }

  Future<void> _initLocalRendererAndPeer() async{
    await _localRenderer.initialize();
    _localStream = await _getUserMediaStream;
    await _initPeerConnection();
  }

  Future<void> _disposeLocalRenderer() async{
    _localRenderer.dispose();
    _removeStreamTracks(_localStream);
    _localStream?.dispose();
  }

  Future<void> _initRemoteRenderer() async{
    await _remoteRenderer.initialize();
    _setRemoteCandidate();
  }

  Future<void> _disposeRemoteRenderer() async{
    _remoteRenderer.dispose();
    _removeStreamTracks(_remoteStream);
    _remoteStream?.dispose();
  }

  void _setRemoteCandidate() {
    _candidateSubs = _curRoomRemoteCandidates.snapshots().listen((event) async{
      for(var item in event.docChanges){
        if(item.type == DocumentChangeType.added){
          final curData = item.doc.data();
          if(curData != null){
            final candidate = RTCIceCandidate(curData['candidate'], curData['sdpMid'], curData['sdpMLineIndex']);
            await _peerConnection.addCandidate(candidate);
          }
        }
      }
    });
  }

  void _initRenderers() async{
    await _initLocalRendererAndPeer();
    await _initRemoteRenderer();
    if(widget.callEnum == CallEnum.outgoing){ _createOffer(); }
    else{ _createAnswer(); }
  }

  void _disposeRenderers(){
    _disposeLocalRenderer();
    _disposeRemoteRenderer();
  }

  void _cancelSubscriptions(){
    _curRoomSubs?.cancel();
    _candidateSubs?.cancel();
    _roomSubs?.cancel();
  }

  void _removeStreamTracks(MediaStream? mediaStream){
    mediaStream?.getTracks().forEach((track) => track.stop());
  }

  @override
  void dispose() {
    _deleteRoomAndRecoverState();
    _disposeRenderers();
    _cancelSubscriptions();
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
          Flexible(
            child: Container(
              key: const Key('remote'),
              margin: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Colors.black),
              child: RTCVideoView(_remoteRenderer, mirror: true),
            ),
          ),
        ],
      ),
    );
  }
}
