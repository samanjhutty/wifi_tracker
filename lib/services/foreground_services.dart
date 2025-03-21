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
import 'package:wifi_tracker/model/utils/utils.dart';
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
          // initialNotificationTitle: 'Wifi Tracker',
          // initialNotificationContent: 'Tracking Started...',
          // notificationChannelId: notificationChannelId,
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

  List? _json = box.read(BoxKeys.trackingList);
  final doc = await fb.doc(FbKeys.userId).get();
  if (!doc.exists) {
    fb.doc(FbKeys.userId).set({
      'user_id': FbKeys.userId,
      'start_date': DateTime.now().toIso8601String(),
      'wifi': _json ?? []
    });
  }
  final _local = List<WifiTrackerModel>.from(
      _json?.map((e) => WifiTrackerModel.fromJson(e)) ?? []);
  var _cloud = List<WifiTrackerModel>.from(
      doc.data()?['wifi']?.map((e) => WifiTrackerModel.fromJson(e)) ?? []);

  for (final wifi in _local) {
    if (!_cloud.any((e) => e.id == wifi.id)) _cloud.add(wifi);
  }
  final _log = _cloud.map((e) => e.toJson()).toList();
  fb.doc(FbKeys.userId).update({'wifi': _log});

  Timer.periodic(const Duration(minutes: 1), (timer) async {
    try {
      await wifi.startScan();
      final now = DateTime.now();
      final results = await wifi.getScannedResults();
      final json = (await fb.doc(FbKeys.userId).get()).data() ?? {};
      var tracking = TrackerModel.fromJson(json);

      for (var item in tracking.wifi ?? []) {
        final reachable = results.any((e) => e.bssid == item.id);
        if ((item.log.isEmpty) || item.log.last.reachable != reachable) {
          final totalDuration = Utils.getDiff(item.log, now);
          item.log.add(TrackerLog(
              datetime: now.toIso8601String(),
              totalDuration: totalDuration.inMinutes,
              reachable: reachable));
        }
      }
      final log = tracking.wifi?.map((e) => e.toJson()).toList() ?? [];
      fb.doc(FbKeys.userId).update({'wifi': log});
    } catch (e) {
      logPrint(e, 'fgservices');
    }
  });
}
