import 'package:flutter/material.dart';
import 'package:medical_devices_app/modules/home/controller/favorite_controller.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/widgets/animated_entry.dart';
import 'package:provider/provider.dart';

import '../../../core/services/remote_services/base_model.dart';
import '../../../core/utils/color_manager.dart';
import '../controller/home_controller.dart';
import 'home_product_card.dart';

class LastAddedSection extends StatelessWidget {
  const LastAddedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, homeProvider, child) {
        final isLoaded =
            homeProvider.lastAddedDevices.status == Status.COMPLETED;
        final devices = homeProvider.lastAddedDevices.data ?? [];

        return SizedBox(
          height: 268,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: isLoaded ? devices.length : 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (isLoaded) {
                final item = devices[index];
                final favController = context.watch<FavoriteController>();
                final isFav = favController.isFavorite(item.deviceId);
                return AnimatedEntry(
                  delay: Duration(milliseconds: 45 * index),
                  offset: const Offset(0.05, 0),
                  child: HomeProductCard(
                    item: item,
                    isFavorite: isFav,
                    badge: 'جديد',
                    badgeColor: ColorManager.teal,
                  ),
                );
              } else if (homeProvider.lastAddedDevices.status == Status.ERROR) {
                return const Icon(Icons.error, size: 50);
              } else {
                return const _ProductSkeleton();
              }
            },
            separatorBuilder: (context, index) => const SizedBox(width: 12),
          ),
        );
      },
    );
  }
}

class _ProductSkeleton extends StatelessWidget {
  const _ProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: 184,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
