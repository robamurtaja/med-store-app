import 'package:flutter/material.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/widgets/appbar_custom.dart';
import '../controller/profile_controller.dart';
import 'package:provider/provider.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(title: 'تواصل معنا'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // Header Card
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    ColorManager.blue.withOpacity(0.08),
                    ColorManager.blue.withOpacity(0.04),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.help_outline_rounded,
                    color: ColorManager.blue,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'كيف يمكننا مساعدتك؟',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'شكرًا لاستخدامكم متجرنا الإلكتروني للأجهزة الطبية. إذا كان لديك أي استفسارات أو تحتاج إلى مساعدة، فلا تتردد في التواصل معنا.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.62),
                      height: 1.5,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'اختر وسيلة التواصل',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ContactUsButton(
            icon: Icons.chat_bubble_outline,
            text: 'رسالة واتساب',
            subtitle: 'الرد السريع والفوري',
            onPressed: () {
              context.read<ProfileController>().whatsappSupport();
            },
          ),
          const SizedBox(height: 12),
          ContactUsButton(
            icon: Icons.call_outlined,
            text: 'مكالمة هاتفية',
            subtitle: 'تحدث مباشرة معنا',
            onPressed: () {
              context.read<ProfileController>().callSupport();
            },
          ),
          const SizedBox(height: 12),
          ContactUsButton(
            icon: Icons.email_outlined,
            text: 'تواصل عبر الإيميل',
            subtitle: 'احصل على إجابة مفصلة',
            onPressed: () {
              context.read<ProfileController>().emailSupport();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ContactUsButton extends StatelessWidget {
  const ContactUsButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.text,
    this.subtitle,
  });
  final IconData icon;
  final String text;
  final String? subtitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorManager.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: ColorManager.blue, size: 26),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.62),
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.withOpacity(0.4),
                    size: 16,
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
