import 'package:flutter/material.dart';
import 'package:medical_devices_app/core/router/router.dart';
import 'package:medical_devices_app/core/router/routers_name.dart';
import 'package:medical_devices_app/core/utils/extentions.dart';
import 'package:medical_devices_app/core/widgets/appbar_custom.dart';
import 'package:medical_devices_app/core/widgets/netwrok_image_widget.dart';
import 'package:medical_devices_app/modules/home/controller/favorite_controller.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/color_manager.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favController = context.watch<FavoriteController>();
    final favorites = favController.favorites;

    return Scaffold(
      appBar: const AppBarCustom(title: 'المفضلة', showCart: false),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 30,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: ColorManager.blue.withValues(alpha: 0.5),
                    ),
                    child: Icon(
                      Icons.bookmark_border,
                      size: 40,
                      color: ColorManager.teal,
                    ),
                  ),
                  Text('لا يوجد عناصر في المفضلة', style: context.h1),
                ],
              ),
            )
          : ListView.separated(
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final device = favorites[index];

                return InkWell(
                  onTap: () {
                    NavigationManager.pushNamed(
                      RouteName.devicesDetailsView,
                      arguments: favorites[index],
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey.shade50],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          /// IMAGE
                          Container(
                            height: 90,
                            width: 90,
                            margin: const EdgeInsets.only(left: 12),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: NetworkCustomImageWidget(
                              height: 90,
                              imageUrl: device.image,
                              fit: BoxFit.cover,
                            ),
                          ),

                          /// TEXT
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  device.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorManager.teal.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '\$${device.price}',
                                    style: TextStyle(
                                      color: ColorManager.teal,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// DELETE BUTTON
                          IconButton(
                            onPressed: () {
                              context.read<FavoriteController>().toggleFavorite(
                                device,
                              );
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.red.shade600,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
