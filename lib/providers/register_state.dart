import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_state.g.dart';

@riverpod
class RegisterState extends _$RegisterState {
  @override
  bool build() {
    return false;
  }

  void toggleRegister() {
    state = !state;
  }
}
