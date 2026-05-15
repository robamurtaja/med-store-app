import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/router.dart';
import '../../../core/router/routers_name.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/extentions.dart';
import '../../../core/utils/validation.dart';
import '../../../core/widgets/animated_entry.dart';
import '../../../core/widgets/text_field_widget.dart';
import '../controller/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: ColorManager.premiumGradient),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: IconButton(
                            onPressed: () =>
                                NavigationManager.goToAndRemove(RouteName.auth),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.08),
                        AnimatedEntry(
                          child: Text(
                            'مرحباً بعودتك',
                            style: context.h1.copyWith(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AnimatedEntry(
                          delay: const Duration(milliseconds: 90),
                          child: Text(
                            'سجّل دخولك لمتابعة طلباتك وسلتك ومفضلتك.',
                            style: context.b1.copyWith(
                              color: Colors.white.withOpacity(0.78),
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 34),
                        AnimatedEntry(
                          delay: const Duration(milliseconds: 160),
                          child: _FormCard(
                            emailController: emailController,
                            passwordController: passwordController,
                            formKey: formKey,
                          ),
                        ),
                        const SizedBox(height: 22),
                        AnimatedEntry(
                          delay: const Duration(milliseconds: 240),
                          child: const _RegisterSection(),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.12),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 26,
            offset: const Offset(0, 16),
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
          const SizedBox(height: 14),
          TextFieldWidget(
            controller: passwordController,
            isPassword: true,
            hintText: 'كلمة المرور',
            prefixIcon: Icons.lock_outline,
            validator: (value) => (value ?? '').isValidPassword,
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: () {
                NavigationManager.pushNamed(RouteName.forgetPassword);
              },
              child: const Text(
                'هل نسيت كلمة المرور؟',
                style: TextStyle(color: ColorManager.teal),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if ((formKey.currentState?.validate() ?? false)) {
                context.read<AuthController>().login(
                  email: emailController.text.trim(),
                  password: passwordController.text,
                );
              }
            },
            child: const Text('تسجيل الدخول'),
          ),
        ],
      ),
    );
  }
}

class _RegisterSection extends StatelessWidget {
  const _RegisterSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ليس لديك حساب؟',
          style: context.b1.copyWith(color: Colors.white.withOpacity(0.78)),
        ),
        TextButton(
          onPressed: () {
            NavigationManager.pushNamedReplacement(RouteName.register);
          },
          child: const Text(
            'سجل الآن',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
