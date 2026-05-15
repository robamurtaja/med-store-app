import 'package:flutter/material.dart';
import '../../../core/router/router.dart';
import '../../../core/router/routers_name.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/extentions.dart';
import '../../../core/utils/validation.dart';
import '../../../core/widgets/animated_entry.dart';
import '../../../core/widgets/text_field_widget.dart';
import '../controller/auth_controller.dart';
import '../models/user_model.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
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
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
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
                        AnimatedEntry(
                          child: Text(
                            'إنشاء حساب جديد',
                            style: context.h1.copyWith(
                              color: Colors.white,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        AnimatedEntry(
                          delay: const Duration(milliseconds: 90),
                          child: Text(
                            'أدخل بياناتك مرة واحدة، وبعدها اطلب الأجهزة الطبية بسهولة.',
                            style: context.b1.copyWith(
                              color: Colors.white.withOpacity(0.78),
                              height: 1.5,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        AnimatedEntry(
                          delay: const Duration(milliseconds: 160),
                          child: _RegisterForm(
                            formKey: formKey,
                            nameController: nameController,
                            emailController: emailController,
                            mobileController: mobileController,
                            passwordController: passwordController,
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedEntry(
                          delay: const Duration(milliseconds: 240),
                          child: const _LoginSection(),
                        ),
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

class _RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController passwordController;

  const _RegisterForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.mobileController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFieldWidget(
            controller: nameController,
            hintText: 'اسم المستخدم',
            prefixIcon: Icons.person_outline,
            validator: (value) => (value ?? '').isValidName,
          ),
          const SizedBox(height: 10),
          TextFieldWidget(
            controller: emailController,
            hintText: 'البريد الإلكتروني',
            prefixIcon: Icons.email_outlined,
            validator: (value) => (value ?? '').isValidEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          TextFieldWidget(
            controller: mobileController,
            hintText: 'رقم الجوال',
            prefixIcon: Icons.phone_iphone_outlined,
            validator: (value) => (value ?? '').isValidPhone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 10),
          TextFieldWidget(
            controller: passwordController,
            hintText: 'كلمة المرور',
            isPassword: true,
            prefixIcon: Icons.lock_outline,
            validator: (value) => (value ?? '').isValidPassword,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if ((formKey.currentState?.validate() ?? false)) {
                context.read<AuthController>().register(
                  UserModel(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    phone: mobileController.text.trim(),
                    password: passwordController.text,
                  ),
                );
              }
            },
            child: const Text('إنشاء الحساب'),
          ),
        ],
      ),
    );
  }
}

class _LoginSection extends StatelessWidget {
  const _LoginSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لديك حساب؟',
          style: context.b1.copyWith(color: Colors.white.withOpacity(0.78)),
        ),
        TextButton(
          onPressed: () {
            NavigationManager.pushNamedReplacement(RouteName.login);
          },
          child: const Text(
            'تسجيل الدخول',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
