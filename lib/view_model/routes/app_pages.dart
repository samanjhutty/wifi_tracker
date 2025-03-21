import 'package:get/get.dart';
import 'package:wifi_tracker/view/root_view/log_details.dart';
import 'package:wifi_tracker/view/root_view/logger_screen.dart';
import '../../services/auth_services.dart';
import '../bindings/root_bindings.dart';
import 'app_routes.dart';

sealed class AppPage {
  static get initial => Get.find<AuthServeice>().initialRoute;

  static List<GetPage> routes = [
    GetPage(
      name: AppRoutes.logger,
      page: () => const LoggerScreen(),
      binding: RootBindings(),
    ),
    GetPage(
      name: AppRoutes.logDetails,
      page: () => const LogDetails(),
    ),
  ];
}
