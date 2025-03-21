import 'package:flutter/material.dart';
import 'package:wifi_tracker/model/models/tracker_model.dart';
import 'package:wifi_tracker/model/utils/dimens.dart';

sealed class Utils {
  static TextStyle get defTitleStyle {
    return const TextStyle(
      fontSize: Dimens.fontExtraDoubleLarge,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );
  }

  static TextStyle get largeTextStyle {
    return const TextStyle(
      fontSize: Dimens.fontLarge,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );
  }

  static TextStyle titleTextStyle([Color? color]) {
    return TextStyle(
      fontSize: Dimens.fontTitle,
      fontWeight: FontWeight.bold,
      color: color ?? const Color(0xFF1B1C1E),
    );
  }

  // static String totalTime(List<TrackerLog>? duration, DateTime now) {
  //   if (duration?.isEmpty ?? true) return '';
  //   final startTime = DateTime.parse(duration!.first.datetime);
  //   final totalTimeSpent = now.difference(startTime);

  //   Duration trackedTime = Duration();
  //   for (final log in duration) {
  //     if (!log.reachable) {
  //       trackedTime += Duration(minutes: log.totalDuration);
  //     }
  //   }
  //   if (duration.last.reachable) trackedTime += getDiff(duration, now);
  //   if (trackedTime.inHours > 0) {
  //     if (totalTimeSpent.inHours > 0) {
  //       return '${trackedTime.inMinutes} min/${totalTimeSpent.inHours} H';
  //     }
  //     return '${trackedTime.inMinutes}/${totalTimeSpent.inHours} H';
  //   }
  //   return '${trackedTime.inMinutes}/${totalTimeSpent.inMinutes} min';
  // }

  static Duration totalTracked(List<TrackerLog>? duration, DateTime now) {
    if (duration?.isEmpty ?? true) return Duration.zero;
    Duration trackedTime = Duration();
    for (final log in duration ?? []) {
      if (!log.reachable) {
        trackedTime += Duration(minutes: log.totalDuration);
      }
    }
    if (duration?.last.reachable ?? false) {
      trackedTime += getDiff(duration, now);
    }
    return trackedTime;
  }

  static Duration totalLost(List<TrackerLog>? duration, DateTime now) {
    if (duration?.isEmpty ?? true) return Duration.zero;
    Duration trackedTime = Duration();
    for (final log in duration ?? []) {
      if (log.reachable) {
        trackedTime += Duration(minutes: log.totalDuration);
      }
    }
    if (!(duration?.last.reachable ?? true)) {
      trackedTime += getDiff(duration, now);
    }
    return trackedTime;
  }

  static Duration getDiff(List<TrackerLog>? log, DateTime now) {
    if (log?.isEmpty ?? true) return Duration.zero;
    final lastTime = DateTime.tryParse(log?.last.datetime ?? '');
    return now.difference(lastTime ?? now);
  }

  static Duration totalTime(List<TrackerLog>? log, DateTime now) {
    if (log?.isEmpty ?? true) return Duration.zero;
    final startTime = DateTime.tryParse(log?.first.datetime ?? '');
    return now.difference(startTime ?? now);
  }

  static String formatDuration(Duration duration) {
    return '';
  }
}
