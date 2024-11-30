import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'brain_turn_provider.g.dart';

@riverpod
class BrainTurn extends _$BrainTurn {
  @override
  String build() {
    return 'white';
  }

  void setBrainTurn({required userTurn}) {
    if (userTurn == 'black') {
      state = 'white';
    } else {
      state = 'black';
    }
  }
}
