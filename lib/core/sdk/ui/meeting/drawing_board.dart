import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import '../../analytica_rtc.dart';

class ARTCDrawingBoard extends StatefulWidget {
  final VoidCallback? onCloseWhiteBoard;

  const ARTCDrawingBoard({
    super.key,
    this.writeMode = true,
    required this.roomId,
    required this.userId,
    this.onCloseWhiteBoard,
  });

  final bool writeMode;
  final String roomId, userId;

  @override
  State<ARTCDrawingBoard> createState() => ARTCDrawingBoardState();
}

class ARTCDrawingBoardState extends State<ARTCDrawingBoard> {
  Color selectedColor = Colors.black;
  double strokeWidth = 5;

  final List<ARTCInnerStroke> _strokes = [];
  List<Color> colors = [
    Colors.pink,
    Colors.red,
    Colors.black,
    Colors.yellow,
    Colors.amberAccent,
    Colors.purple,
    Colors.green,
  ];

  RealTimeDB? _readRemoteData;

  dynamic _remoteData;

  late final _dataPath = '${widget.roomId}/whiteboardData';

  var _dataList = <Map<String, dynamic>>[];

  Timer? _timer, _timer2, _timer3, _timer4;

  late DateTime _curTime;

  final _queue = Queue<List<Map<String, dynamic>>>();

  final _userQueue = Queue<String>();

  final _bufferList = <Map<String, dynamic>>[];

  var _apiCalling = false;

  var _isInterrupted = false;

  var _sendServiceInRun = false;

  var times = 0;

  Future<void> _updateDraw(List<Map<String, dynamic>> curList,
      {bool useDelay = true}) async {
    for (var i = 0; i < curList.length; ++i) {
      final curItem = curList[i];

      final delay = curItem['delay'];

      if (useDelay) await Future.delayed(Duration(milliseconds: delay));

      final isHead = curItem['head'];
      final x = curItem['dx'];
      final y = curItem['dy'];

      final dx = x is int ? x.toDouble() : x;
      final dy = y is int ? y.toDouble() : y;

      if (!isHead) {
        _update(dx, dy);
      } else {
        final color = curItem['color'];
        final w = curItem['width'];
        final width = w is int ? w.toDouble() : w;
        _start(dx, dy, Color(color), width);
      }
    }
  }

  void _readViewUpdate() {
    var runningOperation = false;
    _timer2 = Timer.periodic(const Duration(milliseconds: 10), (timer) async {
      if (!runningOperation && _queue.isNotEmpty) {
        runningOperation = true;
        await _updateDraw(_queue.removeFirst());
        runningOperation = false;
      }
    });
  }

  var _isFirst = true;
  var _isCalled = false;
  late final curPath = '${widget.roomId}/wbBuffer/${widget.userId}';

  void _initRemoteReading() {
    _readRemoteData = AnalyticaRTC.getRealTimeDB(
        path: curPath,
        onGetData: (value) async {
          final curValue = value['data']?['buffer'] as Map<String, dynamic>?;
          if (curValue != null && !curValue['isRead'] && _isFirst) {
            _isFirst = false;
            _remoteData = curValue;
            final curList =
                List<Map<String, dynamic>>.from(curValue['list'] ?? []);
            await _updateDraw(curList, useDelay: false);
            Future.delayed(const Duration(seconds: 3)).then((value) {
              AnalyticaRTC.repository.set(path: curPath, data: {
                'buffer': {'isRead': true}
              });
            });
          }
          Future.delayed(const Duration(seconds: 5)).then((value) {
            if (!_isCalled) {
              _isCalled = true;
              _readingNextWork();
            }
          });
        });
  }

  void _readingNextWork() {
    _readRemoteData?.dispose();
    _readViewUpdate();
    _readRemoteData = AnalyticaRTC.getRealTimeDB(
        path: _dataPath,
        onGetData: (data) async {
          final curData = data['data']?['curData'] as List<dynamic>?;
          if (curData != null) {
            if (curData.isEmpty) {
              setState(() => _strokes.clear());
            } else {
              final curList = List<Map<String, dynamic>>.from(curData);
              _remoteData = curData;
              _queue.add(curList);
            }
          }
        });
  }

  @override
  void initState() {
    if (!widget.writeMode) {
      _initRemoteReading();
    } else {
      _sendBufferToUser();
      _sendDataListToServer();
      _interruptUpdate();
    }
    super.initState();
  }

  void _timerCancel() {
    _timer?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    _timer4?.cancel();
  }

  @override
  void dispose() {
    _timerCancel();
    _readRemoteData?.dispose();
    super.dispose();
  }

