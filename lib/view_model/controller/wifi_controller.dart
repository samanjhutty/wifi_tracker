import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_tracker/model/utils/app_constants.dart';

class WifiLoggerController extends GetxController {
  final wifi = WiFiScan.instance;

  List<WiFiAccessPoint> wifiList = [];
  List<WiFiAccessPoint> trackingWifi = [];
  final trackWifiKey = const ValueKey('tracking-wifi');

  RxBool scanning = RxBool(false);

  @override
  void onReady() {
    Future(scanWifi);
    super.onReady();
  }

  Future<void> scanWifi() async {
    await _startScan();
    await _getScannedResults();
  }

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
