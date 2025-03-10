import 'package:flutter/material.dart';
import 'package:wifi_tracker/services/extension_services.dart';
import '../../model/utils/dimens.dart';
import '../../model/utils/strings.dart';
import '../../services/theme_services.dart';
import 'top_widgets.dart';

class MyAlertDialog extends StatelessWidget {
  final String title;
  final TextStyle? titleTextStyle;
  final Widget? content;
  final List<Widget>? actions;
  final EdgeInsets? actionPadding;
  final VoidCallback? onTap;

  const MyAlertDialog({
    super.key,
    required this.title,
    this.content,
    this.actions,
    this.onTap,
    this.actionPadding,
    this.titleTextStyle,
  }) : assert(
            (actions != null || onTap != null) &&
                !(actions != null && onTap != null),
            'Provide either custom actions or provide onTap');
  @override
  Widget build(BuildContext context) {
    final scheme = MyTheme.of(context);

    return AlertDialog(
      backgroundColor: scheme.surface,
      title: Text(title),
      titleTextStyle: titleTextStyle,
      content: content,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.borderDefault)),
      buttonPadding: const EdgeInsets.only(right: Dimens.sizeDefault),
      actionsPadding: actionPadding,
      actions: actions ??
          [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(StringRes.cancel)),
            TextButton(onPressed: onTap, child: const Text(StringRes.submit)),
          ],
    );
  }
}

class MyBottomSheet extends StatelessWidget {
  final String title;
  final TickerProvider vsync;
  final Color? bgColor;
  final bool? isExpanded;
  final VoidCallback? onClose;
  final Widget child;

  const MyBottomSheet({
    super.key,
    required this.title,
    required this.vsync,
    this.bgColor,
    this.onClose,
    this.isExpanded,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return BottomSheet(
        onClosing: onClose ?? () {},
        backgroundColor: bgColor ?? scheme.background,
        animationController: BottomSheet.createAnimationController(vsync),
        builder: (_) {
          return SafeArea(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 75),
                Text(title,
                    style: const TextStyle(
                      fontSize: Dimens.fontExtraLarge,
                      fontWeight: FontWeight.w600,
                    )),
                Padding(
                  padding: const EdgeInsets.only(right: Dimens.sizeDefault),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact),
                    child: const Text(
                      StringRes.close,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.sizeSmall),
            const MyDivider(),
            const SizedBox(height: Dimens.sizeDefault),
            if (isExpanded ?? false) Expanded(child: child) else child
          ]));
        });
  }
}
