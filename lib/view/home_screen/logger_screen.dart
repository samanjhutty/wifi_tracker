import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:wifi_tracker/model/utils/strings.dart';
import 'package:wifi_tracker/model/utils/utils.dart';
import 'package:wifi_tracker/services/extension_services.dart';
import 'package:wifi_tracker/view/widgets/base_widget.dart';
import 'package:wifi_tracker/view_model/controller/wifi_controller.dart';

class LoggerScreen extends GetView<WifiLoggerController> {
  const LoggerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return BaseWidget(
      appBar: AppBar(
        backgroundColor: scheme.background,
        title: Text(StringRes.appName),
        titleTextStyle: Utils.defTitleStyle,
      ),
      child: Column(children: []),
    );
  }
}
