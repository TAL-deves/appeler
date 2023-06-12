import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../index.dart';

typedef OnPrepare = Function(BuildContext context, MeetingInfo info);

class PrepareActivity extends StatefulWidget {
  static const String route = "prepare";
  static const String title = "Prepare";

  final HomeController? homeController;
  final String meetingId;

  const PrepareActivity({
    Key? key,
    required this.meetingId,
    required this.homeController,
  }) : super(key: key);

  @override
  State<PrepareActivity> createState() => _PrepareActivityState();
}

class _PrepareActivityState extends State<PrepareActivity> {
  late bool isSilent = false;
  late bool isFrontCamera = true;
  var joined = false;

  @override
  void dispose() {
    if (!joined) {
      locator<MeetingHandler>().removeStatus(widget.meetingId);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        widget.homeController != null
            ? BlocProvider.value(value: widget.homeController!)
            : BlocProvider(create: (context) => locator<HomeController>())
      ],
      child: AppScreen(
        title: kIsWeb ? null : widget.meetingId,
        titleCenter: true,
        body: PrepareFragment(
          info: MeetingInfo(
            id: widget.meetingId,
            isSilent: isSilent,
            cameraType: isFrontCamera ? CameraType.front : CameraType.back,
          ),
          onPrepare: (context, info) {
            joined = true;
            context.push(
              MeetingActivity.route.withSlash,
              extra: {
                "data": info,
                "HomeController": context.read<HomeController>(),
              },
            );
          },
        ),
      ),
    );
  }
}
