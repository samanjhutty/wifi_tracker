// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_tracker/model/models/tracker_model.dart';
import 'package:wifi_tracker/model/utils/app_constants.dart';
import 'package:wifi_tracker/services/extension_services.dart';
import 'package:wifi_tracker/services/firebase_options.dart';

class ForegroundServices {
  static final notificationChannelId = 'wifi-tracker-services';
  static final service = FlutterBackgroundService();

  static void stopService() => service.invoke('STOP');

  static Future<void> init() async {
    await service.configure(
        iosConfiguration: IosConfiguration(
            autoStart: false,
            onForeground: onStart,
            onBackground: onIosBackground),
        androidConfiguration: AndroidConfiguration(
          initialNotificationTitle: 'Wifi Tracker',
          initialNotificationContent: 'Tracking Started...',
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

  service.on('STOP').listen((_) async {
    dprint('background service stopped...');
    await service.stopSelf();
    return;
  });

  await GetStorage.init(BoxKeys.boxName);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final fb = FirebaseFirestore.instance.collection(FbKeys.wifiLog);
  final box = GetStorage(BoxKeys.boxName);
  final wifi = WiFiScan.instance;
  final userId = 'TEST';

  List? _json = box.read(BoxKeys.trackingList);
  final doc = await fb.doc(userId).get();
  if (!doc.exists) fb.doc(userId).set({'tracker': _json ?? []});

  Timer.periodic(const Duration(minutes: 1), (timer) async {
    try {
      await wifi.startScan();
      final now = DateTime.now().toJson();
      final results = await wifi.getScannedResults();
      final json = (await fb.doc(userId).get()).data() ?? {};
      var tracking = List<TrackerModel>.from(
          json['tracker']?.map((e) => TrackerModel.fromJson(e)) ?? []);

      for (var item in tracking) {
        final reachable = results.any((e) => e.bssid == item.id);
        item.log?.add(TrackerLog(datetime: now, reachable: reachable));
      }
      final log = tracking.map((e) => e.toJson()).toList();
      fb.doc(userId).update({'tracker': log});
    } catch (e) {
      logPrint(e, 'fgservices');
    }
  });
}
