import 'package:get_storage/get_storage.dart';
import '../model/utils/app_constants.dart';
import '../model/utils/color_resources.dart';

class BoxServices {
  static BoxServices? _to;
  static BoxServices get to => _to ??= BoxServices._init();

  BoxServices._init();

  final box = GetStorage(BoxKeys.boxName);

  ThemeServices getTheme() {
    String? title = box.read(BoxKeys.theme);
    return ThemeServices.values.firstWhere(
      (element) => element.title == title,
      orElse: () => ThemeServices.values.first,
    );
  }

  Future<void> saveTheme(ThemeServices theme) async {
    await box.write(BoxKeys.theme, theme.title);
  }

  Future<void> write(String key, dynamic value) async {
    await box.write(key, value);
  }

  T? read<T>(String key) => box.read<T>(key);

  bool exist(String key) => box.hasData(key);

  Future<void> remove(String key) => box.remove(key);

  Future<void> clear() async => await box.erase();
}
