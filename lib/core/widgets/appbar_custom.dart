import 'package:flutter/material.dart';
import 'package:medical_devices_app/core/services/local_services/shared_perf.dart';
import 'package:provider/provider.dart';

import '../../modules/order/controller/order_controller.dart';
import '../router/router.dart';
import '../router/routers_name.dart';
import '../services/remote_services/base_model.dart';
import '../utils/color_manager.dart';
import '../utils/extentions.dart';
import '../utils/theme_controller.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom({
    super.key,
    required this.title,
    this.height = 70,
    this.bottom,
    this.showCart = false,
  });

  final String title;
  final double height;
  final PreferredSizeWidget? bottom;
  final bool showCart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = context.watch<ThemeController>();

    return AppBar(
      bottom: bottom,
      title: Text(
        title,
        style: context.h1.copyWith(
          fontSize: 20,
          color: theme.colorScheme.onSurface,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: height,
      centerTitle: true,
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      actions: [
        IconButton(
          tooltip: themeController.isDark ? 'الوضع النهاري' : 'الوضع الليلي',
          onPressed: themeController.toggleTheme,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Icon(
              themeController.isDark ? Icons.light_mode : Icons.dark_mode,
              key: ValueKey(themeController.isDark),
              color: themeController.isDark
                  ? ColorManager.gold
                  : ColorManager.teal,
            ),
          ),
        ),
        if (!SharedPrefController().getGuestUser() && showCart) ...[
          Consumer<OrderController>(
            builder: (context, value, child) => Stack(
              alignment: Alignment.topRight,
              children: [
                Center(
                  child: IconButton(
                    onPressed: () {
                      NavigationManager.pushNamed(RouteName.cartView);
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: ColorManager.teal,
                      size: 30,
                    ),
                  ),
                ),
                Visibility(
                  visible: value.cart.status == Status.COMPLETED
                      ? (value.cart.data?.isNotEmpty ?? false)
                      : false,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Icon(Icons.circle, color: Colors.amber, size: 17),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
