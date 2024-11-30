import 'package:flutter/material.dart';
import 'package:reversi_lab/presentation/board/board.dart';
import 'package:reversi_lab/presentation/res/values/mode.dart';
import 'package:reversi_lab/presentation/widgets/my_app_bar.dart';

class PlayPage extends StatelessWidget {
  const PlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(title: 'Play'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Board(mode: Mode.play),
          ],
        ),
      ),
    );
  }
}
