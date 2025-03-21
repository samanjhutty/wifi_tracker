import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi_tracker/model/models/tracker_model.dart';
import 'package:wifi_tracker/model/utils/app_constants.dart';
import 'package:wifi_tracker/model/utils/color_resources.dart';
import 'package:wifi_tracker/model/utils/dimens.dart';
import 'package:wifi_tracker/model/utils/strings.dart';
import 'package:wifi_tracker/model/utils/utils.dart';
import 'package:wifi_tracker/services/extension_services.dart';
import 'package:wifi_tracker/view/widgets/base_widget.dart';
import '../../view_model/controller/wifi_controller.dart';
import '../widgets/top_widgets.dart';

class LogDetails extends StatefulWidget {
  const LogDetails({super.key});

  @override
  State<LogDetails> createState() => _LogDetailsState();
}

class _LogDetailsState extends State<LogDetails> {
  final controller = Get.find<WifiLoggerController>();
  late String wifiId;
  late String? wifiName;

  @override
  void initState() {
    wifiId = Get.arguments[0];
    wifiName = Get.arguments[1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return BaseWidget(
      appBar: AppBar(
        backgroundColor: scheme.background,
        title: Text(wifiName ?? ''),
        titleTextStyle: Utils.defTitleStyle,
        centerTitle: false,
      ),
      padding: EdgeInsets.zero,
      child: StreamBuilder(
          stream: controller.logger.doc(FbKeys.userId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError ||
                snapshot.connectionState == ConnectionState.waiting) {
              return ToolTipWidget(
                  title: '', icon: CircularProgressIndicator());
            }
            final logger = snapshot.data?.data()?['wifi'] as List?;
            final json = logger?.firstWhere((e) => e['id'] == wifiId) ?? {};
            final wifi = WifiTrackerModel.fromJson(json);
            return Column(
              children: [
                SizedBox(height: Dimens.sizeLarge),
                Container(
                  padding: EdgeInsets.all(Dimens.sizeDefault),
                  margin: const EdgeInsets.symmetric(
                      horizontal: Dimens.sizeDefault),
                  decoration: BoxDecoration(
                      border: Border.all(color: scheme.backgroundDark),
                      borderRadius:
                          BorderRadius.circular(Dimens.borderDefault)),
                  child: Column(
                    children: [
                      DefaultTextStyle.merge(
                        style: Utils.largeTextStyle
                            .copyWith(color: scheme.textColorLight),
                        child: Row(
                          children: [
                            Text(StringRes.summary),
                            const Spacer(),
                            Builder(builder: (context) {
                              final now = DateTime.now();
                              final diff = Utils.totalTime(wifi.log, now);
                              return Text(diff.format);
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimens.sizeSmall),
                      const MyDivider(),
                      const SizedBox(height: Dimens.sizeSmall),
                      DefaultTextStyle.merge(
                        style: TextStyle(
                            fontSize: Dimens.fontDefault,
                            fontWeight: FontWeight.w500),
                        child: Row(
                          children: [
                            Text(StringRes.totalTracked),
                            const Spacer(),
                            Builder(builder: (context) {
                              final now = DateTime.now();
                              final diff = Utils.totalTracked(wifi.log, now);
                              return Text(diff.format);
                            }),
                          ],
                        ),
                      ),
                      DefaultTextStyle.merge(
                        style: TextStyle(
                            color: ColorRes.error,
                            fontSize: Dimens.fontDefault,
                            fontWeight: FontWeight.w500),
                        child: Row(
                          children: [
                            Text(StringRes.totalLost),
                            const Spacer(),
                            Builder(builder: (context) {
                              final now = DateTime.now();
                              final diff = Utils.totalLost(wifi.log, now);
                              return Text(diff.formatRAW);
                            }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: Dimens.sizeLarge),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: wifi.log.length,
                      itemBuilder: (context, index) {
                        final item = wifi.log[index];
                        return ListTile(
                            title: Builder(builder: (context) {
                              final datetime = item.datetime;
                              final date = DateTime.parse(datetime);
                              return Text(date.formatTime);
                            }),
                            titleTextStyle: Utils.largeTextStyle,
                            subtitle: Builder(builder: (context) {
                              final datetime = item.datetime;
                              final date = DateTime.parse(datetime);
                              return Text(date.formatDate);
                            }),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DefaultTextStyle.merge(
                                  style: Utils.largeTextStyle,
                                  child: Builder(builder: (context) {
                                    try {
                                      final min =
                                          wifi.log[index + 1].totalDuration;
                                      final duration = Duration(minutes: min);
                                      return Text(duration.format);
                                    } catch (e) {
                                      final date =
                                          DateTime.parse(item.datetime);
                                      final diff =
                                          DateTime.now().difference(date);
                                      return Text(diff.format);
                                    }
                                  }),
                                ),
                                const SizedBox(width: Dimens.sizeDefault),
                                Builder(builder: (context) {
                                  if (!item.reachable) {
                                    return const CircleAvatar(
                                        backgroundColor: ColorRes.error,
                                        radius: Dimens.sizeSmall);
                                  }
                                  return const CircleAvatar(
                                      backgroundColor: ColorRes.sucess,
                                      radius: Dimens.sizeSmall);
                                }),
                              ],
                            ));
                      }),
                ),
              ],
            );
          }),
    );
  }
}
