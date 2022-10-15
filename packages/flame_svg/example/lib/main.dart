import 'package:flame/game.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(child: GameWidget(game: MyGame())),
            const Expanded(child: RepaintBoundary(child: AnimatedBlock())),
          ],
        ),
      ),
    ),
  );
}

class MyGame extends FlameGame {
  late Svg svgInstance;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    svgInstance = await loadSvg('android.svg');
    for (var i = 0; i < 1000; i++) {
      final android = SvgComponent(
        svg: svgInstance,
        position: Vector2.all(100),
        size: Vector2.all(300),
      );
      add(android);
    }
  }
}

class AnimatedBlock extends StatefulWidget {
  const AnimatedBlock({super.key});

  @override
  State<AnimatedBlock> createState() => _AnimatedBlockState();
}

class _AnimatedBlockState extends State<AnimatedBlock> {
  Alignment alignment = Alignment.center;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        alignment = const Alignment(0, 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      alignment: alignment,
      duration: const Duration(seconds: 2),
      child: Container(
        width: 100,
        height: 100,
        color: Colors.red,
      ),
      onEnd: () {
        setState(() {
          alignment = Alignment(0, 1 - alignment.y);
        });
      },
    );
  }
}
