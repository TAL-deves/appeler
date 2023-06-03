import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';

typedef FrameBuilder<T> = Widget Function(
  BuildContext context,
  FrameLayer layer,
  T item,
);

class MeetingView<T> extends StatefulWidget {
  final FrameViewController<T>? controller;
  final FrameBuilder<T>? frameBuilder;

  final Color? itemBackground;
  final double? itemSpace;
  final List<T>? items;
  final SizeConfig? config;

  const MeetingView({
    Key? key,
    this.controller,
    this.frameBuilder,
    this.itemBackground,
    this.itemSpace,
    this.items,
    this.config,
  }) : super(key: key);

  @override
  State<MeetingView<T>> createState() => _MeetingViewState<T>();
}

class _MeetingViewState<T> extends State<MeetingView<T>> {
  late FrameViewController<T> controller;
  late SizeConfig config = widget.config ?? SizeConfig(context);

  @override
  void initState() {
    controller = widget.controller ?? FrameViewController<T>();
    controller.attach(
      config: config,
      frameBuilder: widget.frameBuilder,
      itemBackground: widget.itemBackground,
      itemSpace: widget.itemSpace,
      items: widget.items,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MeetingView<T> oldWidget) {
    controller.attach(
      config: config,
      frameBuilder: widget.frameBuilder,
      itemBackground: widget.itemBackground,
      itemSpace: widget.itemSpace,
      items: widget.items,
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    controller.setContext(context);
    switch (controller.layer) {
      case FrameLayer.single:
        return _FrameLayerSingle<T>(controller: controller);
      case FrameLayer.double:
        return _FrameLayerDouble<T>(controller: controller);
      case FrameLayer.triple:
        return _FrameLayerTriple<T>(controller: controller);
      case FrameLayer.fourth:
        return _FrameLayerFourth<T>(controller: controller);
      case FrameLayer.fifth:
        return _FrameLayerFifth<T>(controller: controller);
      case FrameLayer.sixth:
        return _FrameLayerSixth<T>(controller: controller);
      case FrameLayer.seventh:
        return _FrameLayerSeventh<T>(controller: controller);
      case FrameLayer.eighth:
        return _FrameLayerEighth<T>(controller: controller);
      case FrameLayer.ninth:
      case FrameLayer.multiple:
        return _FrameLayerMultiple<T>(controller: controller);
      default:
        return const SizedBox();
    }
  }
}

class _FrameLayerSingle<T> extends StatelessWidget {
  final FrameViewController<T> controller;

  const _FrameLayerSingle({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _FrameBuilder(
      controller: controller,
      item: controller.items[0],
      resizable: true,
    );
  }
}

class _FrameLayerDouble<T> extends StatelessWidget {
  final FrameViewController<T> controller;

  const _FrameLayerDouble({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: controller.y,
      children: [
        _FrameBuilder(
          controller: controller,
          flexible: true,
          item: controller.items[0],
        ),
        SizedBox(
          width: controller.spaceX,
          height: controller.spaceY,
        ),
        _FrameBuilder(
          controller: controller,
          flexible: true,
          item: controller.items[1],
        ),
      ],
    );
  }
}

class _FrameLayerTriple<T> extends StatelessWidget {
  final FrameViewController<T> controller;

  const _FrameLayerTriple({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: controller.y,
      children: [
        _FrameBuilder(
          controller: controller,
          item: controller.items[0],
          flexible: true,
        ),
        SizedBox(
          width: controller.spaceX,
          height: controller.spaceY,
        ),
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                item: controller.items[1],
                flexible: true,
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                item: controller.items[2],
                flexible: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FrameLayerFourth<T> extends StatelessWidget {
  final FrameViewController<T> controller;

  const _FrameLayerFourth({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: controller.y,
      children: [
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[0],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[1],
              ),
            ],
          ),
        ),
        SizedBox(
          width: controller.spaceX,
          height: controller.spaceY,
        ),
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[2],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[3],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FrameLayerFifth<T> extends StatelessWidget {
  final FrameViewController<T> controller;

  const _FrameLayerFifth({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: controller.x,
      children: [
        Expanded(
          child: Flex(
            direction: controller.y,
            children: [
              _FrameBuilder(
                controller: controller,
                item: controller.items[0],
                flexible: true,
              ),
              SizedBox(
                width: controller.spaceX,
                height: controller.spaceY,
              ),
              _FrameBuilder(
                controller: controller,
                item: controller.items[1],
                flexible: true,
              ),
              SizedBox(
                width: controller.spaceX,
                height: controller.spaceY,
              ),
              _FrameBuilder(
                controller: controller,
                item: controller.items[2],
                flexible: true,
              ),
            ],
          ),
        ),
        SizedBox(
          width: controller.spaceY,
          height: controller.spaceX,
        ),
        Expanded(
          child: Flex(
            direction: controller.y,
            children: [
              const Spacer(),
              _FrameBuilder(
                flex: 2,
                controller: controller,
                item: controller.items[3],
                flexible: true,
              ),
              SizedBox(
                width: controller.spaceX,
                height: controller.spaceY,
              ),
              _FrameBuilder(
                flex: 2,
                controller: controller,
                item: controller.items[4],
                flexible: true,
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

class _FrameLayerSixth<T> extends StatelessWidget {
  final FrameViewController<T> controller;

  const _FrameLayerSixth({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: controller.y,
      children: [
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[0],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[1],
              ),
            ],
          ),
        ),
        SizedBox(
          width: controller.spaceX,
          height: controller.spaceY,
        ),
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[2],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[3],
              ),
            ],
          ),
        ),
        SizedBox(
          width: controller.spaceX,
          height: controller.spaceY,
        ),
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[4],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[5],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FrameLayerSeventh<T> extends StatelessWidget {
  final FrameViewController<T> controller;

  const _FrameLayerSeventh({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: controller.y,
      children: [
        _FrameBuilder(
          controller: controller,
          flexible: true,
          item: controller.items[0],
        ),
        SizedBox(
          width: controller.spaceX,
          height: controller.spaceY,
        ),
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[1],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[2],
              ),
            ],
          ),
        ),
        SizedBox(
          width: controller.spaceX,
          height: controller.spaceY,
        ),
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[3],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[4],
              ),
            ],
          ),
        ),
        SizedBox(
          width: controller.spaceX,
          height: controller.spaceY,
        ),
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[5],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[6],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FrameLayerEighth<T> extends StatelessWidget {
  final FrameViewController<T> controller;

  const _FrameLayerEighth({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: controller.y,
      children: [
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[0],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[1],
              ),
            ],
          ),
        ),
        SizedBox(
          width: controller.spaceX,
          height: controller.spaceY,
        ),
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[2],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[3],
              ),
            ],
          ),
        ),
        SizedBox(
          width: controller.spaceX,
          height: controller.spaceY,
        ),
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[4],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[5],
              ),
            ],
          ),
        ),
        SizedBox(
          width: controller.spaceX,
          height: controller.spaceY,
        ),
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[6],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[7],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FrameLayerMultiple<T> extends StatelessWidget {
  final FrameViewController<T> controller;

  const _FrameLayerMultiple({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: controller.y,
      children: [
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[0],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[1],
              ),
            ],
          ),
        ),
        SizedBox(
          width: controller.spaceX,
          height: controller.spaceY,
        ),
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[2],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[3],
              ),
            ],
          ),
        ),
        SizedBox(
          width: controller.spaceX,
          height: controller.spaceY,
        ),
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[4],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[5],
              ),
            ],
          ),
        ),
        SizedBox(
          width: controller.spaceX,
          height: controller.spaceY,
        ),
        Expanded(
          child: Flex(
            direction: controller.x,
            children: [
              _FrameBuilder(
                controller: controller,
                flexible: true,
                item: controller.items[6],
              ),
              SizedBox(
                width: controller.spaceY,
                height: controller.spaceX,
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _FrameBuilder(
                        controller: controller,
                        item: controller.items[7],
                      ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.35),
                        alignment: Alignment.center,
                        child: RawTextView(
                          textAlign: TextAlign.center,
                          text: "+${controller.invisibleItemSize}",
                          textColor: Colors.white,
                          textSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FrameBuilder<T> extends StatelessWidget {
  final FrameViewController<T> controller;
  final double? maxHeight;
  final T item;
  final double? dimension;
  final bool flexible, resizable;
  final int flex;

  const _FrameBuilder({
    Key? key,
    required this.controller,
    required this.item,
    this.flexible = false,
    this.resizable = false,
    this.maxHeight,
    this.dimension,
    this.flex = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return flexible
        ? Expanded(
            flex: flex,
            child: Container(
              width: double.infinity,
              height: resizable ? null : double.infinity,
              color: controller.itemBackground,
              child: Center(
                child: controller.frameBuilder?.call(
                  context,
                  controller.layer,
                  item,
                ),
              ),
            ),
          )
        : Container(
            width: double.infinity,
            height: resizable ? null : double.infinity,
            color: controller.itemBackground,
            child: Center(
              child: controller.frameBuilder?.call(
                context,
                controller.layer,
                item,
              ),
            ),
          );
  }
}

class FrameViewController<T> {
  late SizeConfig config;
  Size size = Size.zero;
  BuildContext? context;
  FrameBuilder<T>? frameBuilder;
  Color? itemBackground;
  double spaceBetween = 4;
  List<T> items = [];

  void setContext(BuildContext context) {
    this.config = SizeConfig(context);
    this.context = context;
    this.size = MediaQuery.of(context).size;
  }

  FrameViewController<T> attach({
    SizeConfig? config,
    FrameBuilder<T>? frameBuilder,
    Color? itemBackground,
    double? itemSpace,
    List<T>? items,
  }) {
    this.config = config ?? this.config;
    this.frameBuilder = frameBuilder;
    this.itemBackground = itemBackground;
    this.spaceBetween = itemSpace ?? this.spaceBetween;
    this.items = items ?? this.items;
    return this;
  }

  int get invisibleItemSize => items.length - 7;

  int get itemSize => items.length;

  FrameLayer get layer => FrameLayer.from(itemSize);

  bool get isX {
    return true;
    return size.width < size.height;
  }

  double? get spaceX => isX ? null : spaceBetween;

  double? get spaceY => isX ? spaceBetween : null;

  Axis get x => isX ? Axis.horizontal : Axis.vertical;

  Axis get y => isX ? Axis.vertical : Axis.horizontal;
}

enum FrameLayer {
  none,
  single,
  double,
  triple,
  fourth,
  fifth,
  sixth,
  seventh,
  eighth,
  ninth,
  multiple;

  factory FrameLayer.from(int size) {
    if (size == 1) {
      return FrameLayer.single;
    } else if (size == 2) {
      return FrameLayer.double;
    } else if (size == 3) {
      return FrameLayer.triple;
    } else if (size == 4) {
      return FrameLayer.fourth;
    } else if (size == 5) {
      return FrameLayer.fifth;
    } else if (size == 6) {
      return FrameLayer.sixth;
    } else if (size == 7) {
      return FrameLayer.seventh;
    } else if (size == 8) {
      return FrameLayer.eighth;
    } else if (size == 9) {
      return FrameLayer.ninth;
    } else if (size > 9) {
      return FrameLayer.multiple;
    } else {
      return FrameLayer.none;
    }
  }
}
