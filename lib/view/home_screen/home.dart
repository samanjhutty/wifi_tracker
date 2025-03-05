import 'package:flutter/material.dart';
import 'package:wifi_tracker/model/utils/strings.dart';
import 'package:wifi_tracker/model/utils/utils.dart';
import 'package:wifi_tracker/services/extension_services.dart';
import 'package:wifi_tracker/view/widgets/base_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return BaseWidget(
      appBar: AppBar(
        title: Text(StringRes.appName),
        titleTextStyle: Utils.defTitleStyle,
        backgroundColor: scheme.background,
        centerTitle: false,
      ),
      child: Column(children: []),
    );
  }
}
