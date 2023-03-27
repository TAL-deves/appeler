import 'package:appeler/modules/calling/screen/signal/signal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
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
  late final Signal _signal;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  @override
  void dispose() {
    _signal.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _signal = Signal(
      callEnum: widget.callEnum,
      id: widget.id,
      onChangeState: () => setState(() {}),
      onPop: () => Navigator.pop(context),
      localRenderer: _localRenderer,
      remoteRenderer: _remoteRenderer,
    )..init();
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
