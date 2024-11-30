import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'brain_provider.g.dart';

@riverpod
class Brain extends _$Brain {
  @override
  String build() {
    return 'Brain1';
  }

  void selectBrain(String brain) {
    state = brain;
  }
}
