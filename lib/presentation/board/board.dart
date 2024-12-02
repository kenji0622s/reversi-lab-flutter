import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reversi_lab/controllers/board_controller.dart';
import 'package:reversi_lab/presentation/res/values/app_colors.dart';
import 'package:reversi_lab/presentation/res/values/mode.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_lab/providers/brain_provider.dart';
import 'package:reversi_lab/providers/brain_turn_provider.dart';
import 'package:reversi_lab/providers/is_game_start_probider.dart';
import 'package:reversi_lab/brain/logic/basic_logics.dart';

class Board extends HookConsumerWidget {
  const Board({super.key, required this.mode});
  final Mode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brain = ref.watch(brainProvider);
    final brainTurn = ref.watch(brainTurnProvider);
    final isGameStart = ref.watch(isGameStartProvider);
    final blackCells = useState<List<List<int>>>([
      [4, 4],
      [5, 5]
    ]);
    final whiteCells = useState<List<List<int>>>([
      [4, 5],
      [5, 4]
    ]);
    final blackAvailableCells = useState<List<List<int>>>([
      [3, 5],
      [4, 6],
      [5, 3],
      [6, 4]
    ]);
    final whiteAvailableCells = useState<List<List<int>>>([]);
    final turn = useState<String>('black');

    final boardController = BoardController();

