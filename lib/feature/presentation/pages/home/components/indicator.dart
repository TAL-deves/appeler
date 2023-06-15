import 'package:flutter/material.dart';
import 'package:flutter_androssy/widgets.dart';

import '../../../../../index.dart';

class HomeIndicator extends StatelessWidget {
  final int itemCount;
  final int activeIndex;

  const HomeIndicator({
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
