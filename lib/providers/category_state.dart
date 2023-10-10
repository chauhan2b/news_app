import 'package:news_app/constants/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'category_state.g.dart';

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
class CategoryState extends _$CategoryState {
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
