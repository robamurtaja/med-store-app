import 'package:flutter/material.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/extentions.dart';
import '../../../core/widgets/appbar_custom.dart';
import 'active_order_view.dart';
import 'completed_ordered_view.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(140),
          child: AppBarCustom(
            height: 140,
            title: 'طلباتي',
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).shadowColor.withOpacity(0.10),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TabBar(
                      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorManager.blue.withOpacity(0.12),
                      ),
                      dividerColor: Colors.transparent,
                      labelStyle: context.h1.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorManager.blue,
                      ),
                      unselectedLabelStyle: context.b1.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.62),
                      ),
                      labelColor: ColorManager.blue,
                      unselectedLabelColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.62),
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.hourglass_top, size: 20),
                              const SizedBox(width: 8),
                              const Text('قيد التنفيذ'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_outline, size: 20),
                              const SizedBox(width: 8),
                              const Text('مستلمة'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [ActiveOrderView(), CompletedOrderedView()],
        ),
      ),
    );
  }
}
