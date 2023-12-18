import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_register_provider.g.dart';

@riverpod
class AuthRegister extends _$AuthRegister {
  @override
  bool build() {
    return false;
  }

  void toggleRegister() {
    state = !state;
  }
}
