import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

Picture? pic;
DrawableRoot? svgRoot;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var t = 0;
  var lastMs = 0;
  WidgetsBinding.instance.window.onBeginFrame = (dt) {
    t++;
    print(dt.inMilliseconds - lastMs);
    lastMs = dt.inMilliseconds;
    if (pic != null) {
      final builder = SceneBuilder();
      for (var i = 0; i < 1000; i++) {
        builder.addPicture(
          Offset(i.toDouble() + t, 0),
          pic!,
        );
      }
      WidgetsBinding.instance.window.render(builder.build());
    }
    // if (svgRoot != null) {
    //   final builder = SceneBuilder();
    //   for (var i = 0; i < 1000; i++) {
    //     builder.addPicture(
    //       Offset(i.toDouble() + t, 0),
    //       svgRoot!.toPicture(size: const Size(200, 200)),
    //     );
    //   }
    //   WidgetsBinding.instance.window.render(builder.build());
    // }
    WidgetsBinding.instance.window.scheduleFrame();
  };
  WidgetsBinding.instance.window.scheduleFrame();
  load().then((value) => pic = value);
  // loadSvg();
}

Future<void> loadSvg() async {
  svgRoot = await svg.fromSvgString(
    await rootBundle.loadString('assets/android.svg'),
    'hand',
  );
}

Future<Picture> load() async {
  svgRoot = await svg.fromSvgString(
    await rootBundle.loadString('assets/android.svg'),
    'hand',
  );
  return svgRoot!.toPicture(size: const Size(200, 200));
}
