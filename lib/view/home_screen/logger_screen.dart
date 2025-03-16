import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi_tracker/model/utils/dimens.dart';
import 'package:wifi_tracker/model/utils/strings.dart';
import 'package:wifi_tracker/model/utils/utils.dart';
import 'package:wifi_tracker/services/extension_services.dart';
import 'package:wifi_tracker/view/home_screen/wifi_screen.dart';
import 'package:wifi_tracker/view/widgets/base_widget.dart';
import 'package:wifi_tracker/view/widgets/loading_widgets.dart';
import '../../view_model/controller/wifi_controller.dart';

class LoggerScreen extends GetView<WifiLoggerController> {
  const LoggerScreen({super.key});

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
            onPressed: () => showWifiScreen(context),
            padding: EdgeInsets.symmetric(horizontal: Dimens.sizeLarge),
            child: Text(StringRes.scan.toUpperCase()),
          ),
          const SizedBox(width: Dimens.sizeDefault),
        ],
      ),
      child: Column(children: [
        const SizedBox(height: Dimens.sizeExtraLarge),
        Row(
          children: [
            Text(StringRes.startTrack.toUpperCase(),
                style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimens.fontExtraDoubleLarge)),
            const Spacer(),
            SizedBox(
              height: Dimens.sizeDefault,
              child: Obx(() {
                return Switch(
                  value: controller.isTracking.value,
                  onChanged: controller.onTrackingChanged,
                );
              }),
            ),
          ],
        )
      ]),
    );
  }

  void showWifiScreen(BuildContext context) {
    final scheme = context.scheme;
    controller.scanWifi();
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: false,
      showDragHandle: true,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: scheme.background,
      builder: (_) => WifiScreen(),
    );
  }
}
