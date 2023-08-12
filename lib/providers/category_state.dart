import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'category_state.g.dart';

enum Category {
  business,
  entertainment,
  general,
  health,
  science,
  sports,
  technology,
}

@Riverpod(keepAlive: true)
class CategoryState extends _$CategoryState {
  void _loadCategory() async {
    final prefs = await SharedPreferences.getInstance();
    final category = prefs.getString('category') ?? 'entertainment';
    state = Category.values
        .where((element) => element.toString().split('.').last == category)
        .first;
  }

  void _saveCategory(Category value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('category', value.name);
  }

  @override
  Category build() {
    _loadCategory();
    return Category.entertainment;
  }

  void update(Category category) {
    state = category;
    _saveCategory(category);
  }
}
