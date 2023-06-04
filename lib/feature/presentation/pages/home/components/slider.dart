import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';

import '../../../../../index.dart';

class HomeSlider extends StatelessWidget {
  final OnViewClickListener? onCreateMeet, onJoinMeet, onScheduleMeet;

  const HomeSlider({
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
