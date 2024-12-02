import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_game_start_probider.g.dart';

@riverpod
class IsGameStart extends _$IsGameStart {
  @override
  bool build() {
    return false;
  }

  void gameStart() {
    state = true;
  }

  void gameEnd() {
    state = false;
  }
}
