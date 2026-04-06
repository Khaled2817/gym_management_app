import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvgIcon extends StatelessWidget {
  final String assetName;
  final double width;
  final double height;
  final BoxFit fit;
  final LinearGradient? gradient;
  final Color? color;

  const AppSvgIcon({
    super.key,
    required this.assetName,
    this.width = 24,
    this.height = 24,
    this.fit = BoxFit.contain,
    this.gradient,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final svg = SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      fit: fit,
      colorFilter: gradient == null && color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );

    if (gradient != null) {
      return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => gradient!.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: svg,
      );
    }

    return svg;
  }
}
