import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../index.dart';

class WrapperView extends StatefulWidget {
  final Widget Function(BuildContext context, SizeConfig config) builder;
  final BoxConstraints? Function(SizeConfig config)? constrains;

  const WrapperView({
    super.key,
    required this.builder,
    this.constrains,
  });

  @override
  State<WrapperView> createState() => _WrapperViewState();
}

class _WrapperViewState extends State<WrapperView> {
  late SizeConfig config = SizeConfig.of(context, size: const Size(0, 0));

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
      wrapper: (size) => setState(() {
        config = SizeConfig.of(
          context,
          size: size,
        );
      }),
      child: Container(
        constraints: widget.constrains?.call(config),
        child: widget.builder.call(context, config),
      ),
    );
  }
}

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

