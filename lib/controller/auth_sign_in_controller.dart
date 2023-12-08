import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/auth_repository.dart';

part 'auth_sign_in_controller.g.dart';

@riverpod
class AuthSignInController extends _$AuthSignInController {
  @override
  FutureOr<void> build() {
    // nothing to do
  }

  Future<void> signIn(String email, String password) async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() => authRepository.signIn(email, password));
  }

  Future<void> register(
      String email, String password, String confirmPassword) async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() => authRepository.register(email, password));
  }
}
