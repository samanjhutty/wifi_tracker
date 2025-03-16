import 'package:wifi_scan/wifi_scan.dart';

class TrackerModel {
  final String id;
  final String? name;
  final List<TrackerLog>? log;

  const TrackerModel({required this.id, required this.name, this.log});

  factory TrackerModel.fromJson(Map<String, dynamic> json) {
    return TrackerModel(
        id: json['id'],
        name: json['name'],
        log: List<TrackerLog>.from(
            json['log']?.map((e) => TrackerLog.fromJson(e)) ?? []));
  }

  factory TrackerModel.fromWifi(WiFiAccessPoint wifi) {
    return TrackerModel(id: wifi.bssid, name: wifi.ssid);
  }

  TrackerModel copyWith(
      {String? id, String? name, String? upTime, List<TrackerLog>? log}) {
    return TrackerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      log: log ?? this.log,
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'log': log?.map((e) => e.toJson()).toList()};
}

class TrackerLog {
  final String datetime;
  final bool reachable;

  const TrackerLog({required this.datetime, required this.reachable});

  factory TrackerLog.fromJson(Map<String, dynamic> json) {
    return TrackerLog(datetime: json['datetime'], reachable: json['reachable']);
  }

  Map<String, dynamic> toJson() =>
      {'datetime': datetime, 'reachable': reachable};
}
