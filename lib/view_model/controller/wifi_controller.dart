import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_tracker/model/utils/app_constants.dart';
import 'package:wifi_tracker/model/utils/dimens.dart';
import 'package:wifi_tracker/model/utils/strings.dart';
import 'package:wifi_tracker/view/widgets/loading_widgets.dart';
import 'package:wifi_tracker/view/widgets/my_alert_dialog.dart';

class WifiLoggerController extends GetxController
    with GetTickerProviderStateMixin {
  final wifi = WiFiScan.instance;

  List<WiFiAccessPoint> wifiList = [];
  List<WiFiAccessPoint> trackingWifi = [];
  final trackWifiKey = const ValueKey('tracking-wifi');

  RxBool scanning = RxBool(false);

  void askPermission(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => MyAlertDialog(
        title: StringRes.grantPermiss,
        content: Text(StringRes.permissionDesc),
        actions: [
          LoadingButton(
            compact: true,
            defWidth: true,
            onPressed: () {
              Navigator.pop(context);
              Permission.locationAlways.request();
            },
            padding: EdgeInsets.symmetric(horizontal: Dimens.sizeLarge),
            child: Text(StringRes.grant),
          )
        ],
      ),
    );
  }

  Future<void> scanWifi() async {
    await _startScan();
    await _getScannedResults();
  }

  void addTracker() {}

  void onTrackChanged(WiFiAccessPoint wifi) {
    if (trackingWifi.contains(wifi)) {
      trackingWifi.remove(wifi);
    } else {
      trackingWifi.add(wifi);
    }
    update([trackWifiKey]);
  }

  Future<void> _startScan() async {
    scanning.value = true;
    try {
      final can = await wifi.canStartScan();
      switch (can) {
        case CanStartScan.yes:
          await wifi.startScan();
          break;

        default:
          throw Exception(can);
      }
    } catch (e) {
      scanning.value = false;
      logPrint(e, 'scan');
    }
  }

  Future<void> _getScannedResults() async {
    try {
      final can = await wifi.canGetScannedResults();
      switch (can) {
        case CanGetScannedResults.yes:
          wifiList = await wifi.getScannedResults();
          scanning.value = false;
          break;
        default:
          throw Exception(can);
      }
    } catch (e) {
      scanning.value = false;
      logPrint(e, 'results');
    }
  }
}
