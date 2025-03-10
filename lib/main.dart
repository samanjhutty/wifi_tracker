import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wifi_tracker/model/utils/app_constants.dart';
import 'package:wifi_tracker/model/utils/strings.dart';
import 'package:wifi_tracker/services/auth_services.dart';
import 'package:wifi_tracker/services/firebase_options.dart';
import 'package:wifi_tracker/view_model/bindings/root_bindings.dart';
import 'package:wifi_tracker/view_model/controller/wifi_controller.dart';
import 'package:wifi_tracker/view_model/routes/app_pages.dart';
import 'package:workmanager/workmanager.dart';
import 'services/theme_services.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initServices();
  runApp(const MyTheme(child: MyApp()));
}

Future<void> _initServices() async {
  logPrint('initServices started...');
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await GetStorage.init();
    Get.putAsync(() => AuthServeice.instance.init());
    Workmanager().initialize(logEvents, isInDebugMode: true);
  } catch (e) {
    logPrint(e, 'init');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return GetMaterialApp(
      title: StringRes.appName,
      initialBinding: RootBindings(),
      getPages: AppPage.routes,
      initialRoute: AppPage.initial,
      defaultTransition: Transition.rightToLeft,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: theme.primary,
          primary: theme.primary,
          onPrimary: theme.onPrimary,
          primaryContainer: theme.primaryContainer,
          onPrimaryContainer: theme.onPrimaryContainer,
        ),
        fontFamily: StringRes.fontFamily,
        useMaterial3: true,
      ),
    );
  }
}
