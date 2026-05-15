import 'package:flutter/material.dart';
import 'package:medical_devices_app/core/services/local_services/shared_perf.dart';
import '../../../core/router/router.dart';
import '../../../core/router/routers_name.dart';
import '../../../core/widgets/appbar_custom.dart';
import '../../../core/widgets/dialog_custome.dart';
import '../controller/profile_controller.dart';
import 'components/personal_cart.dart';
import 'components/profile_listTile.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(title: 'الملف الشخصي'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          SharedPrefController().getGuestUser() == true
              ? Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_outlined,
                            color: Colors.orange.shade600,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'أنت تستخدم التطبيق كزائر، بعض الميزات قد تكون محدودة. قم بإنشاء حساب للاستمتاع بتجربة كاملة.',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.orange.shade800),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        NavigationManager.pushNamed(RouteName.auth);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('تسجيل الدخول / إنشاء حساب'),
                    ),
                  ],
                )
              : const PersonalCardInfo(),
          const SizedBox(height: 24),

          // Settings Section
          Text(
            'الإعدادات والدعم',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surface,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ProfileCustomListTile(
                    icon: Icons.mail_outline,
                    text: 'تواصل معنا',
                    onTap: () {
                      NavigationManager.pushNamed(RouteName.contactUsView);
                    },
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 1,
                    height: 1,
                  ),
                  ProfileCustomListTile(
                    icon: Icons.info_outline,
                    text: 'عن التطبيق',
                    onTap: () {
                      NavigationManager.pushNamed(RouteName.aboutAppView);
                    },
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 1,
                    height: 1,
                  ),
                  ProfileCustomListTile(
                    icon: Icons.description_outlined,
                    text: 'سياسة الاستخدام',
                    onTap: () {
                      NavigationManager.pushNamed(RouteName.usesPoliceView);
                    },
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 1,
                    height: 1,
                  ),
                  ProfileCustomListTile(
                    icon: Icons.security_outlined,
                    text: 'سياسة الخصوصية',
                    onTap: () {
                      NavigationManager.pushNamed(RouteName.privacyPoliceView);
                    },
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 1,
                    height: 1,
                  ),
                  ProfileCustomListTile(
                    icon: Icons.help_outline,
                    text: 'الأسئلة الشائعة',
                    onTap: () {
                      NavigationManager.pushNamed(RouteName.faqView);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Logout Section
          Visibility(
            visible: SharedPrefController().getLoggedIn() == true,
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      var value = await customDialogWidget(
                        context,
                        message: 'هل انت متأكد من تسجيل الخروج؟',
                      );
                      if (!context.mounted) return;
                      if (value == true) {
                        context.read<ProfileController>().logOut();
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.logout_outlined,
                              color: Colors.red.shade600,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'تسجيل الخروج',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.red.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.red.withOpacity(0.4),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
