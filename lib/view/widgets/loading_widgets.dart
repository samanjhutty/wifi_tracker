import 'package:flutter/material.dart';
import 'package:wifi_tracker/services/extension_services.dart';
import '../../model/utils/dimens.dart';

class LoadingButton extends StatelessWidget {
  final Widget child;
  final bool? isLoading;
  final bool enable;
  final Color? loaderColor;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? border;
  final EdgeInsets? margin;
  final double? width;
  final bool defWidth;
  final bool compact;
  final VoidCallback onPressed;
  const LoadingButton({
    super.key,
    this.padding,
    this.margin,
    this.width,
    this.enable = true,
    this.defWidth = false,
    this.compact = false,
    this.backgroundColor,
    this.foregroundColor,
    this.loaderColor,
    this.border,
    this.isLoading,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return Container(
      margin: margin,
      width: defWidth ? null : width ?? 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? scheme.primary,
          foregroundColor: foregroundColor ?? scheme.onPrimary,
          visualDensity: compact ? VisualDensity.compact : null,
          shape:
              border != null
                  ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(border!)),
                  )
                  : null,
          padding:
              padding ??
              const EdgeInsets.symmetric(vertical: Dimens.sizeDefault),
        ),
        onPressed: enable && !(isLoading ?? false) ? onPressed : null,
        child:
            enable && (isLoading ?? false)
                ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: loaderColor ?? scheme.primary,
                  ),
                )
                : child,
      ),
    );
  }
}

class LoadingIcon extends StatelessWidget {
  final Widget icon;
  final bool loading;
  final double? iconSize;
  final double? loaderSize;
  final Widget? selectedIcon;
  final bool? isSelected;
  final ButtonStyle? style;
  final VoidCallback onPressed;
  const LoadingIcon({
    super.key,
    required this.icon,
    required this.loading,
    required this.onPressed,
    this.iconSize,
    this.loaderSize,
    this.isSelected,
    this.selectedIcon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;

    return IconButton(
      style:
          style ??
          IconButton.styleFrom(
            padding: const EdgeInsets.all(Dimens.sizeMedSmall),
            foregroundColor: scheme.textColor,
          ),
      isSelected: isSelected,
      selectedIcon: selectedIcon,
      onPressed: onPressed,
      iconSize: iconSize,
      icon:
          loading
              ? Container(
                height: loaderSize,
                width: loaderSize,
                alignment: Alignment.center,
                child: SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(color: scheme.primary),
                ),
              )
              : icon,
    );
  }
}

class LoadingTextButton extends StatelessWidget {
  final String label;
  final bool? loading;
  final double? loaderSize;
  final double? width;
  final VoidCallback onPressed;

  const LoadingTextButton({
    super.key,
    this.loading,
    this.width,
    this.loaderSize,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return SizedBox(
      width: width ?? 80,
      child: Builder(
        builder: (context) {
          if (loading ?? false) {
            return Align(
              alignment: Alignment.center,
              child: SizedBox.square(
                dimension: loaderSize ?? 24,
                child: CircularProgressIndicator(color: scheme.primary),
              ),
            );
          }
          return TextButton(
            onPressed: onPressed,
            style: IconButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: Dimens.sizeSmall),
            ),
            child: Text(label),
          );
        },
      ),
    );
  }
}
