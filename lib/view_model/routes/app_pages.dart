import 'package:get/get.dart';
import 'package:wifi_tracker/view/home_screen/logger_screen.dart';
import '../../services/auth_services.dart';
import '../../view/home_screen/wifi_screen.dart';
import '../bindings/root_bindings.dart';
import 'app_routes.dart';

sealed class AppPage {
  static get initial => Get.find<AuthServeice>().initialRoute;

  static List<GetPage> routes = [
    GetPage(
      name: AppRoutes.wifi,
      page: () => const WifiScreen(),
      binding: RootBindings(),
    ),
    GetPage(
      name: AppRoutes.logger,
      page: () => const LoggerScreen(),
      binding: RootBindings(),
    ),
  ];
}
