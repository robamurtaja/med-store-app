import 'package:flutter/material.dart';
import 'package:medical_devices_app/core/services/local_services/shared_perf.dart';
import 'package:medical_devices_app/core/widgets/netwrok_image_widget.dart';
import 'package:medical_devices_app/modules/home/controller/favorite_controller.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/router/router.dart';
import '../../../core/router/routers_name.dart';
import '../../../core/services/remote_services/base_model.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/extentions.dart';
import '../../../core/widgets/appbar_custom.dart';
import '../controller/category_controller.dart';
import '../../home/model/device_model.dart';
import '../../order/controller/order_controller.dart';
import 'package:provider/provider.dart';
// import 'package:skeletons/skeletons.dart';

class DeviceDetailsView extends StatefulWidget {
  const DeviceDetailsView({super.key, required this.deviceModel});
  final DeviceModel deviceModel;

  @override
  State<DeviceDetailsView> createState() => _DeviceDetailsViewState();
}

class _DeviceDetailsViewState extends State<DeviceDetailsView> {
  late int totalPrice;
  late int quantity;

  @override
  void initState() {
    super.initState();
    totalPrice = widget.deviceModel.priceValue;
    quantity = 1;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CategoryController>().getLastAddedDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favController = context.watch<FavoriteController>();
    final isFav = favController.isFavorite(widget.deviceModel.deviceId);
    return Scaffold(
      appBar: AppBarCustom(title: widget.deviceModel.name),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                // Clean Product Image Section
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                      // margin: const EdgeInsets.all(16),
                      height: 300,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: NetworkCustomImageWidget(
                        height: 300,
                        imageUrl: widget.deviceModel.image,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 8,
                      left: 8,
                      child: IconButton(
                        onPressed: () {
                          context.read<FavoriteController>().toggleFavorite(
                            widget.deviceModel,
                          );
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                          padding: const EdgeInsets.all(8),
                        ),
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav
                              ? Colors.red
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.58),
                        ),
                      ),
                    ),
                  ],
                ),
                // Product Details Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.deviceModel.name,
                        style: context.h1.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Price Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: ColorManager.teal.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '\$${widget.deviceModel.price}',
                          style: context.h1.copyWith(
                            color: ColorManager.teal,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Divider
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      const SizedBox(height: 16),
                      // Description Label
                      Text(
                        'المواصفات والوصف',
                        style: context.h1.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Description Text
                      Text(
                        widget.deviceModel.details,
                        style: context.b1.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.68),
                          fontSize: 15,
                          height: 1.8,
                        ),
                      ),
                      Text(
                        'المميزات:',
                        style: context.h1.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      ...widget.deviceModel.points.map(
                        (value) => Text(
                          "🔹 $value",
                          style: context.b1.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.68),
                            fontSize: 15,
                            height: 1.8,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      Text(
                        ' مناسب لـ',
                        style: context.h1.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Description Text
                      Text(
                        widget.deviceModel.forUsage,
                        style: context.b1.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.68),
                          fontSize: 15,
                          height: 1.8,
                        ),
                      ),

                      Text(
                        'ملاحظات',
                        style: context.h1.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Description Text
                      Text(
                        widget.deviceModel.note,
                        style: context.b1.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.68),
                          fontSize: 15,
                          height: 1.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Related Products Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'منتجات ذات صلة',
                        style: context.h1.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Consumer<CategoryController>(
                        builder: (context, categoryController, child) {
                          return SizedBox(
                            height: 240,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  categoryController
                                      .lastAddedDevices
                                      .data
                                      ?.length ??
                                  5,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                if (categoryController
                                        .lastAddedDevices
                                        .status ==
                                    Status.COMPLETED) {
                                  final device = categoryController
                                      .lastAddedDevices
                                      .data?[index];
                                  if (device == null) {
                                    return const SizedBox.shrink();
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      NavigationManager.pushNamedReplacement(
                                        RouteName.devicesDetailsView,
                                        arguments: device,
                                      );
                                    },
                                    child: Container(
                                      width: 160,
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.06,
                                            ),
                                            blurRadius: 12,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 140,
                                            width: 160,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainerHighest
                                                  .withOpacity(0.42),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                      16,
                                                    ),
                                                    topRight: Radius.circular(
                                                      16,
                                                    ),
                                                  ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                      16,
                                                    ),
                                                    topRight: Radius.circular(
                                                      16,
                                                    ),
                                                  ),
                                              child: NetworkCustomImageWidget(
                                                height: 140,
                                                imageUrl: device.image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    device.name,
                                                    style: context.b1.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.onSurface,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: ColorManager.teal
                                                          .withOpacity(0.12),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      '\$${device.price}',
                                                      style: context.b1
                                                          .copyWith(
                                                            color: ColorManager
                                                                .blue,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (categoryController
                                        .lastAddedDevices
                                        .status ==
                                    Status.ERROR) {
                                  return Container(
                                    width: 160,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.error_outline,
                                        color: Colors.red.withOpacity(0.5),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey.shade200,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      width: 160,
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          // Add to Cart Button - Fixed at Bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: Row(
                children: [
                  Flexible(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () async {
                        if (SharedPrefController().getLoggedIn()) {
                          final added = await context
                              .read<CategoryController>()
                              .addToCart(widget.deviceModel, quantity);
                          if (added && context.mounted) {
                            context.read<OrderController>().getCartDevices();
                          }
                        } else {
                          NavigationManager.pushNamed(RouteName.auth);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_shopping_cart_outlined,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${totalPrice.toString()} اضافة للسلة',
                            style: context.h1.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: IconButton(
                          onPressed: () {
                            if (quantity == 1) {
                              return;
                            }
                            --quantity;
                            totalPrice =
                                quantity * widget.deviceModel.priceValue;
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.remove,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          quantity.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Flexible(
                        child: IconButton(
                          onPressed: () {
                            ++quantity;
                            totalPrice =
                                quantity * widget.deviceModel.priceValue;
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.onSurface,
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
    );
  }
}
