import 'package:flutter/material.dart';
import '../../../core/router/router.dart';
import '../../../core/utils/asset_path_manager.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/extentions.dart';
import '../../../core/utils/validation.dart';
import '../../../core/widgets/animated_entry.dart';
import '../../../core/widgets/text_field_widget.dart';
import '../controller/auth_controller.dart';
import 'package:provider/provider.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: ColorManager.premiumGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: IconButton(
                      onPressed: NavigationManager.mayPop,
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 36),
                  AnimatedEntry(
                    child: Image.asset(
                      AssetPathManager.forgetPassword,
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 90),
                    child: Text(
                      'استعادة كلمة المرور',
                      style: context.h1.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 140),
                    child: Text(
                      'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين.',
                      style: context.b1.copyWith(
                        color: Colors.white.withOpacity(0.78),
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 220),
                    child: _ResetCard(emailController: emailController),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResetCard extends StatelessWidget {
  final TextEditingController emailController;

  const _ResetCard({required this.emailController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFieldWidget(
            controller: emailController,
            hintText: 'البريد الإلكتروني',
            prefixIcon: Icons.email_outlined,
            validator: (value) => (value ?? '').isValidEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (Form.of(context).validate()) {
                context.read<AuthController>().sendEmailResetPassword(
                  email: emailController.text.trim(),
                );
              }
            },
            child: const Text('إرسال الرابط'),
          ),
        ],
      ),
    );
  }
}
