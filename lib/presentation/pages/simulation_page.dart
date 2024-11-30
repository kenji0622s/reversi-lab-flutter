import 'package:flutter/material.dart';
import 'package:reversi_lab/presentation/res/values/app_colors.dart';
import 'package:reversi_lab/presentation/board/board.dart';
import 'package:reversi_lab/presentation/res/values/mode.dart';
class SimulationPage extends StatelessWidget {
  const SimulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reversi Lab',
          style: TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.emerald_500,
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Board(mode: Mode.simulation),
          ],
        ),
      ),
    );
  }
}
