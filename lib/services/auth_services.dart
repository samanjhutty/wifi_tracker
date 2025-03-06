import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/utils/app_constants.dart';
import '../model/utils/color_resources.dart';
import '../view_model/routes/app_routes.dart';

class AuthServeice extends GetxService {
  static AuthServeice? _instance;
  AuthServeice._init();
  static AuthServeice get instance => _instance ??= AuthServeice._init();

  final box = GetStorage();

  Future<AuthServeice> init() async {
    return this;
  }

  String get initialRoute {
    return AppRoutes.logger;
  }
}

extension HelperServices on AuthServeice {
  ThemeServices get theme => _getTheme();

  ThemeServices _getTheme() {
    String? value = box.read(BoxKeys.theme);

    return ThemeServices.values.firstWhere(
      (element) => element.title == value,
      orElse: () => ThemeServices.values.first,
    );
  }
}
