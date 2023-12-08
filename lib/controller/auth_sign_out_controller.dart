import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/auth_repository.dart';

part 'auth_sign_out_controller.g.dart';

@riverpod
class AuthSignOutController extends _$AuthSignOutController {
  @override
  FutureOr<void> build() {
    // nothing to do
  }

  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.signOut());
  }
}
