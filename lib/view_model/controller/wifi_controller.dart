import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_tracker/model/models/tracker_model.dart';
import 'package:wifi_tracker/model/utils/app_constants.dart';
import 'package:wifi_tracker/services/box_services.dart';
import 'package:wifi_tracker/services/foreground_services.dart';

class WifiLoggerController extends GetxController
    with GetTickerProviderStateMixin {
  final logger = FirebaseFirestore.instance.collection(FbKeys.wifiLog);
  final fgServices = FlutterBackgroundService();
  final connectivity = Connectivity();
  final wifi = WiFiScan.instance;
  final box = BoxServices.instance;

  final permission = [
    Permission.locationAlways,
    Permission.nearbyWifiDevices,
    Permission.ignoreBatteryOptimizations
  ];

  List<WiFiAccessPoint> wifiList = [];
  List<TrackerModel> trackingWifi = [];

  final trackWifiKey = const ValueKey('tracking-wifi');
  RxBool scanning = RxBool(false);
  RxBool isTracking = RxBool(false);

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
    isTracking.value = box.read(BoxKeys.isTracking) ?? false;
    List? list = box.read(BoxKeys.trackingList);
    trackingWifi = List<TrackerModel>.from(
        list?.map((e) => TrackerModel.fromJson(e)) ?? []);
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
      await element.request();
    }
  }

  Future<void> scanWifi() async {
    await _startScan();
    await _getScannedResults();
  }

  void addTracker() {
    final json = trackingWifi.map((e) => e.toJson()).toList();
    box.write(BoxKeys.trackingList, json);
  }

  void onTrackingChanged(bool value) async {
    if (trackingWifi.isEmpty) {
      showToast('Please select wifi to track via going to scan');
      return;
    }
    final permision = Permission.locationAlways;
    Future(() async {
      if (!await permision.isGranted) {
        showToast('Please change location permission to always.');
        await permision.request();
        isTracking.value = false;
        return;
      }
      if (isTracking.value) {
        await fgServices.startService();
        await box.write(BoxKeys.isTracking, isTracking.value);
        return;
      }
      ForegroundServices.stopService();
    });

    isTracking.value = !isTracking.value;
  }

  void onTrackChanged(WiFiAccessPoint wifi) {
    test(TrackerModel e) => e.id == wifi.bssid;
    if (trackingWifi.any(test)) {
      int index = trackingWifi.indexWhere(test);
      trackingWifi.removeAt(index);
    } else {
      trackingWifi.add(TrackerModel.fromWifi(wifi));
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
