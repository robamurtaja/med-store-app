import 'package:flutter/material.dart';
import 'package:medical_devices_app/core/widgets/netwrok_image_widget.dart';
import 'package:medical_devices_app/modules/home/controller/favorite_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/services/local_services/shared_perf.dart';

import '../../../core/router/router.dart';
import '../../../core/router/routers_name.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/extentions.dart';
import '../../category/controller/category_controller.dart';
import '../../order/controller/order_controller.dart';
import '../model/device_model.dart';

class HomeProductCard extends StatelessWidget {
  const HomeProductCard({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.badge,
    required this.badgeColor,
  });

  final DeviceModel item;
  final bool isFavorite;
  final String badge;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          NavigationManager.pushNamed(
            RouteName.devicesDetailsView,
            arguments: item,
          );
        },
        child: Container(
          width: 184,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.dividerColor.withOpacity(0.42)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.055),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: NetworkCustomImageWidget(
                      height: 124,
                      imageUrl: item.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(99),
                      onTap: () {
                        context.read<FavoriteController>().toggleFavorite(item);
                      },
                      child: Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.92),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? Colors.red
                              : theme.colorScheme.onSurface.withOpacity(0.58),
                          size: 19,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.b1.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          height: 1.22,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: ColorManager.gold,
                            size: 17,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '4.8',
                            style: context.b1.copyWith(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.62,
                              ),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'متوفر الآن',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.b1.copyWith(
                                fontSize: 12,
                                color: ColorManager.teal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '\$${item.price}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.h1.copyWith(
                                color: ColorManager.teal,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () async {
                              if (!SharedPrefController().getLoggedIn()) {
                                NavigationManager.pushNamed(RouteName.auth);
                                return;
                              }

                              final added = await context
                                  .read<CategoryController>()
                                  .addToCart(item, 1);
                              if (added && context.mounted) {
                                context
                                    .read<OrderController>()
                                    .getCartDevices();
                              }
                            },
                            child: Container(
                              height: 36,
                              width: 40,
                              decoration: BoxDecoration(
                                color: ColorManager.teal,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.add_shopping_cart_rounded,
                                color: Colors.white,
                                size: 19,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
