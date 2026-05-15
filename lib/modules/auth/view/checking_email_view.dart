import 'package:flutter/material.dart';
import '../../../core/router/router.dart';
import '../../../core/router/routers_name.dart';
import '../../../core/utils/extentions.dart';

import '../../../core/utils/asset_path_manager.dart';
import '../../../core/utils/color_manager.dart';

class CheckingEmailView extends StatelessWidget {
  const CheckingEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _Background(),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _Content(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF6FB1FC)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// 📩 Image / Icon
          Image.asset(AssetPathManager.checkEmail, height: 120),

          const SizedBox(height: 15),

          /// 🏷 Title
          Text(
            'تحقق من بريدك الإلكتروني',
            style: context.h1.copyWith(fontSize: 22, color: Colors.black87),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          /// 📝 Description
          Text(
            'لقد أرسلنا رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.\nيرجى التحقق من صندوق الوارد.',
            style: context.b1.copyWith(color: Colors.grey[700], fontSize: 15),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 25),

          /// 🚀 Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                NavigationManager.popUntil(RouteName.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'العودة لتسجيل الدخول',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
