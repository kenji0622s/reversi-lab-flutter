import 'package:flutter/material.dart';
import 'package:reversi_lab/presentation/res/values/app_colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_lab/providers/brain_provider.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, required this.title, this.isChallenge = false});
  final String title;
  final bool isChallenge;

  TextStyle get textStyle => const TextStyle(
      color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isChallenge
          ? Consumer(
              builder: (context, ref, child) => Text(
                'vs ${ref.watch(brainProvider)}',
                style: textStyle,
              ),
            )
          : Text(
              title,
              style: textStyle,
            ),
      backgroundColor: AppColors.emerald_500,
      iconTheme: const IconThemeData(color: AppColors.white, size: 24),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
