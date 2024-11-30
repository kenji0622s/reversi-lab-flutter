import 'package:reversi_lab/brain/brains.dart';

class BoardValues {
  final List<List<int>> blackCells;
  final List<List<int>> whiteCells;
  final List<List<int>> blackAvailableCells;
  final List<List<int>> whiteAvailableCells;
  final String turn;

  BoardValues(this.blackCells, this.whiteCells, this.blackAvailableCells,
      this.whiteAvailableCells, this.turn);
}

class BoardController {
  final turns = ['black', 'white'];

  BoardValues updateBoard(
    List<int> selectedCell,
    List<List<int>> blackCells,
    List<List<int>> whiteCells,
    String turn,
  ) {
    if (turn == 'black') {
      blackCells.add(selectedCell);
    } else {
      whiteCells.add(selectedCell);
    }
    final usedCells = [...blackCells, ...whiteCells];
    final allDirectionCells =
        getAllDirectionCells(selectedCell[0], selectedCell[1]);

    for (final singleDirectionCells in allDirectionCells) {
      singleDirectionReverse(
          singleDirectionCells, blackCells, whiteCells, turn, turns);
    }

    final availableCells = updateAvailableCells(usedCells);
    final blackAvailableCells =
        updateBlackAvailableCells(availableCells, blackCells, whiteCells);
    final whiteAvailableCells =
        updateWhiteAvailableCells(availableCells, blackCells, whiteCells);

    if (turn == 'black' && whiteAvailableCells.isNotEmpty) {
      turn = 'white';
    } else if (turn == 'white' && blackAvailableCells.isNotEmpty) {
      turn = 'black';
    }
    return BoardValues(
        blackCells, whiteCells, blackAvailableCells, whiteAvailableCells, turn);
  }

  List<List<List<int>>> getAllDirectionCells(int row, int column) {
    List<List<int>> upperLeftCells = [];
    for (int i = 1; i <= 7; i++) {
      if (row - i > 0 && column - i > 0) {
        upperLeftCells.add([row - i, column - i]);
      }
    }

    List<List<int>> upperCells = [];
    for (int i = 1; i <= 7; i++) {
      if (row - i > 0) {
        upperCells.add([row - i, column]);
      }
    }

    List<List<int>> upperRightCells = [];
    for (int i = 1; i <= 7; i++) {
      if (row - i > 0 && column + i <= 8) {
        upperRightCells.add([row - i, column + i]);
      }
    }

    List<List<int>> leftCells = [];
    for (int i = 1; i <= 7; i++) {
      if (column - i > 0) {
        leftCells.add([row, column - i]);
      }
    }

    List<List<int>> rightCells = [];
    for (int i = 1; i <= 7; i++) {
      if (column + i <= 8) {
        rightCells.add([row, column + i]);
      }
    }

    List<List<int>> lowerLeftCells = [];
    for (int i = 1; i <= 7; i++) {
      if (row + i <= 8 && column - i > 0) {
        lowerLeftCells.add([row + i, column - i]);
      }
    }

    List<List<int>> lowerCells = [];
    for (int i = 1; i <= 7; i++) {
      if (row + i <= 8) {
        lowerCells.add([row + i, column]);
      }
    }

    List<List<int>> lowerRightCells = [];
    for (int i = 1; i <= 7; i++) {
      if (row + i <= 8 && column + i <= 8) {
        lowerRightCells.add([row + i, column + i]);
      }
    }

    List<List<List<int>>> allDirectionCells = [
      upperLeftCells,
      upperCells,
      upperRightCells,
      leftCells,
      rightCells,
      lowerLeftCells,
      lowerCells,
      lowerRightCells
    ];
    return allDirectionCells;
  }

