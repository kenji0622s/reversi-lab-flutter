import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reversi_lab/presentation/res/values/app_colors.dart';

class Board extends HookWidget {
  const Board({super.key});

  Color setCellColor(
      int i, int j, List<List<int>> black, List<List<int>> white) {
    if (black.any((element) => element[0] == i && element[1] == j)) {
      return AppColors.neutral_900;
    }
    if (white.any((element) => element[0] == i && element[1] == j)) {
      return AppColors.neutral_50;
    }
    return Colors.transparent;
  }

  Color setTextColor(
      int i, int j, List<List<int>> black, List<List<int>> white) {
    if (black.any((element) => element[0] == i && element[1] == j)) {
      return AppColors.neutral_50;
    }
    return AppColors.neutral_900;
  }

  @override
  Widget build(BuildContext context) {
    final blackCells = useState<List<List<int>>>([
      [4, 4],
      [5, 5]
    ]);
    final whiteCells = useState<List<List<int>>>([
      [4, 5],
      [5, 4]
    ]);
    final usedCells = useState<List<List<int>>>([]);
    useEffect(() {
      usedCells.value = [
        ...blackCells.value,
        ...whiteCells.value
      ];
      return null;
    }, [blackCells.value, whiteCells.value]);

    print(usedCells.value);

    final turn = useState<String>('black');

    void selectCell(int i, int j) {
      if (usedCells.value.any((element) => element[0] == i && element[1] == j)) {
        return;
      }
      if (turn.value == 'black') {
        final newBlack = [...blackCells.value];
        newBlack.add([i, j]);
        blackCells.value = newBlack;
        turn.value = 'white';
      } else {
        final newWhite = [...whiteCells.value];
        newWhite.add([i, j]);
        whiteCells.value = newWhite;
        turn.value = 'black';
      }
    }

    return SizedBox(
      width: 300,
      height: 300,
      child: Table(
        children: <TableRow>[
          for (int i = 1; i < 9; i++)
            TableRow(
              children: <Widget>[
                for (int j = 1; j < 9; j++)
                  InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      width: 37.5,
                      height: 37.5,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.neutral_900),
                        color: AppColors.emerald_500,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: setCellColor(i, j, blackCells.value, whiteCells.value),
                        ),
                        child: Text(
                          '$i,$j',
                          style: TextStyle(
                            color: setTextColor(i, j, blackCells.value, whiteCells.value),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      selectCell(i, j);
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
