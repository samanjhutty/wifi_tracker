import 'package:flutter/material.dart';
import '../../model/utils/color_resources.dart';

class Shimmer {
  static get avatar => const _Shimmer(borderRadius: 50);
  static get box => const _Shimmer();
}

class _Shimmer extends StatelessWidget {
  final double? borderRadius;
  const _Shimmer({this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: ColorRes.shimmer,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0))),
    );
  }
}
