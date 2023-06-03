import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

class HomeFragment extends StatefulWidget {
  final HomeController controller;

  const HomeFragment({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  late HomeController controller;
  late TextEditingController code;
  late int index = 0;
  String? oldRoomId;

  @override
  void initState() {
    controller = context.read<HomeController>();
    code = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      children: [
        LinearLayout(
          flex: 1,
          layoutGravity: LayoutGravity.center,
          children: [
            const Spacer(flex: 3),
            _Buttons(
              onCreateMeet: (context) {
                final roomId = controller.generateRoom(oldRoomId);
                oldRoomId = roomId;
                if (roomId != null) {
                  setState(() {
                    code.text = roomId;
                  });
                }
              },
              onJoinMeet: (context) {},
              onScheduleMeet: (context) {},
            ),
            const Spacer(),
            const _Indicator(
              itemCount: 3,
              activeIndex: 1,
            ),
            const Spacer(),
          ],
        ),
        LinearLayout(
          flex: 1,
          layoutGravity: LayoutGravity.center,
          paddingHorizontal: 50,
          children: [
            MeetingIdField(
              controller: code,
              icon: Icons.copy_all,
              iconVisible: index == 0,
              onCopyOrShare: (value) async => await ClipboardHelper.setText(
                value,
              ),
            ),
            Button(
              ripple: 10,
              width: 120,
              text: buttonName,
              borderRadius: 25,
              marginTop: 24,
              onClick: (context) {
                if (index == 0 || index == 1) {
                  if (code.text.isNotEmpty) {
                    Navigator.pushNamed(
                      context,
                      PrepareActivity.route,
                      arguments: {
                        "meeting_id": code.text,
                        "HomeController": controller,
                      },
                    );
                  }
                } else {}
              },
            ),
            TextView(
              text: "Logout",
              borderRadius: 25,
              marginTop: 24,
              onClick: (context) {
                locator<AuthHandler>().signOut().then((value) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AuthActivity.route,
                    (route) => false,
                    arguments: AuthFragmentType.signIn,
                  );
                });
              },
            ),
          ],
        )
      ],
    );
  }

  String get buttonName => index == 0
      ? "Join"
      : index == 1
          ? "Join"
          : "Schedule";
}

class _Buttons extends StatelessWidget {
  final OnViewClickListener? onCreateMeet, onJoinMeet, onScheduleMeet;

  const _Buttons({
    Key? key,
    this.onCreateMeet,
    this.onJoinMeet,
    this.onScheduleMeet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StackLayout(
      paddingHorizontal: 40,
      height: 120,
      width: double.infinity,
      children: [
        LinearLayout(
          width: double.infinity,
          positionType: ViewPositionType.flexHorizontal,
          background: AppColors.secondary,
          gravity: Alignment.center,
          borderRadiusTL: 25,
          borderRadiusBR: 25,
          orientation: Axis.horizontal,
          children: [
            LinearLayout(
              flex: 1,
              onClick: onCreateMeet,
              layoutGravity: LayoutGravity.center,
              padding: 12,
              children: [
                const RawTextView(
                  text: "Create\nMeet",
                  textColor: Colors.white,
                  textAlign: TextAlign.center,
                  textSize: 14,
                ),
                const SizedBox(height: 8),
                RawIconView(
                  icon: AppIcons.createMeet,
                  tint: AppColors.primary,
                  size: 18,
                ),
              ],
            ),
            const Spacer(
              flex: 1,
            ),
            LinearLayout(
              flex: 1,
              layoutGravity: LayoutGravity.center,
              padding: 12,
              onClick: onScheduleMeet,
              children: [
                const RawTextView(
                  text: "Schedule\nMeet",
                  textColor: Colors.white,
                  textAlign: TextAlign.center,
                  textSize: 14,
                ),
                const SizedBox(height: 8),
                RawIconView(
                  icon: AppIcons.scheduleMeet,
                  tint: AppColors.primary,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
        LinearLayout(
          onClick: onJoinMeet,
          background: AppColors.primary,
          borderRadiusBR: 40,
          borderRadiusTL: 40,
          gravity: Alignment.center,
          layoutGravity: LayoutGravity.center,
          padding: 8,
          height: 120,
          shape: ViewShape.squire,
          children: [
            const RawTextView(
              text: "Join\nMeet",
              textColor: Colors.white,
              textAlign: TextAlign.center,
              textSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            RawIconView(
              icon: AppIcons.joinMeet,
              tint: AppColors.secondary,
              size: 24,
            ),
          ],
        ),
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  final int itemCount;
  final int activeIndex;

  const _Indicator({
    Key? key,
    required this.itemCount,
    required this.activeIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      orientation: Axis.horizontal,
      layoutGravity: LayoutGravity.center,
      children: List.generate(itemCount, (i) {
        return YMRView(
          background: activeIndex == i
              ? AppColors.primary
              : AppColors.primary.withAlpha(50),
          shape: ViewShape.circular,
          width: 10,
          marginHorizontal: 4,
        );
      }),
    );
  }
}