  void _interruptUpdate() {
    _isInterrupted = _sendServiceInRun || _userQueue.isNotEmpty;
    _timer4 = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      final curIn = _sendServiceInRun || _userQueue.isNotEmpty;
      if (curIn != _isInterrupted) {
        setState(() {
          _isInterrupted = curIn;
        });
      }
    });
  }

  void _sendBufferToUser() {
    _timer3 = Timer.periodic(const Duration(milliseconds: 10), (timer) async {
      if (!_sendServiceInRun && _userQueue.isNotEmpty) {
        _sendServiceInRun = true;
        final userId = _userQueue.removeFirst();
        final curPath = '${widget.roomId}/wbBuffer/$userId';
        late final RealTimeDB dbRef;
        dbRef = AnalyticaRTC.getRealTimeDB(
            path: curPath,
            onGetData: (value) {
              final curValue =
                  value['data']?['buffer'] as Map<String, dynamic>?;
              if (curValue != null && curValue['isRead']) {
                AnalyticaRTC.repository.delete(path: curPath);
                _sendServiceInRun = false;
                dbRef.dispose();
              }
            });
        AnalyticaRTC.repository.set(path: curPath, data: {
          'buffer': {'isRead': false, 'list': _bufferList}
        });
      }
    });
  }

  void addNewUser({required String userId}) {
    _userQueue.add(userId);
  }

  var _oldList = <Map<String, dynamic>>[];

  void _sendDataListToServer() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_dataList.isNotEmpty && !_apiCalling) {
        _apiCalling = true;
        final curLen = _dataList.length;
        final sendList = _dataList.sublist(0, curLen);
        _bufferList.addAll(_oldList);
        _oldList = sendList;
        //_bufferList.addAll(sendList);
        _dataList = _dataList.sublist(curLen);
        AnalyticaRTC.repository.set(
            path: _dataPath,
            data: {'curData': sendList}).then((value) => _apiCalling = false);
      }
    });
  }

  void _start(double startX, double startY, Color? cApi, double? wApi) {
    setState(() {
      final newStroke = ARTCInnerStroke(
        color: cApi ?? selectedColor,
        width: wApi ?? strokeWidth,
      );
      newStroke.path.moveTo(startX, startY);
      _strokes.add(newStroke);
    });
  }

  void _update(double x, double y) {
    if (_strokes.isNotEmpty) {
      setState(() => _strokes.last.path.lineTo(x, y));
    }
  }

  void _dataListUpdate(
      {required double dx,
      required double dy,
      bool head = true,
      int delay = 0}) {
    final mp = {
      'dx': dx,
      'dy': dy,
      'head': head,
      'delay': delay,
    };
    if (head) {
      mp['color'] = selectedColor.value;
      mp['width'] = strokeWidth;
    }
    _dataList.add(mp);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.writeMode || _remoteData != null) {
      return Expanded(
        child: Stack(
          children: [
            if (_isInterrupted)
              const Positioned.fill(
                child: Center(
                    child: Text('On Hold!, Please wait!!!!',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 30))),
              ),
            Column(
              children: [
                Container(
                  color: Colors.grey.withOpacity(0.125),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: widget.writeMode
                            ? Slider(
                                min: 0,
                                max: 40,
                                value: strokeWidth,
                                onChanged: (val) =>
                                    setState(() => strokeWidth = val),
                              )
                            : const SizedBox(),
                      ),
                      if (widget.writeMode)
                        ElevatedButton(
                          onPressed: () async {
                            await AnalyticaRTC.repository.set(
                              path: _dataPath,
                              data: {'curData': []},
                            );
                            setState(() {
                              _strokes.clear();
                              _oldList.clear();
                              _bufferList.clear();
                            });
                          },
                          child: const Icon(
                            Icons.brush,
                            color: Colors.white,
                          ),
                        ),
                      if (widget.writeMode) const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: widget.onCloseWhiteBoard,
                        child: const Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onPanStart: (details) {
                      if (!_isInterrupted && widget.writeMode) {
                        final dx = details.localPosition.dx;
                        final dy = details.localPosition.dy;
                        _curTime = DateTime.now();
                        _dataListUpdate(dx: dx, dy: dy);
                        _start(dx, dy, null, null);
                      }
                    },
                    onPanUpdate: (details) {
                      if (!_isInterrupted && widget.writeMode) {
                        final dx = details.localPosition.dx;
                        final dy = details.localPosition.dy;
                        final newTime = DateTime.now();
                        final delay =
                            newTime.difference(_curTime).inMilliseconds;
                        _curTime = newTime;
                        _dataListUpdate(
                            dx: dx, dy: dy, head: false, delay: delay);
                        _update(dx, dy);
                      }
                    },
                    onPanEnd: (details) {
                      //_sendDataListToServer();
                    },
                    child: CustomPaint(
                      isComplex: true,
                      willChange: false,
                      painter: _DrawingPainter(_strokes),
                      child: Container(),
                    ),
                  ),
                ),
                if (widget.writeMode)
                  Container(
                    color: Colors.grey.withOpacity(0.25),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        colors.length,
                        (index) => _buildColorChose(colors[index]),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        width: isSelected ? 40 : 30,
        height: isSelected ? 40 : 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<ARTCInnerStroke> strokes;

  _DrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // canvas.drawRect(
    //   Rect.fromLTWH(0, 0, size.width, size.height),
    //   Paint()..color = Colors.yellowAccent,
    // );

    //print('point lengthx is: ${strokes.length}');
    for (final stroke in strokes) {
      final paint = Paint()
        ..strokeWidth = stroke.width
        ..color = stroke.erase ? Colors.transparent : stroke.color
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..blendMode = stroke.erase ? BlendMode.clear : BlendMode.srcOver;
      canvas.drawPath(stroke.path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ARTCInnerStroke {
  final path = Path();
  final Color color;
  final double width;
  final bool erase;

  ARTCInnerStroke({
    this.color = Colors.black,
    this.width = 4,
    this.erase = false,
  });
}
