import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';

class ContributorView<T extends Contributor> extends StatelessWidget {
  final double borderRadius;
  final double margin;
  final Color? background;
  final Stream<T> stream;
  final Widget renderView;
  final OnViewBuilder<T>? userView;

  const ContributorView({
    Key? key,
    this.background,
    this.borderRadius = 0,
    this.margin = 0,
    required this.renderView,
    this.userView,
    required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamView(
      stream: stream,
      margin: margin,
      background: background,
      borderRadius: borderRadius,
      builder: (context, value) {
        var item = value ?? ContributorImpl();
        return Stack(
          alignment: Alignment.center,
          children: [
            item.isCameraOn
                ? renderView
                : userView?.call(context, item as T) ??
                const ImageView(
                  width: 80,
                  height: 80,
                  shape: ViewShape.circular,
                  image:
                  "https://assets.materialup.com/uploads/b78ca002-cd6c-4f84-befb-c09dd9261025/preview.png",
                  scaleType: BoxFit.cover,
                ),
            Stack(
              alignment: Alignment.center,
              children: [
                if (item.isRiseHand)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.back_hand_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.isMuted ? Icons.mic_off : Icons.mic,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.more_vert,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }
    );
  }
}

abstract class Contributor extends Entity {
  final bool? cameraOn;
  final bool? muted;
  final bool? riseHand;
  final bool? shareScreen;

  Contributor({
    super.id,
    super.timeMills,
    this.cameraOn,
    this.muted,
    this.riseHand,
    this.shareScreen,
  });

  bool get isCameraOn => cameraOn ?? false;

  bool get isMuted => muted ?? false;

  bool get isRiseHand => riseHand ?? false;
}

class ContributorImpl extends Contributor {}
