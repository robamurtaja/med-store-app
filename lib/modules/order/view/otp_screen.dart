import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_devices_app/core/router/router.dart';
import 'package:medical_devices_app/core/router/routers_name.dart';
import 'package:medical_devices_app/core/utils/app_size_extension.dart';
import 'package:medical_devices_app/core/utils/extentions.dart';
import 'package:medical_devices_app/core/utils/validation.dart';
import 'package:medical_devices_app/core/widgets/appbar_custom.dart';
import 'package:medical_devices_app/core/widgets/show_snackbar.dart';
import 'package:medical_devices_app/modules/bnb/controller/bnb_controller.dart';
import 'package:medical_devices_app/modules/order/controller/order_controller.dart';
import 'package:medical_devices_app/modules/order/controller/timer_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart' hide Consumer;

class OtpArgs {
  final String mobile;
  final String address;
  OtpArgs(this.mobile, this.address);
}

class OtpScreen extends StatefulHookConsumerWidget {
  const OtpScreen({super.key, required this.otpArgs});
  final OtpArgs otpArgs;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(timerProvider.notifier).startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final code = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new);

    return Scaffold(
      appBar: AppBarCustom(title: 'تاكيد رمز التحقق'),
      body: ListView(
        padding: context.spaceHorizontal(24),
        children: [
          const SizedBox(height: 20),
          Text(
            "تم ارسال رمز التحقق الى رقم الهاتف *******${widget.otpArgs.mobile.substring(widget.otpArgs.mobile.length - 4)}"
            "\nيرجى ادخال الرمز لتأكيد الطلب",
            style: context.h1.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),
          Form(
            key: formKey,

            child: Pinput(
              controller: code,
              length: 6,
              errorTextStyle: context.b1.copyWith(color: Colors.red),
              defaultPinTheme: PinTheme(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.grey),
                ),
              ),
              cursor: Text('_'),
              focusedPinTheme: PinTheme(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.teal),
                ),
              ),
              errorPinTheme: PinTheme(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.red),
                ),
              ),
              validator: (value) => value?.validateOTP,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                if (code.text == '123456') {
                  context
                      .read<OrderController>()
                      .completeOrder(
                        address: widget.otpArgs.address,
                        mobile: widget.otpArgs.mobile,
                      )
                      .then((value) {
                        if (context.mounted) {
                          NavigationManager.popUntil(RouteName.mainAppView);
                          context.read<BnbController>().changeIndex(2);
                          showSnackBarCustom(
                            text: 'تم تأكيد الطلب بنجاح',
                            backgroundColor: Colors.green,
                          );
                        }
                      });
                } else {
                  showSnackBarCustom(
                    text: 'الرمز غير صحيح',
                    backgroundColor: Colors.red,
                  );
                }
              }
            },
            child: Text('تأكيد'),
          ),
          const SizedBox(height: 20),

          Consumer(
            builder: (context, ref, child) {
              final timer = ref.watch(timerProvider);
              final timerCall = ref.read(timerProvider.notifier);
              return timer.isTimerRunning
                  ? Text(
                      "الكود سيعاد ارساله بعد ${timerCall.formatTime(timer.remainingTime)}",

                      style: context.b1.copyWith(color: Colors.teal),
                      textAlign: TextAlign.center,
                    )
                  : InkWell(
                      onTap: () {
                        showSnackBarCustom(
                          text: 'تم إعادة إرسال الرمز',
                          backgroundColor: Colors.green,
                        );
                        timerCall.resetTimer();
                        timerCall.startTimer();
                      },

                      child: Text(
                        'إعادة إرسال الرمز',
                        style: context.b1.copyWith(color: Colors.teal),
                        textAlign: TextAlign.center,
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
