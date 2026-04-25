import 'dart:math' as math;
import 'package:flutter/material.dart';

class FishAssetImage extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final double rotationRadians;
  final bool flipHorizontally;

  const FishAssetImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.rotationRadians = 0,
    this.flipHorizontally = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );

    if (flipHorizontally) {
      image = Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: image,
      );
    }

    if (rotationRadians != 0) {
      image = Transform.rotate(
        angle: rotationRadians,
        child: image,
      );
    }

    return image;
  }
}
