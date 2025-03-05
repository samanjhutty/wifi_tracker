import 'package:get/get.dart';
import '../../services/auth_services.dart';
import '../../view/home_screen/home.dart';
import '../bindings/root_bindings.dart';
import 'app_routes.dart';

sealed class AppPage {
  static get initial => Get.find<AuthServeice>().initialRoute;

  static List<GetPage> routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: RootBindings(),
    ),
  ];
}
