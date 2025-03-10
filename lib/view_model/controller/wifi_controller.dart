import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_tracker/model/utils/app_constants.dart';
import 'package:workmanager/workmanager.dart';

class WifiLoggerController extends GetxController
    with GetTickerProviderStateMixin {
  final wifi = WiFiScan.instance;
  final connectivity = Connectivity();
  final workManager = Workmanager();

  final permission = [Permission.locationAlways, Permission.nearbyWifiDevices];

  List<WiFiAccessPoint> wifiList = [];
  List<WiFiAccessPoint> trackingWifi = [];

  final trackWifiKey = const ValueKey('tracking-wifi');
  RxBool scanning = RxBool(false);

  @override
  void onReady() {
    Future(init);
    super.onReady();
  }

  Future<void> init() async {
    if (!await _checkWifi()) {
      showToast('Wifi is off, please trun on Wifi');
    }
    if (!await _checkLocation()) _permissions();
  }

  Future<bool> _checkWifi() async {
    final connection = await connectivity.checkConnectivity();
    return connection.contains(ConnectivityResult.wifi);
  }

  Future<bool> _checkLocation() async {
    for (final element in permission) {
      final isGranted = await element.isGranted;
      if (!isGranted) return false;
    }
    return true;
  }

  Future<void> _permissions() async {
    Get.back();
    for (final element in permission) {
      await element.request().then(dprint);
    }
  }

  Future<void> scanWifi() async {
    await _startScan();
    await _getScannedResults();
  }

  void addTracker() async {
    await workManager.cancelAll();
    await workManager.registerPeriodicTask("task-identifier", "wifi-logger",
        frequency: const Duration(minutes: 2));
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
          showToast('Location is turned off, please toggle location');
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

@pragma('vm:entry-point')
void logEvents() {
  Workmanager().executeTask((task, inputData) {
    final fb = FirebaseFirestore.instance;
    final loger = fb.collection(FbKeys.wifiLog).doc('test-logger');
    loger.update({'date-time': DateTime.now().toIso8601String()});
    return Future.value(true);
  });
}
