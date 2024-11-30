import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:reversi_lab/providers/brain_provider.dart';
import 'package:reversi_lab/presentation/res/values/app_colors.dart';
import 'package:reversi_lab/presentation/board/board.dart';
import 'package:reversi_lab/presentation/res/values/mode.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_lab/brain/brains.dart';
import 'package:reversi_lab/providers/brain_turn_provider.dart';
import 'package:reversi_lab/presentation/widgets/my_app_bar.dart';

class ChallengePage extends StatelessWidget {
  ChallengePage({super.key});

  final List<String> brainsList = BrainsList.brains;

  @override
  Widget build(BuildContext context) {
    void showSelectBrainDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierColor: AppColors.black.withOpacity(0.75),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: AppColors.white,
            surfaceTintColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    '先行・後攻を選択',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Consumer(
                    builder: (context, ref, child) {
                      final brainTurn = ref.watch(brainTurnProvider);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: AppColors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: brainTurn == 'white'
                                    ? const BorderSide(
                                        color: AppColors.emerald_500,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              onPressed: () {
                                ref
                                    .read(brainTurnProvider.notifier)
                                    .setBrainTurn(userTurn: 'black');
                              },
                              child: const Text(
                                '先行',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: AppColors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: brainTurn == 'black'
                                    ? const BorderSide(
                                        color: AppColors.emerald_500,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              onPressed: () {
                                ref
                                    .read(brainTurnProvider.notifier)
                                    .setBrainTurn(userTurn: 'white');
                              },
                              child: const Text(
                                '後攻',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '対戦相手のレベルを選択',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Consumer(
                    builder: (context, ref, child) {
                      final brain = ref.watch(brainProvider);
                      return SizedBox(
                        width: 140,
                        child: DropdownButton(
                          isExpanded: true,
                          value: brain,
                          items: brainsList
                              .map((brainOption) => DropdownMenuItem<String>(
                                  value: brainOption,
                                  child: Text(brainOption,
                                      style: const TextStyle(fontSize: 16))))
                              .toList(),
                          onChanged: (String? value) {
                            ref
                                .read(brainProvider.notifier)
                                .selectBrain(value ?? '');
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald_500,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'ゲーム開始',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSelectBrainDialog(context);
    });

    return const Scaffold(
      appBar: MyAppBar(title: 'Challenge', isChallenge: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Board(mode: Mode.challenge),
          ],
        ),
      ),
    );
  }
}
