import 'package:flutter/material.dart';
import '../../../../core/utils/extentions.dart';

import '../../../../core/utils/asset_path_manager.dart';
import '../../../../core/utils/constant.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height / 9,
        ),
        Image.asset(
          AssetPathManager.logo,
          height: 100,
          width: 76,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
         title,
          style: context.h1.copyWith(fontSize: 30),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
