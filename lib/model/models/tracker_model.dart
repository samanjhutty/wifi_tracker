import 'package:wifi_scan/wifi_scan.dart';

class TrackerModel {
  final String? userId;
  final String? startDate;
  final List<WifiTrackerModel>? wifi;

  TrackerModel(
      {required this.userId, required this.startDate, required this.wifi});

  factory TrackerModel.fromJson(Map<String, dynamic> json) {
    return TrackerModel(
        userId: json['user_id'],
        startDate: json['start_date'],
        wifi: List<WifiTrackerModel>.from(
            json['wifi']?.map((e) => WifiTrackerModel.fromJson(e)) ?? []));
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'start_date': startDate,
        'wifi': wifi?.map((e) => e.toJson()).toList(),
      };
}

class WifiTrackerModel {
  final String id;
  final String? name;
  final List<TrackerLog> log;

  const WifiTrackerModel(
      {required this.id, required this.name, this.log = const []});

  factory WifiTrackerModel.fromJson(Map<String, dynamic> json) {
    return WifiTrackerModel(
        id: json['id'],
        name: json['name'],
        log: List<TrackerLog>.from(
            json['log']?.map((e) => TrackerLog.fromJson(e)) ?? []));
  }

  factory WifiTrackerModel.fromWifi(WiFiAccessPoint wifi) {
    return WifiTrackerModel(id: wifi.bssid, name: wifi.ssid, log: []);
  }

  WifiTrackerModel copyWith(
      {String? id, String? name, String? upTime, List<TrackerLog>? log}) {
    return WifiTrackerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      log: log ?? this.log,
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'log': log.map((e) => e.toJson()).toList()};
}

class TrackerLog {
  final String datetime;
  final int totalDuration;
  final bool reachable;

  const TrackerLog(
      {required this.datetime,
      required this.totalDuration,
      required this.reachable});

  factory TrackerLog.fromJson(Map<String, dynamic> json) {
    return TrackerLog(
      datetime: json['datetime'],
      totalDuration: json['total_duration'],
      reachable: json['reachable'],
    );
  }

  Map<String, dynamic> toJson() => {
        'datetime': datetime,
        'total_duration': totalDuration,
        'reachable': reachable
      };
}