    Future<String> showEndMessage(
        List<List<int>> blackCells, List<List<int>> whiteCells) async {
      late String message;
      if (blackCells.length > whiteCells.length) {
        message = '黒の勝利';
      } else if (blackCells.length < whiteCells.length) {
        message = '白の勝利';
      } else {
        message = '引き分け';
      }
      final result = await showDialog<String>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(message,
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, 'retry');
                    },
                    child: const Text("もう一度", style: TextStyle(fontSize: 18)),
                  ),
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("閉じる", style: TextStyle(fontSize: 18)),
                  ),
                ],
              )
            ],
          );
        },
      );
      return result ?? 'close';
    }

    void retry() {
      blackCells.value = [
        [4, 4],
        [5, 5]
      ];
      whiteCells.value = [
        [4, 5],
        [5, 4]
      ];
      blackAvailableCells.value = [
        [3, 5],
        [4, 6],
        [5, 3],
        [6, 4]
      ];
      whiteAvailableCells.value = [];
      turn.value = 'black';
      ref.read(isGameStartProvider.notifier).gameStart();
    }

    Future<void> gameEnd() async {
      ref.read(isGameStartProvider.notifier).gameEnd();
      final endMessageResult =
          await showEndMessage(blackCells.value, whiteCells.value);
      if (endMessageResult == 'retry') {
        retry();
      }
    }

    void printDuplicateCells(
        List<List<int>> blackCells, List<List<int>> whiteCells) {
      // セットを使用して重複を確認
      final Set<String> blackSet =
          blackCells.map((cell) => '${cell[0]},${cell[1]}').toSet();
      final Set<String> whiteSet =
          whiteCells.map((cell) => '${cell[0]},${cell[1]}').toSet();

      // 重複を見つける
      final duplicates = blackSet.intersection(whiteSet);

      // 重複したセルを出力
      if (duplicates.isNotEmpty) {
        print('重複したセル:');
        for (var cell in duplicates) {
          print(cell);
        }
      }
    }

    Future<void> selectCell(List<int> selectedCell) async {
      final usedCells = [...blackCells.value, ...whiteCells.value];
      final isUsedCell = usedCells.any((element) =>
          element[0] == selectedCell[0] && element[1] == selectedCell[1]);
      final isBlackUnavailableCell = turn.value == 'black' &&
          !blackAvailableCells.value.any((element) =>
              element[0] == selectedCell[0] && element[1] == selectedCell[1]);
      final isWhiteUnavailableCell = turn.value == 'white' &&
          !whiteAvailableCells.value.any((element) =>
              element[0] == selectedCell[0] && element[1] == selectedCell[1]);
      if (isUsedCell || isBlackUnavailableCell || isWhiteUnavailableCell) {
        return;
      }

      final boardValues = boardController.updateBoard(
          selectedCell, blackCells.value, whiteCells.value, turn.value);

      // UIの更新(useStateの更新)
      blackCells.value = boardValues.blackCells;
      whiteCells.value = boardValues.whiteCells;
      blackAvailableCells.value = boardValues.blackAvailableCells;
      whiteAvailableCells.value = boardValues.whiteAvailableCells;
      turn.value = boardValues.turn;

      printDuplicateCells(blackCells.value, whiteCells.value);
      if (blackAvailableCells.value.isEmpty &&
          whiteAvailableCells.value.isEmpty) {
        gameEnd();
        return;
      }

      if (mode == Mode.challenge &&
          turn.value == 'black' &&
          brainTurn == 'black') {
        Future.delayed(const Duration(milliseconds: 100), () {
          final answerCell =
              boardController.askBrain(blackAvailableCells.value, brain);
          selectCell(answerCell);
        });
      }
      if (mode == Mode.challenge &&
          turn.value == 'white' &&
          brainTurn == 'white') {
        Future.delayed(const Duration(milliseconds: 100), () {
          final answerCell =
              boardController.askBrain(whiteAvailableCells.value, brain);
          selectCell(answerCell);
        });
      }
    }

    useEffect(() {
      if (isGameStart && brainTurn == 'black') {
        selectCell(BasicLogics.selectRandom(blackAvailableCells.value));
      }
      return null;
    }, [isGameStart]);

    double boardSize = MediaQuery.of(context).size.width - 30;
    double cellSize = boardSize / 8;
    double stoneSize = cellSize * 0.8;

    Color setCellColor(int row, int column, List<List<int>> blackCells,
        List<List<int>> whiteCells) {
      if (blackCells
          .any((element) => element[0] == row && element[1] == column)) {
        return AppColors.black;
      }
      if (whiteCells
          .any((element) => element[0] == row && element[1] == column)) {
        return AppColors.white;
      }
      if (turn.value == 'black' &&
          blackAvailableCells.value
              .any((element) => element[0] == row && element[1] == column)) {
        return AppColors.availableCell;
      }
      if (turn.value == 'white' &&
          whiteAvailableCells.value
              .any((element) => element[0] == row && element[1] == column)) {
        return AppColors.availableCell;
      }
      return Colors.transparent;
    }

    BorderRadius setRadius(int row, int column, List<List<int>> blackCells,
        List<List<int>> whiteCells) {
      if (blackCells
              .any((element) => element[0] == row && element[1] == column) ||
          whiteCells
              .any((element) => element[0] == row && element[1] == column)) {
        return BorderRadius.circular(100);
      }
      if (turn.value == 'black' &&
          blackAvailableCells.value
              .any((element) => element[0] == row && element[1] == column)) {
        return BorderRadius.circular(0);
      }
      if (turn.value == 'white' &&
          whiteAvailableCells.value
              .any((element) => element[0] == row && element[1] == column)) {
        return BorderRadius.circular(0);
      }
      return BorderRadius.circular(0);
    }

    Color setTextColor(int row, int column, List<List<int>> blackCells,
        List<List<int>> whiteCells) {
      if (blackCells
          .any((element) => element[0] == row && element[1] == column)) {
        return AppColors.white;
      }
      return AppColors.black;
    }

    return Column(
      children: [
        Text(turn.value == 'black' ? '黒の番' : '白の番',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('黒: ${blackCells.value.length} | 白: ${whiteCells.value.length}',
            style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        SizedBox(
          width: boardSize,
          height: boardSize,
          child: Table(
            children: <TableRow>[
              for (int row = 1; row < 9; row++)
                TableRow(
                  children: <Widget>[
                    for (int column = 1; column < 9; column++)
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.black, width: 0.2),
                            color: AppColors.boardGreen,
                          ),
                          alignment: Alignment.center,
                          width: cellSize,
                          height: cellSize,
                          child: Container(
                            alignment: Alignment.center,
                            height: stoneSize,
                            width: stoneSize,
                            decoration: BoxDecoration(
                              borderRadius: setRadius(row, column,
                                  blackCells.value, whiteCells.value),
                              color: setCellColor(row, column, blackCells.value,
                                  whiteCells.value),
                            ),
                            // child: Text(
                            //   '$row,$column',
                            //   style: TextStyle(
                            //     color: setTextColor(row, column,
                            //         blackCells.value, whiteCells.value),
                            //     fontSize: 12,
                            //   ),
                            // ),
                          ),
                        ),
                        onTap: () {
                          selectCell([row, column]);
                        },
                      ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
