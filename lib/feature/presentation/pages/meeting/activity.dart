import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

class MeetingActivity extends StatefulWidget {
  static const String route = "meeting";
  static const String title = "Meeting";

  final MeetingInfo data;
  final HomeController? homeController;

  const MeetingActivity({
    Key? key,
    required this.data,
    required this.homeController,
  }) : super(key: key);

  @override
  State<MeetingActivity> createState() => _MeetingActivityState();
}

class _MeetingActivityState extends State<MeetingActivity> {
  late bool isSilent = widget.data.isSilent;
  late bool isFrontCamera = widget.data.isFrontCamera;
  late bool isScreenShare = widget.data.isShareScreen;

  final globalKey = GlobalKey<MeetingFragmentState>();

  @override
  void initState() {
    silent();
    super.initState();
  }

  void silent() {
    globalKey.currentState?.onSilent(isSilent);
  }

  void switchCamera() {
    globalKey.currentState?.onSwitchCamera(true);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<MeetingController>()),
        widget.homeController != null
            ? BlocProvider.value(value: widget.homeController!)
            : BlocProvider(create: (context) => locator<HomeController>())
      ],
      child: AppScreen(
        autoLeading: false,
        toolbarHeight: 0,
        body: SafeArea(
          child: LinearLayout(
            orientation: Axis.vertical,
            width: double.infinity,
            widthMax: 1400,
            children: [
              StackLayout(
                width: double.infinity,
                height: kToolbarHeight,
                children: [
                  IconView(
                    padding: 8,
                    positionType: ViewPositionType.centerStart,
                    icon: Icons.message_outlined,
                    tint: AppColors.primary,
                    background: Colors.transparent,
                    visibility: kIsWeb ? ViewVisibility.gone : null,
                  ),
                  LinearLayout(
                    positionType: ViewPositionType.center,
                    layoutGravity: LayoutGravity.center,
                    children: [
                      RawIconView(
                        icon: AppInfo.logo,
                        tint: AppColors.primary,
                        size: 24,
                      ),
                      const TextView(
                        text: AppInfo.name,
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                  LinearLayout(
                    visibility: kIsWeb ? ViewVisibility.gone : null,
                    positionType: ViewPositionType.centerEnd,
                    orientation: Axis.horizontal,
                    crossGravity: CrossAxisAlignment.center,
                    children: [
                      IconView(
                        padding: 8,
                        icon: isSilent
                            ? Icons.volume_off_outlined
                            : Icons.volume_up_outlined,
                        tint: AppColors.primary,
                        onClick: (context) {
                          isSilent = !isSilent;
                          setState(silent);
                        },
                      ),
                      IconView(
                        padding: 8,
                        icon: isFrontCamera
                            ? Icons.camera_front_outlined
                            : Icons.camera_rear_outlined,
                        tint: AppColors.primary,
                        onClick: (context) {
                          isFrontCamera = !isFrontCamera;
                          setState(switchCamera);
                        },
                      )
                    ],
                  )
                ],
              ),
              Expanded(
                child: MeetingFragment(
                  key: globalKey,
                  info: widget.data,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}