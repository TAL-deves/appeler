import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WidgetWrapper extends SingleChildRenderObjectWidget {
  final Function(Size size) wrapper;

  const WidgetWrapper({
    Key? key,
    required this.wrapper,
    super.child,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return ObjectWrapper(wrapper);
  }
}

class ObjectWrapper extends RenderProxyBox {
  final Function(Size size) wrapper;

  Size? ox;

  ObjectWrapper(this.wrapper);

  @override
  void performLayout() {
    super.performLayout();
    try {
      Size? nx = child?.size;
      if (nx != null && ox != nx) {
        ox = nx;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          wrapper(nx);
        });
      }
    } catch (_) {}
  }
}
