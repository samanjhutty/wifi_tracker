import 'package:flutter/material.dart';
import '../../model/utils/dimens.dart';
import '../../services/theme_services.dart';

class BaseWidget extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final BoxDecoration? decoration;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final bool? extendBody;
  final bool? safeAreaBottom;
  final bool? resizeBottom;
  final Widget child;

  const BaseWidget({
    super.key,
    this.appBar,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.extendBody,
    this.safeAreaBottom,
    this.resizeBottom,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = MyTheme.of(context);

    return Scaffold(
      appBar: appBar,
      backgroundColor: color ?? scheme.background,
      extendBody: extendBody ?? false,
      resizeToAvoidBottomInset: resizeBottom,
      body: Container(
        decoration: decoration,
        child: SafeArea(
            bottom: safeAreaBottom ?? false,
            child: Container(
              margin: margin,
              padding: padding ??
                  const EdgeInsets.symmetric(
                    horizontal: Dimens.sizeLarge,
                  ),
              child: child,
            )),
      ),
    );
  }
}
