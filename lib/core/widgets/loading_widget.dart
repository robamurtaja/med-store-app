import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../router/router.dart';
import '../utils/color_manager.dart';
import '../utils/extentions.dart';

void loadingWithText({
  String? text,
}) {
  showDialog(
      context: NavigationManager.navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => Center(
            child: SizedBox(
              height: 100,
              width: 250,
              child: Dialog(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text ?? 'يرجى الانتظار....   ',
                      style: context.l1.copyWith(
                        fontSize: 17,
                      ),
                    ),
                    const SpinKitDualRing(
                      color: ColorManager.blue,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ));
}

Center loading() {
  return const Center(
    child: SizedBox(
      height: 150,
      width: 250,
      child: SpinKitWave(
        color: ColorManager.blue,
        size: 50.0,
      ),
    ),
  );
}
