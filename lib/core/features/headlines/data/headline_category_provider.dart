import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';

part 'headline_category_provider.g.dart';

enum Category {
  business,
  entertainment,
  finance,
  gaming,
  music,
  politics,
  sport,
  tech,
  world,
}

@Riverpod(keepAlive: true)
class HeadlineCategory extends _$HeadlineCategory {
  Future<Category> _loadCategory() async {
    final prefs = await SharedPreferences.getInstance();
    final category = prefs.getString(userCategory) ?? 'tech';
    return Category.values
        .where((element) => element.toString().split('.').last == category)
        .first;
  }

  void _saveCategory(Category value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(userCategory, value.name);
  }

  @override
  Future<Category> build() async {
    return _loadCategory();
  }

  void updateCategory(Category category) async {
    state = const AsyncValue.loading();
    _saveCategory(category);
    state = await AsyncValue.guard(() => _loadCategory());
  }
}
