import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wifi_tracker/model/utils/dimens.dart';
import 'dart:developer' as dev;

import 'package:wifi_tracker/model/utils/strings.dart';

class AppConstants {
  static const String baseUrl = '';
  static const String signIn = '';
}

sealed class BoxKeys {
  static const String boxName = 'ampify';
  static const String theme = '$boxName:theme';
}

void logPrint(Object? value, [String? name]) {
  if (kReleaseMode) return;
  final log = value is String? ? value : value.toString();
  dev.log(log ?? 'null', name: (name ?? StringRes.appName).toUpperCase());
}

void dprint(String? value) {
  if (kReleaseMode) return;
  debugPrint(value ?? 'null');
}

class MyColoredBox extends StatelessWidget {
  final Color? color;
  final Widget child;
  const MyColoredBox({super.key, this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: color ?? Colors.black12, child: child);
  }
}

showToast(String text, {int? timeInSec}) async {
  await Fluttertoast.cancel();
  Future.delayed(const Duration(milliseconds: 300)).then((_) {
    Fluttertoast.showToast(
      msg: text,
      timeInSecForIosWeb: timeInSec ?? 1,
      gravity: ToastGravity.SNACKBAR,
    );
  });
}

showSnackBar(BuildContext context, {required String text}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.borderSmall),
      ),
    ),
  );
}
