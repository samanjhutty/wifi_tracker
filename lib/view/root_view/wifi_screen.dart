import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi_tracker/model/utils/dimens.dart';
import 'package:wifi_tracker/model/utils/strings.dart';
import 'package:wifi_tracker/services/extension_services.dart';
import 'package:wifi_tracker/view/widgets/my_alert_dialog.dart';
import 'package:wifi_tracker/view/widgets/top_widgets.dart';
import 'package:wifi_tracker/view_model/controller/wifi_controller.dart';

class WifiScreen extends GetView<WifiLoggerController> {
  const WifiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return MyBottomSheet(
      title: StringRes.wifiDetails,
      onClose: controller.addTracker,
      isExpanded: true,
      vsync: controller,
      child: Scaffold(
        backgroundColor: scheme.background,
        body: Obx(() {
          if (controller.scanning.value) {
            return ToolTipWidget(
                margin: EdgeInsets.symmetric(vertical: context.height * .1),
                title: StringRes.scanningDesc);
          }

          if (controller.wifiList.isEmpty) {
            return ToolTipWidget(
                margin: EdgeInsets.symmetric(vertical: context.height * .1),
                icon: Icon(Icons.wifi_find,
                    color: scheme.disabled, size: Dimens.sizeExtraLarge * 2),
                title: StringRes.noWifi);
          }
          return ListView(
            padding: const EdgeInsets.all(Dimens.sizeDefault),
            children: [
              Row(
                children: [
                  Text(
                    StringRes.wifiName,
                    style: TextStyle(
                      color: scheme.textColorLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    StringRes.track,
                    style: TextStyle(
                      color: scheme.textColorLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: controller.wifiList.length,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = controller.wifiList[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: Dimens.sizeDefault,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.ssid,
                              style: TextStyle(
                                fontSize: Dimens.fontLarge,
                                fontWeight: FontWeight.w500,
                                color: scheme.textColor,
                              ),
                            ),
                            Text(
                              item.bssid,
                              style: TextStyle(
                                fontSize: Dimens.fontDefault,
                                fontWeight: FontWeight.w500,
                                color: scheme.textColorLight,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          '${item.channelWidth?.name}',
                          style: TextStyle(
                            fontSize: Dimens.fontDefault,
                            fontWeight: FontWeight.w500,
                            color: scheme.textColorLight,
                          ),
                        ),
                        const SizedBox(width: Dimens.sizeDefault),
                        GetBuilder<WifiLoggerController>(
                          id: controller.trackWifiKey,
                          builder: (controller) {
                            return SizedBox(
                              height: Dimens.sizeDefault,
                              child: Switch(
                                value: controller.trackingWifi
                                    .any((e) => e.id == item.bssid),
                                onChanged: (_) =>
                                    controller.onTrackChanged(item),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
    // return BaseWidget(
    //   appBar: AppBar(
    //     title: Text(StringRes.wifiDetails),
    //     titleTextStyle: Utils.defTitleStyle,
    //     backgroundColor: scheme.background,
    //     centerTitle: false,
    //     actions: [
    //       Obx(() {
    //         return LoadingTextButton(
    //           width: 100,
    //           onPressed: controller.scanWifi,
    //           loading: controller.scanning.value,
    //           label: StringRes.refresh.toUpperCase(),
    //         );
    //       }),
    //       const SizedBox(width: Dimens.sizeDefault),
    //     ],
    //   ),
    //   child: SizedBox(),
    // );
  }
}
