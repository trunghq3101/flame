import 'dart:io';

import 'package:flame/extensions.dart';
import 'package:flame_svg/svg.dart' as flame_svg;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class SvgPainter extends CustomPainter {
  final flame_svg.Svg svg;

  SvgPainter(this.svg);

  @override
  void paint(Canvas canvas, Size size) {
    svg.render(canvas, Vector2(size.width, size.height));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  testGoldens('Smooth image', (tester) async {
    final svgRoot = await svg.fromSvgString(
      File('test/assets/hand.svg').readAsStringSync(),
      'hand',
    );
    final flameSvg = flame_svg.Svg(svgRoot);
    await flameSvg.populateImageCache(const Size(500, 500));
    await tester.pumpWidgetBuilder(
      UnconstrainedBox(
        child: CustomPaint(
          size: const Size(500, 500),
          painter: SvgPainter(flameSvg),
        ),
      ),
    );
    await screenMatchesGolden(tester, 'smooth_rendered_image');
  });
}