  // 石をひっくり返す処理
  void singleDirectionReverse(
    List<List<int>> singleDirectionCells,
    List<List<int>> blackCells,
    List<List<int>> whiteCells,
    String turn,
    List<String> turns,
  ) {
    List<bool> blackJudges = [];
    for (var cell in singleDirectionCells) {
      blackJudges.add(blackCells.any(
          (blackCell) => blackCell[0] == cell[0] && blackCell[1] == cell[1]));
    }
    List<bool> whiteJudges = [];
    for (var cell in singleDirectionCells) {
      whiteJudges.add(whiteCells.any(
          (whiteCell) => whiteCell[0] == cell[0] && whiteCell[1] == cell[1]));
    }

    if (turn == turns[0]) {
      if (whiteJudges.isNotEmpty &&
          whiteJudges[0] &&
          blackJudges.length > 1 &&
          blackJudges[1]) {
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[0][0] &&
            whiteCell[1] == singleDirectionCells[0][1]);
        blackCells.add(singleDirectionCells[0]);
      }
      if (whiteJudges.length > 1 &&
          whiteJudges[0] &&
          whiteJudges[1] &&
          blackJudges.length > 2 &&
          blackJudges[2]) {
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[0][0] &&
            whiteCell[1] == singleDirectionCells[0][1]);
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[1][0] &&
            whiteCell[1] == singleDirectionCells[1][1]);
        blackCells.addAll([singleDirectionCells[0], singleDirectionCells[1]]);
      }
      if (whiteJudges.length > 2 &&
          whiteJudges[0] &&
          whiteJudges[1] &&
          whiteJudges[2] &&
          blackJudges.length > 3 &&
          blackJudges[3]) {
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[0][0] &&
            whiteCell[1] == singleDirectionCells[0][1]);
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[1][0] &&
            whiteCell[1] == singleDirectionCells[1][1]);
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[2][0] &&
            whiteCell[1] == singleDirectionCells[2][1]);
        blackCells.addAll([
          singleDirectionCells[0],
          singleDirectionCells[1],
          singleDirectionCells[2]
        ]);
      }
      if (whiteJudges.length > 3 &&
          whiteJudges[0] &&
          whiteJudges[1] &&
          whiteJudges[2] &&
          whiteJudges[3] &&
          blackJudges.length > 4 &&
          blackJudges[4]) {
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[0][0] &&
            whiteCell[1] == singleDirectionCells[0][1]);
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[1][0] &&
            whiteCell[1] == singleDirectionCells[1][1]);
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[2][0] &&
            whiteCell[1] == singleDirectionCells[2][1]);
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[3][0] &&
            whiteCell[1] == singleDirectionCells[3][1]);
        blackCells.addAll([
          singleDirectionCells[0],
          singleDirectionCells[1],
          singleDirectionCells[2],
          singleDirectionCells[3]
        ]);
      }
      if (whiteJudges.length > 4 &&
          whiteJudges[0] &&
          whiteJudges[1] &&
          whiteJudges[2] &&
          whiteJudges[3] &&
          whiteJudges[4] &&
          blackJudges.length > 5 &&
          blackJudges[5]) {
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[0][0] &&
            whiteCell[1] == singleDirectionCells[0][1]);
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[1][0] &&
            whiteCell[1] == singleDirectionCells[1][1]);
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[2][0] &&
            whiteCell[1] == singleDirectionCells[2][1]);
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[3][0] &&
            whiteCell[1] == singleDirectionCells[3][1]);
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[4][0] &&
            whiteCell[1] == singleDirectionCells[4][1]);
        blackCells.addAll([
          singleDirectionCells[0],
          singleDirectionCells[1],
          singleDirectionCells[2],
          singleDirectionCells[3],
          singleDirectionCells[4]
        ]);
      }
      if (whiteJudges.length > 5 &&
          whiteJudges[0] &&
          whiteJudges[1] &&
          whiteJudges[2] &&
          whiteJudges[3] &&
          whiteJudges[4] &&
          whiteJudges[5] &&
          blackJudges.length > 6 &&
          blackJudges[6]) {
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[0][0] &&
            whiteCell[1] == singleDirectionCells[0][1]);
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[1][0] &&
            whiteCell[1] == singleDirectionCells[1][1]);
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[2][0] &&
            whiteCell[1] == singleDirectionCells[2][1]);
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[3][0] &&
            whiteCell[1] == singleDirectionCells[3][1]);
        whiteCells.removeWhere((whiteCell) =>
            whiteCell[0] == singleDirectionCells[4][0] &&
            whiteCell[1] == singleDirectionCells[4][1]);
        blackCells.addAll([
          singleDirectionCells[0],
          singleDirectionCells[1],
          singleDirectionCells[2],
          singleDirectionCells[3],
          singleDirectionCells[4],
          singleDirectionCells[5]
        ]);
      }
    } else {
      if (blackJudges.isNotEmpty &&
          blackJudges[0] &&
          whiteJudges.length > 1 &&
          whiteJudges[1]) {
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[0][0] &&
            blackCell[1] == singleDirectionCells[0][1]);
        whiteCells.add(singleDirectionCells[0]);
      }
      if (blackJudges.length > 1 &&
          blackJudges[0] &&
          blackJudges[1] &&
          whiteJudges.length > 2 &&
          whiteJudges[2]) {
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[0][0] &&
            blackCell[1] == singleDirectionCells[0][1]);
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[1][0] &&
            blackCell[1] == singleDirectionCells[1][1]);
        whiteCells.addAll([singleDirectionCells[0], singleDirectionCells[1]]);
      }
      if (blackJudges.length > 2 &&
          blackJudges[0] &&
          blackJudges[1] &&
          blackJudges[2] &&
          whiteJudges.length > 3 &&
          whiteJudges[3]) {
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[0][0] &&
            blackCell[1] == singleDirectionCells[0][1]);
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[1][0] &&
            blackCell[1] == singleDirectionCells[1][1]);
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[2][0] &&
            blackCell[1] == singleDirectionCells[2][1]);
        whiteCells.addAll([
          singleDirectionCells[0],
          singleDirectionCells[1],
          singleDirectionCells[2]
        ]);
      }
      if (blackJudges.length > 3 &&
          blackJudges[0] &&
          blackJudges[1] &&
          blackJudges[2] &&
          blackJudges[3] &&
          whiteJudges.length > 4 &&
          whiteJudges[4]) {
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[0][0] &&
            blackCell[1] == singleDirectionCells[0][1]);
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[1][0] &&
            blackCell[1] == singleDirectionCells[1][1]);
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[2][0] &&
            blackCell[1] == singleDirectionCells[2][1]);
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[3][0] &&
            blackCell[1] == singleDirectionCells[3][1]);
        whiteCells.addAll([
          singleDirectionCells[0],
          singleDirectionCells[1],
          singleDirectionCells[2],
          singleDirectionCells[3]
        ]);
      }
      if (blackJudges.length > 4 &&
          blackJudges[0] &&
          blackJudges[1] &&
          blackJudges[2] &&
          blackJudges[3] &&
          blackJudges[4] &&
          whiteJudges.length > 5 &&
          whiteJudges[5]) {
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[0][0] &&
            blackCell[1] == singleDirectionCells[0][1]);
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[1][0] &&
            blackCell[1] == singleDirectionCells[1][1]);
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[2][0] &&
            blackCell[1] == singleDirectionCells[2][1]);
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[3][0] &&
            blackCell[1] == singleDirectionCells[3][1]);
        whiteCells.addAll([
          singleDirectionCells[0],
          singleDirectionCells[1],
          singleDirectionCells[2],
          singleDirectionCells[3],
          singleDirectionCells[4]
        ]);
      }
      if (blackJudges.length > 5 &&
          blackJudges[0] &&
          blackJudges[1] &&
          blackJudges[2] &&
          blackJudges[3] &&
          blackJudges[4] &&
          blackJudges[5] &&
          whiteJudges.length > 6 &&
          whiteJudges[6]) {
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[0][0] &&
            blackCell[1] == singleDirectionCells[0][1]);
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[1][0] &&
            blackCell[1] == singleDirectionCells[1][1]);
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[2][0] &&
            blackCell[1] == singleDirectionCells[2][1]);
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[3][0] &&
            blackCell[1] == singleDirectionCells[3][1]);
        blackCells.removeWhere((blackCell) =>
            blackCell[0] == singleDirectionCells[4][0] &&
            blackCell[1] == singleDirectionCells[4][1]);
        whiteCells.addAll([
          singleDirectionCells[0],
          singleDirectionCells[1],
          singleDirectionCells[2],
          singleDirectionCells[3],
          singleDirectionCells[4],
          singleDirectionCells[5]
        ]);
      }
    }
  }

  List<List<int>> updateAvailableCells(List<List<int>> usedCells) {
    List<List<int>> availableCells = [];
    for (int i = 1; i <= 8; i++) {
      for (int j = 1; j <= 8; j++) {
        if (!usedCells
            .any((usedCell) => usedCell[0] == i && usedCell[1] == j)) {
          availableCells.add([i, j]);
        }
      }
    }
    return availableCells;
  }

  List<List<int>> updateBlackAvailableCells(List<List<int>> availableCells,
      List<List<int>> blackCells, List<List<int>> whiteCells) {
    List<List<int>> blackAvailableCells = [];
    for (int i = 0; i < availableCells.length; i++) {
      final allDirectionCells =
          getAllDirectionCells(availableCells[i][0], availableCells[i][1]);
      for (int j = 0; j < allDirectionCells.length; j++) {
        if (checkSingleDirectionCells(
            allDirectionCells[j], blackCells, whiteCells, "black")) {
          blackAvailableCells.add(availableCells[i]);
          break;
        }
      }
    }
    return blackAvailableCells;
  }

  List<List<int>> updateWhiteAvailableCells(List<List<int>> availableCells,
      List<List<int>> blackCells, List<List<int>> whiteCells) {
    List<List<int>> whiteAvailableCells = [];
    for (int i = 0; i < availableCells.length; i++) {
      final allDirectionCells =
          getAllDirectionCells(availableCells[i][0], availableCells[i][1]);
      for (int j = 0; j < allDirectionCells.length; j++) {
        if (checkSingleDirectionCells(
            allDirectionCells[j], blackCells, whiteCells, "white")) {
          whiteAvailableCells.add(availableCells[i]);
          break;
        }
      }
    }
    return whiteAvailableCells;
  }

  bool checkSingleDirectionCells(List<List<int>> singleDirectionCells,
      List<List<int>> blackCells, List<List<int>> whiteCells, String turn) {
    List<bool> blackJudges = [];

    for (var cell in singleDirectionCells) {
      blackJudges.add(blackCells.any(
          (blackCell) => blackCell[0] == cell[0] && blackCell[1] == cell[1]));
    }

    List<bool> whiteJudges = [];
    for (var cell in singleDirectionCells) {
      whiteJudges.add(whiteCells.any(
          (whiteCell) => whiteCell[0] == cell[0] && whiteCell[1] == cell[1]));
    }
    if (turn == "black") {
      if (whiteJudges.isNotEmpty &&
          whiteJudges[0] &&
          blackJudges.length > 1 &&
          blackJudges[1]) return true;
      if (whiteJudges.length > 1 &&
          whiteJudges[0] &&
          whiteJudges[1] &&
          blackJudges.length > 2 &&
          blackJudges[2]) return true;
      if (whiteJudges.length > 2 &&
          whiteJudges[0] &&
          whiteJudges[1] &&
          whiteJudges[2] &&
          blackJudges.length > 3 &&
          blackJudges[3]) return true;
      if (whiteJudges.length > 3 &&
          whiteJudges[0] &&
          whiteJudges[1] &&
          whiteJudges[2] &&
          whiteJudges[3] &&
          blackJudges.length > 4 &&
          blackJudges[4]) return true;
      if (whiteJudges.length > 4 &&
          whiteJudges[0] &&
          whiteJudges[1] &&
          whiteJudges[2] &&
          whiteJudges[3] &&
          whiteJudges[4] &&
          blackJudges.length > 5 &&
          blackJudges[5]) return true;
      if (whiteJudges.length > 5 &&
          whiteJudges[0] &&
          whiteJudges[1] &&
          whiteJudges[2] &&
          whiteJudges[3] &&
          whiteJudges[4] &&
          whiteJudges[5] &&
          blackJudges.length > 6 &&
          blackJudges[6]) return true;
      return false;
    }
    if (turn == "white") {
      if (blackJudges.isNotEmpty &&
          blackJudges[0] &&
          whiteJudges.length > 1 &&
          whiteJudges[1]) return true;
      if (blackJudges.length > 1 &&
          blackJudges[0] &&
          blackJudges[1] &&
          whiteJudges.length > 2 &&
          whiteJudges[2]) return true;
      if (blackJudges.length > 2 &&
          blackJudges[0] &&
          blackJudges[1] &&
          blackJudges[2] &&
          whiteJudges.length > 3 &&
          whiteJudges[3]) return true;
      if (blackJudges.length > 3 &&
          blackJudges[0] &&
          blackJudges[1] &&
          blackJudges[2] &&
          blackJudges[3] &&
          whiteJudges.length > 4 &&
          whiteJudges[4]) return true;
      if (blackJudges.length > 4 &&
          blackJudges[0] &&
          blackJudges[1] &&
          blackJudges[2] &&
          blackJudges[3] &&
          blackJudges[4] &&
          whiteJudges.length > 5 &&
          whiteJudges[5]) return true;
      if (blackJudges.length > 5 &&
          blackJudges[0] &&
          blackJudges[1] &&
          blackJudges[2] &&
          blackJudges[3] &&
          blackJudges[4] &&
          blackJudges[5] &&
          whiteJudges.length > 6 &&
          whiteJudges[6]) return true;
      return false;
    }
    return false;
  }

  askBrain(List<List<int>> availableCells, String brain) {
    switch (brain) {
      case 'Brain1':
        return Brain1.selectCell(availableCells);
      case 'Brain2':
        return Brain2.selectCell(availableCells);
      case 'Brain3':
        return Brain3.selectCell(availableCells);
      case 'Brain4':
        return Brain4.selectCell(availableCells);
      case 'Brain5':
        return Brain5.selectCell(availableCells);
      case 'Brain6':
        return Brain6.selectCell(availableCells);
    }
  }
}
