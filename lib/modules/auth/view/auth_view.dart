import 'package:flutter/material.dart';
import 'package:medical_devices_app/core/services/local_services/shared_perf.dart';
import '../../../core/router/router.dart';
import '../../../core/router/routers_name.dart';
import '../../../core/utils/asset_path_manager.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/extentions.dart';
import '../../../core/widgets/animated_entry.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: ColorManager.premiumGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 18),
                AnimatedEntry(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Text(
                        'MedStore',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                AnimatedEntry(
                  delay: const Duration(milliseconds: 90),
                  child: Image.asset(
                    AssetPathManager.authImage,
                    height: 230,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 26),
                AnimatedEntry(
                  delay: const Duration(milliseconds: 160),
                  child: Text(
                    'أجهزة طبية موثوقة تصل إلى بابك',
                    textAlign: TextAlign.center,
                    style: context.h1.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AnimatedEntry(
                  delay: const Duration(milliseconds: 220),
                  child: Text(
                    'تصفح المنتجات، احفظ المفضلة، وأكمل طلبك بتجربة واضحة وآمنة.',
                    textAlign: TextAlign.center,
                    style: context.b1.copyWith(
                      color: Colors.white.withOpacity(0.78),
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ),
                const Spacer(),
                const AnimatedEntry(
                  delay: Duration(milliseconds: 300),
                  child: _Actions(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              NavigationManager.goToAndRemove(RouteName.register);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: ColorManager.navy,
            ),
            child: const Text('إنشاء حساب'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              NavigationManager.goToAndRemove(RouteName.login);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white54),
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('تسجيل الدخول'),
          ),
        ),
        TextButton(
          onPressed: () {
            SharedPrefController().setGuestUser(value: true);
            NavigationManager.goToAndRemove(RouteName.mainAppView);
          },
          child: Text(
            'المتابعة كزائر',
            style: TextStyle(color: Colors.white.withOpacity(0.82)),
          ),
        ),
      ],
    );
  }
}
