import 'package:get/get.dart';
import '../controller/wifi_controller.dart';

class RootBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WifiLoggerController>(() => WifiLoggerController());
  }
}
