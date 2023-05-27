import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';

class ToolbarView extends YMRView<ToolbarController> {
  final Widget? action;
  final Widget? leading;
  final Widget? title;

  const ToolbarView({
    super.key,
    this.action,
    this.leading,
    this.title,
  });

  @override
  ToolbarController attachController() {
    return ToolbarController();
  }

  @override
  ToolbarController initController(ToolbarController controller) {
    return controller.attach(this);
  }

  @override
  Widget? attach(BuildContext context, ToolbarController controller) {
    return StackLayout(
      width: double.infinity,
      children: [
        YMRView(
          positionType: ViewPositionType.centerStart,
          child: leading,
        ),
        YMRView(
          positionType: ViewPositionType.center,
          child: title,
        ),
        YMRView(
          positionType: ViewPositionType.centerEnd,
          child: action,
        ),
      ],
    );
  }
}

class ToolbarController extends ViewController {
  @override
  ToolbarController attach(
    YMRView<ViewController> view,
  ) {
    super.attach(view);
    return this;
  }
}