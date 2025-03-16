import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_tracker/model/models/tracker_model.dart';
import 'package:wifi_tracker/model/utils/app_constants.dart';
import 'package:wifi_tracker/services/box_services.dart';
import 'package:wifi_tracker/services/extension_services.dart';
import 'package:wifi_tracker/services/firebase_options.dart';

class ForegroundServices {
  static final notificationChannelId = 'wifi-tracker-services';

  static Future<void> init() async {
    final service = FlutterBackgroundService();
    await service.configure(
        iosConfiguration: IosConfiguration(
            autoStart: false,
            onForeground: onStart,
            onBackground: onIosBackground),
        androidConfiguration: AndroidConfiguration(
          foregroundServiceTypes: [AndroidForegroundType.location],
          autoStart: false,
          onStart: onStart,
          isForegroundMode: true,
        ));
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final fb = FirebaseFirestore.instance.collection(FbKeys.wifiLog);
  final wifi = WiFiScan.instance;
  final box = BoxServices.to;

  try {
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      if (!box.read(BoxKeys.isTracking)) {
        await service.stopSelf();
        return;
      }
      await wifi.startScan();
      final results = await wifi.getScannedResults();
      final json = box.read(BoxKeys.trackingList);
      var tracking = List<TrackerModel>.from(
          json?.map((e) => TrackerLog.fromJson(e)) ?? []);

      for (var item in tracking) {
        final reachable = results.any((e) => e.bssid == item.id);
        item.log?.add(value);
      }
    });
  } catch (e) {
    logPrint(e, 'fgservices');
  }
}
