import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi_tracker/model/models/tracker_model.dart';
import 'package:wifi_tracker/model/utils/app_constants.dart';
import 'package:wifi_tracker/model/utils/color_resources.dart';
import 'package:wifi_tracker/model/utils/dimens.dart';
import 'package:wifi_tracker/model/utils/strings.dart';
import 'package:wifi_tracker/model/utils/utils.dart';
import 'package:wifi_tracker/services/extension_services.dart';
import 'package:wifi_tracker/view/root_view/wifi_screen.dart';
import 'package:wifi_tracker/view/widgets/base_widget.dart';
import 'package:wifi_tracker/view/widgets/loading_widgets.dart';
import 'package:wifi_tracker/view/widgets/top_widgets.dart';
import '../../view_model/controller/wifi_controller.dart';

class LoggerScreen extends GetView<WifiLoggerController> {
  const LoggerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return BaseWidget(
      appBar: AppBar(
        centerTitle: false,
        title: Text(StringRes.appName),
        backgroundColor: scheme.background,
        titleTextStyle: Utils.defTitleStyle,
        actions: [
          Obx(() {
            return LoadingButton(
              defWidth: true,
              compact: true,
              enable: !controller.isTracking.value,
              onPressed: () => showWifiScreen(context),
              padding: EdgeInsets.symmetric(horizontal: Dimens.sizeLarge),
              child: Text(StringRes.scan.toUpperCase()),
            );
          }),
          const SizedBox(width: Dimens.sizeDefault),
        ],
      ),
      padding: EdgeInsets.zero,
      child: Column(children: [
        const SizedBox(height: Dimens.sizeExtraLarge),
        Row(
          children: [
            const SizedBox(width: Dimens.sizeLarge),
            Text(StringRes.startTrack.toUpperCase(),
                style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimens.fontExtraDoubleLarge)),
            const Spacer(),
            SizedBox(
              height: Dimens.sizeDefault,
              child: Obx(() {
                return Switch(
                  value: controller.isTracking.value,
                  onChanged: controller.onTrackingChanged,
                );
              }),
            ),
            const SizedBox(width: Dimens.sizeLarge),
          ],
        ),
        const SizedBox(height: Dimens.sizeLarge),
        const MyDivider(margin: Dimens.sizeLarge),
        Expanded(
          child: StreamBuilder(
              stream: controller.logger.doc(FbKeys.userId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return ToolTipWidget(
                      title: '', icon: CircularProgressIndicator());
                }
                final json = snapshot.data?.data();
                if (json == null) {
                  return ToolTipWidget(title: StringRes.noTracking);
                }

                final tracker = TrackerModel.fromJson(json);
                return ListView.builder(
                  padding: EdgeInsets.only(top: Dimens.sizeLarge),
                  itemCount: tracker.wifi?.length ?? 0,
                  itemBuilder: (context, index) {
                    final wifi = tracker.wifi![index];

                    return InkWell(
                      onTap: () => controller.toDetails(wifi),
                      child: DefaultTextStyle.merge(
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Dimens.fontLarge),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimens.sizeLarge),
                            margin: const EdgeInsets.symmetric(
                                vertical: Dimens.sizeDefault),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      wifi.name ?? '',
                                      style: TextStyle(
                                        fontSize: Dimens.fontLarge,
                                        fontWeight: FontWeight.w500,
                                        color: scheme.textColor,
                                      ),
                                    ),
                                    Text(
                                      wifi.id,
                                      style: TextStyle(
                                        fontSize: Dimens.fontDefault,
                                        fontWeight: FontWeight.w500,
                                        color: scheme.textColorLight,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Builder(builder: (context) {
                                  if (wifi.log.isNotEmpty &&
                                      !wifi.log.last.reachable) {
                                    return const CircleAvatar(
                                        backgroundColor: ColorRes.error,
                                        radius: Dimens.sizeSmall);
                                  }
                                  return const CircleAvatar(
                                      backgroundColor: ColorRes.sucess,
                                      radius: Dimens.sizeSmall);
                                }),
                                const SizedBox(width: Dimens.sizeDefault),
                                TotalTimeWidget(wifi.log),
                                const SizedBox(width: Dimens.sizeDefault),
                              ],
                            ),
                          )),
                    );
                  },
                );
              }),
        )
      ]),
    );
  }

  void showWifiScreen(BuildContext context) {
    final scheme = context.scheme;
    controller.scanWifi();
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: false,
      showDragHandle: true,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: scheme.background,
      builder: (_) => WifiScreen(),
    );
  }
}

class TotalTimeWidget extends StatefulWidget {
  final List<TrackerLog>? log;
  const TotalTimeWidget(this.log, {super.key});

  @override
  State<TotalTimeWidget> createState() => _TotalTimeWidgetState();
}

class _TotalTimeWidgetState extends State<TotalTimeWidget> {
  late Timer timer;

  Duration tracked = Duration.zero;
  Duration total = Duration.zero;

  @override
  void initState() {
    getDetails();
    timer = Timer.periodic(const Duration(minutes: 1), getDetails);
    super.initState();
  }

  getDetails([Timer? timer]) {
    final now = DateTime.now();
    try {
      tracked = Utils.totalTracked(widget.log, now);
      total = Utils.totalTime(widget.log, now);
    } catch (_) {}
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return DefaultTextStyle.merge(
        style: TextStyle(),
        child: Column(
          children: [
            Text(tracked.format,
                style: TextStyle(
                  color: scheme.textColor,
                )),
            Text(total.format,
                style: TextStyle(
                  color: scheme.disabled,
                  fontSize: Dimens.fontDefault,
                )),
          ],
        ));
  }
}
