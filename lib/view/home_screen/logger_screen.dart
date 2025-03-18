import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi_tracker/model/models/tracker_model.dart';
import 'package:wifi_tracker/model/utils/color_resources.dart';
import 'package:wifi_tracker/model/utils/dimens.dart';
import 'package:wifi_tracker/model/utils/strings.dart';
import 'package:wifi_tracker/model/utils/utils.dart';
import 'package:wifi_tracker/services/extension_services.dart';
import 'package:wifi_tracker/view/home_screen/wifi_screen.dart';
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
          LoadingButton(
            defWidth: true,
            compact: true,
            onPressed: () => showWifiScreen(context),
            padding: EdgeInsets.symmetric(horizontal: Dimens.sizeLarge),
            child: Text(StringRes.scan.toUpperCase()),
          ),
          const SizedBox(width: Dimens.sizeDefault),
        ],
      ),
      child: Column(children: [
        const SizedBox(height: Dimens.sizeExtraLarge),
        Row(
          children: [
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
          ],
        ),
        const SizedBox(height: Dimens.sizeLarge),
        const MyDivider(),
        Expanded(
          child: StreamBuilder(
              stream: controller.logger.doc('TEST').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return ToolTipWidget(
                      title: '', icon: CircularProgressIndicator());
                }
                final tracker =
                    (snapshot.data?.data()?['tracker'] as List? ?? [])
                        .map((e) => TrackerModel.fromJson(e))
                        .toList();

                if (tracker.isEmpty) {
                  return ToolTipWidget(
                      title: 'No Wifi tracking, kindly'
                          ' scan and select wifi to track');
                }

                return ListView.builder(
                  padding: EdgeInsets.only(top: Dimens.sizeLarge),
                  itemCount: tracker.length,
                  itemBuilder: (context, index) {
                    final item = tracker[index];

                    return DefaultTextStyle.merge(
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimens.fontLarge),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: Dimens.sizeDefault,
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name ?? '',
                                    style: TextStyle(
                                      fontSize: Dimens.fontLarge,
                                      fontWeight: FontWeight.w500,
                                      color: scheme.textColor,
                                    ),
                                  ),
                                  Text(
                                    item.id,
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
                                Color color = ColorRes.error;
                                if (item.log?.isNotEmpty ?? false) {
                                  if (item.log?.last.reachable ?? false) {
                                    color = ColorRes.sucess;
                                  }
                                }
                                return CircleAvatar(
                                    backgroundColor: color,
                                    radius: Dimens.sizeSmall);
                              }),
                              const SizedBox(width: Dimens.sizeDefault),
                              Builder(builder: (context) {
                                final count = item.log
                                    ?.where((e) => e.reachable ?? false);

                                final duration =
                                    Duration(minutes: count?.length ?? 0);

                                String time = '';

                                if (duration.inHours > 0) {
                                  time = '${duration.inHours} hours';
                                } else if (duration.inMinutes > 0) {
                                  time = '${duration.inMinutes} min';
                                } else {
                                  time = 'Few minutes';
                                }
                                return Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: Dimens.fontDefault,
                                    fontWeight: FontWeight.w500,
                                    color: scheme.textColorLight,
                                  ),
                                );
                              }),
                              const SizedBox(width: Dimens.sizeDefault),
                            ],
                          ),
                        ));
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
