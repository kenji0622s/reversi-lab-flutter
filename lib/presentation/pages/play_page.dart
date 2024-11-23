import 'package:flutter/material.dart';
import 'package:reversi_lab/presentation/res/values/app_colors.dart';
import 'package:reversi_lab/presentation/parts/board.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reversi Lab',
          style: TextStyle(
              color: AppColors.neutral_50,
              fontSize: 22,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.emerald_500,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home Page'),
            Board(),
          ],
        ),
      ),
    );
  }
}
