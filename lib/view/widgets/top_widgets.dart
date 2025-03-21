import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi_tracker/services/extension_services.dart';
import 'package:wifi_tracker/services/theme_services.dart';
import '../../model/utils/dimens.dart';
import '../../model/utils/strings.dart';

class MyDivider extends StatelessWidget {
  final double? width;
  final double? thickness;
  final double? margin;
  final Color? color;
  const MyDivider({
    super.key,
    this.width,
    this.thickness,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: margin ?? 0),
        width: width,
        child: Divider(
          color: color ?? scheme.backgroundDark,
          thickness: thickness,
        ));
  }
}

class PaginationDots extends StatelessWidget {
  final bool current;
  final Color? color;
  final double? margin;
  final VoidCallback? onTap;
  const PaginationDots({
    super.key,
    required this.current,
    this.onTap,
    this.color,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = MyTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: margin ?? 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimens.borderDefault),
        onTap: onTap,
        child: CircleAvatar(
          radius: 3,
          backgroundColor: color ??
              (current ? scheme.primary : scheme.disabled.withAlpha(100)),
        ),
      ),
    );
  }
}

class ToolTipWidget extends StatelessWidget {
  final EdgeInsets? margin;
  final dynamic _icon;
  final bool? _scrolable;
  final Alignment? alignment;
  final String? title;
  final bool _placeHolder;

  const ToolTipWidget({
    super.key,
    this.margin,
    Widget? icon,
    this.title,
    this.alignment,
  })  : _icon = icon,
        _scrolable = null,
        _placeHolder = false;

  const ToolTipWidget.placeHolder({
    super.key,
    String? icon,
    bool? scrolable,
    required this.title,
  })  : _icon = icon,
        _scrolable = scrolable,
        _placeHolder = true,
        margin = null,
        alignment = null;

  @override
  Widget build(BuildContext context) {
    final scheme = MyTheme.of(context);

    if (_placeHolder) {
      final widget = Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: context.height * .15,
          left: Dimens.sizeDefault,
          right: Dimens.sizeDefault,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_icon != null) ...[
              Image.asset(
                _icon,
                width: context.width * .3,
                color: scheme.disabled,
              ),
              const SizedBox(height: Dimens.sizeDefault),
            ],
            Text(
              title ?? StringRes.errorUnknown,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.textColorLight),
            ),
          ],
        ),
      );

      if (_scrolable ?? false) {
        return Expanded(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: widget,
          ),
        );
      }

      return widget;
    }

    return Container(
      margin: margin ??
          EdgeInsets.only(
            top: context.height * .1,
            left: Dimens.sizeDefault,
            right: Dimens.sizeDefault,
          ),
      alignment: alignment ?? Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_icon != null) ...[
            _icon!,
            const SizedBox(height: Dimens.sizeDefault),
          ],
          Text(
            title ?? StringRes.errorUnknown,
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.textColorLight),
          ),
        ],
      ),
    );
  }
}

class SliverSizedBox extends StatelessWidget {
  final double? height;
  final double? width;
  const SliverSizedBox({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: SizedBox(height: height, width: width));
  }
}
