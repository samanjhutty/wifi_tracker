import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi_tracker/model/utils/dimens.dart';
import 'package:wifi_tracker/model/utils/strings.dart';
import 'package:wifi_tracker/model/utils/utils.dart';
import 'package:wifi_tracker/services/extension_services.dart';
import 'package:wifi_tracker/view/home_screen/wifi_screen.dart';
import 'package:wifi_tracker/view/widgets/base_widget.dart';
import 'package:wifi_tracker/view/widgets/loading_widgets.dart';
import 'package:wifi_tracker/view/widgets/my_alert_dialog.dart';
import 'package:wifi_tracker/view_model/controller/wifi_controller.dart';

class LoggerScreen extends StatefulWidget {
  const LoggerScreen({super.key});

  @override
  State<LoggerScreen> createState() => _LoggerScreenState();
}

class _LoggerScreenState extends State<LoggerScreen> {
  final WifiLoggerController controller = Get.find();

  @override
  void initState() {
    // ignore: use_build_context_synchronously
    Future(() => controller.askPermission(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return BaseWidget(
      appBar: AppBar(
        centerTitle: false,
        title: Text(StringRes.appName),
        backgroundColor: scheme.background,
        titleTextStyle: Utils.defTitleStyle,
        actions: [
          LoadingButton(
            defWidth: true,
            compact: true,
            onPressed: () {
              controller.scanWifi();
              showModalBottomSheet(
                  context: context,
                  useSafeArea: true,
                  enableDrag: true,
                  isDismissible: false,
                  showDragHandle: true,
                  isScrollControlled: true,
                  builder: (context) {
                    return MyBottomSheet(
                        title: StringRes.wifiDetails,
                        onClose: controller.addTracker,
                        vsync: controller,
                        child: const WifiScreen());
                  });
            },
            padding: EdgeInsets.symmetric(horizontal: Dimens.sizeLarge),
            child: Text(StringRes.scan.toUpperCase()),
          ),
          const SizedBox(width: Dimens.sizeDefault),
        ],
      ),
      child: Column(children: []),
    );
  }
}
