import 'package:news_app/providers/category_state.dart';
import 'package:news_app/providers/country_state.dart';
import 'package:news_app/providers/domains_state.dart';
import 'package:news_app/providers/sort_by_state.dart';
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

    // dispose all providers
    ref.invalidate(categoryStateProvider);
    ref.invalidate(countriesStateProvider);
    ref.invalidate(domainsProvider);
    ref.invalidate(sortByStateProvider);

    // sign out
    state = await AsyncValue.guard(() => authRepository.signOut());
  }
}
