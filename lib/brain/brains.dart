import 'logic/basic_logics.dart';

class BrainsList {
  static List<String> brains = [
    Brain1.name,
    Brain2.name,
    Brain3.name,
    Brain4.name,
    Brain5.name,
    Brain6.name,
  ];
}

// ランダムに選ぶ
class Brain1 {
  static String name = 'Brain1';
  static List<int> selectCell(List<List<int>> availableCells) {
    print(name);
    return BasicLogics.selectRandom(availableCells);
  }
}

// 角を選ぶ
class Brain2 {
  static String name = 'Brain2';
  static List<int> selectCell(List<List<int>> availableCells) {
    print(name);
    return BasicLogics.selectCorner(availableCells) ??
        BasicLogics.selectRandom(availableCells);
  }
}

// 角の周りを避ける
class Brain3 {
  static String name = 'Brain3';
  static List<int> selectCell(List<List<int>> availableCells) {
    print(name);
    if (BasicLogics.selectCorner(availableCells) != null) {
      return BasicLogics.selectCorner(availableCells)!;
    }

    final filteredCells = BasicLogics.filterAroundCorner(availableCells);
    final availableAroundCornerCells = filteredCells['availableAroundCornerCells'];
    final availableNotAroundCornerCells = filteredCells['availableNotAroundCornerCells'];
    if (availableNotAroundCornerCells != null && availableNotAroundCornerCells.isNotEmpty) {
      return BasicLogics.selectRandom(availableNotAroundCornerCells);
    }
    return BasicLogics.selectRandom(availableAroundCornerCells!);
  }
}

// 角の周りは避ける
class Brain4 {
  static String name = 'Brain4';
  static List<int> selectCell(List<List<int>> availableCells) {
    print(name);
    if (BasicLogics.selectCorner(availableCells) != null) {
      return BasicLogics.selectCorner(availableCells)!;
    }
    if (BasicLogics.selectAroundCornerNext(availableCells) != null) {
      return BasicLogics.selectAroundCornerNext(availableCells)!;
    }

    final filteredCells = BasicLogics.filterAroundCorner(availableCells);
    final availableAroundCornerCells = filteredCells['availableAroundCornerCells'];
    final availableNotAroundCornerCells = filteredCells['availableNotAroundCornerCells'];
    if (availableNotAroundCornerCells != null && availableNotAroundCornerCells.isNotEmpty) {
      return BasicLogics.selectRandom(availableNotAroundCornerCells);
    }
    return BasicLogics.selectRandom(availableAroundCornerCells!);
  }
}
// 中心の周りを選ぶ
class Brain5 {
  static String name = 'Brain5';
  static List<int> selectCell(List<List<int>> availableCells) {
    print(name);
    if (BasicLogics.selectCorner(availableCells) != null) {
      return BasicLogics.selectCorner(availableCells)!;
    }
    if (BasicLogics.selectAroundCornerNext(availableCells) != null) {
      return BasicLogics.selectAroundCornerNext(availableCells)!;
    }
    if (BasicLogics.selectAroundCenter(availableCells) != null) {
      return BasicLogics.selectAroundCenter(availableCells)!;
    }

    final filteredCells = BasicLogics.filterAroundCorner(availableCells);
    final availableAroundCornerCells = filteredCells['availableAroundCornerCells'];
    final availableNotAroundCornerCells = filteredCells['availableNotAroundCornerCells'];
    if (availableNotAroundCornerCells != null && availableNotAroundCornerCells.isNotEmpty) {
      return BasicLogics.selectRandom(availableNotAroundCornerCells);
    }
    return BasicLogics.selectRandom(availableAroundCornerCells!);
  }
}

// セルの優先順位に合わせて選ぶ
class Brain6 {
  static String name = 'Brain6';
  static List<int> selectCell(List<List<int>> availableCells) {
    print(name);
    return BasicLogics.putAccordingToCellLevel(availableCells);
  }
}
