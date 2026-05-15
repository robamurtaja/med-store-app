import 'package:flutter/material.dart';
import 'package:medical_devices_app/modules/home/view/favorite_screen.dart';
import '../controller/bnb_controller.dart';
import '../model/bnb_model.dart';
import '../../order/view/order_view.dart';
import 'package:provider/provider.dart';

import '../../category/view/category_view.dart';
import '../../home/view/home_view.dart';
import '../../profile/view/profile_view.dart';

class MainAppView extends StatelessWidget {
  const MainAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final bnbProvider = context.watch<BnbController>();
    return Scaffold(
      body: taps[bnbProvider.selectedTabIndex],
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
          context.read<BnbController>().changeIndex(4);
        },
        child: const Icon(Icons.favorite),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        shape: const CircularNotchedRectangle(), // 👈 THIS is what you want
        notchMargin: 6,
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(context, 0, Icons.home, bnbContent[0].text),
              _buildItem(context, 1, Icons.category, bnbContent[1].text),

              const SizedBox(width: 40), // 👈 space for FAB

              _buildItem(context, 2, Icons.receipt, bnbContent[2].text),
              _buildItem(context, 3, Icons.person, bnbContent[3].text),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final provider = context.watch<BnbController>();
    final isSelected = provider.selectedTabIndex == index;
    final colorScheme = Theme.of(context).colorScheme;
    final color = isSelected
        ? colorScheme.primary
        : colorScheme.onSurface.withOpacity(0.56);

    return GestureDetector(
      onTap: () {
        context.read<BnbController>().changeIndex(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}

List<Widget> taps = [
  const HomeView(),
  const CategoryView(),
  const OrdersScreen(),
  const ProfileView(),
  const FavoriteScreen(),
];
