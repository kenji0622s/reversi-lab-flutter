import 'dart:math';

class BasicLogics {
// ランダムに選ぶ
  static List<int> selectRandom(List<List<int>> availableCells) {
    final random = Random();
    final randomIndex = random.nextInt(availableCells.length);
    final randomCell = availableCells[randomIndex];
    return randomCell;
  }

// 角を選ぶ
  static List<int>? selectCorner(List<List<int>> availableCells) {
    const corners = [
      [1, 1],
      [1, 8],
      [8, 1],
      [8, 8],
    ];

    for (var i = 0; i < corners.length; i++) {
      final corner = corners[i];
      final canCorner = availableCells
          .any((cell) => cell[0] == corner[0] && cell[1] == corner[1]);
      if (canCorner) {
        return corner;
      }
    }
    return null;
  }

// 角の周りの隣を選ぶ
  static List<int>? selectAroundCornerNext(List<List<int>> availableCells) {
    final aroundCornerNextCells = [
      [1, 3],
      [1, 6],
      [2, 3],
      [2, 6],
      [3, 1],
      [3, 2],
      [3, 3],
      [3, 6],
      [3, 7],
      [3, 8],
      [6, 1],
      [6, 2],
      [6, 3],
      [6, 6],
      [6, 7],
      [6, 8],
      [7, 3],
      [7, 6],
      [8, 3],
      [8, 6],
    ];

    for (var i = 0; i < availableCells.length; i++) {
      final cell = availableCells[i];
      final isAroundCornerNext = aroundCornerNextCells.any(
          (aroundCornerNextCell) =>
              aroundCornerNextCell[0] == cell[0] &&
              aroundCornerNextCell[1] == cell[1]);
      if (isAroundCornerNext) {
        return cell;
      }
    }
    return null;
  }

  // 角の周りと角の周り以外に分ける
  static Map<String, List<List<int>>> filterAroundCorner(
      List<List<int>> availableCells) {
    final availableAroundCornerCells = <List<int>>[];
    final availableNotAroundCornerCells = <List<int>>[];

    const aroundCornerCells = [
      [1, 2],
      [1, 7],
      [2, 1],
      [2, 2],
      [2, 7],
      [2, 8],
      [7, 1],
      [7, 2],
      [7, 7],
      [7, 8],
      [8, 2],
      [8, 7],
    ];

    for (var cell in availableCells) {
      final isAroundCorner = aroundCornerCells.any(
        (aroundCornerCell) =>
            aroundCornerCell[0] == cell[0] && aroundCornerCell[1] == cell[1],
      );
      if (isAroundCorner) {
        availableAroundCornerCells.add(cell);
      } else {
        availableNotAroundCornerCells.add(cell);
      }
    }

    return {
      'availableAroundCornerCells': availableAroundCornerCells,
      'availableNotAroundCornerCells': availableNotAroundCornerCells,
    };
  }

// 中心の周りを選ぶ
  static List<int>? selectAroundCenter(List<List<int>> inputCells) {
    const aroundCenterCells = [
      [3, 3],
      [3, 4],
      [3, 5],
      [3, 6],
      [4, 3],
      [4, 6],
      [5, 3],
      [5, 6],
      [6, 3],
      [6, 4],
      [6, 5],
      [6, 6],
    ];

    for (var cell in inputCells) {
      final isAroundCenter = aroundCenterCells.any((aroundCenterCell) =>
          aroundCenterCell[0] == cell[0] && aroundCenterCell[1] == cell[1]);
      if (isAroundCenter) {
        return cell;
      }
    }
    return null;
  }

  // セルのレベルに応じて置く
  static List<int> putAccordingToCellLevel(List<List<int>> availableCells) {
    // point 30
    const level1 = [
      [1, 1],
      [1, 8],
      [8, 1],
      [8, 8],
    ];
    // point 2
    const level2 = [
      [1, 3],
      [1, 6],
      [3, 1],
      [3, 3],
      [3, 6],
      [3, 8],
      [6, 1],
      [6, 3],
      [6, 6],
      [6, 8],
      [8, 3],
      [8, 6],
    ];
    // point 1
    const level3 = [
      [1, 4],
      [1, 5],
      [4, 1],
      [4, 8],
      [5, 1],
      [5, 8],
      [8, 4],
      [8, 5],
    ];
    // point 0
    const level4 = [
      [3, 4],
      [3, 5],
      [4, 3],
      [4, 6],
      [5, 3],
      [5, 6],
      [6, 4],
      [6, 5],
    ];

    // point -3
    const level5 = [
      [2, 3],
      [2, 4],
      [2, 5],
      [2, 6],
      [3, 2],
      [3, 7],
      [4, 2],
      [4, 7],
      [5, 2],
      [5, 7],
      [6, 2],
      [6, 7],
      [7, 3],
      [7, 4],
      [7, 5],
      [7, 6],
    ];

    // point -10
    const level6 = [
      [1, 2],
      [1, 7],
      [2, 1],
      [2, 8],
      [7, 1],
      [7, 8],
      [8, 2],
      [8, 7],
    ];

    // point -20
    const level7 = [
      [2, 2],
      [2, 7],
      [7, 2],
      [7, 7],
    ];

    final levels = [level1, level2, level3, level4, level5, level6, level7];

    for (var i = 0; i < levels.length; i++) {
      final level = levels[i];
      for (var cell in level) {
        final canCell = availableCells.any(
          (availableCell) => availableCell[0] == cell[0] && availableCell[1] == cell[1],
        );
        if (canCell) {
          print("level" + (i + 1).toString());
          return cell;
        }
      }
    }
    return selectRandom(availableCells);
  }
}
