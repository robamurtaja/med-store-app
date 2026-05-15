import 'package:flutter/material.dart';
import 'package:medical_devices_app/core/widgets/netwrok_image_widget.dart';
import 'package:medical_devices_app/modules/home/controller/favorite_controller.dart';
import '../../../core/router/router.dart';
import '../../../core/router/routers_name.dart';
import '../../../core/services/remote_services/base_model.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/extentions.dart';
import '../../../core/widgets/animated_entry.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../home/model/device_model.dart';
import '../controller/category_controller.dart';
import '../model/category_model.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/appbar_custom.dart';

class DeviceView extends StatefulWidget {
  const DeviceView({super.key, required this.category});

  final CategoryModel category;

  @override
  State<DeviceView> createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {
  _ProductSort _sort = _ProductSort.latest;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CategoryController>().getDevices(
          widget.category.categoryId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: widget.category.name),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<CategoryController>(
        builder: (context, categoryProvider, child) {
          if (categoryProvider.devices.status == Status.COMPLETED) {
            final devices = _sortedDevices(categoryProvider.devices.data ?? []);
            if (devices.isEmpty) {
              return const _EmptyProductsState();
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _SortBar(
                    selected: _sort,
                    onChanged: (value) => setState(() => _sort = value),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final device = devices[index];
                      final favController = context.watch<FavoriteController>();
                      final isFav = favController.isFavorite(device.deviceId);
                      return AnimatedEntry(
                        delay: Duration(milliseconds: 35 * index),
                        child: _DeviceCard(device: device, isFav: isFav),
                      );
                    }, childCount: devices.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                  ),
                ),
              ],
            );
          } else if (categoryProvider.devices.status == Status.ERROR) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ',
                    style: context.h1.copyWith(color: Colors.red, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    categoryProvider.devices.message ?? 'فشل تحميل المنتجات',
                    style: context.b1.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.62),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return loading();
          }
        },
      ),
    );
  }

  List<DeviceModel> _sortedDevices(List<DeviceModel> devices) {
    final result = List<DeviceModel>.of(devices);
    switch (_sort) {
      case _ProductSort.latest:
        return result.reversed.toList();
      case _ProductSort.mostOrdered:
        result.sort((a, b) => a.name.compareTo(b.name));
        return result;
      case _ProductSort.lowPrice:
        result.sort((a, b) => _priceOf(a).compareTo(_priceOf(b)));
        return result;
      case _ProductSort.highPrice:
        result.sort((a, b) => _priceOf(b).compareTo(_priceOf(a)));
        return result;
    }
  }

  int _priceOf(DeviceModel device) => int.tryParse(device.price) ?? 0;
}

class _SortBar extends StatelessWidget {
  const _SortBar({required this.selected, required this.onChanged});

  final _ProductSort selected;
  final ValueChanged<_ProductSort> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = const [
      _SortOption(_ProductSort.latest, Icons.new_releases_outlined, 'الأحدث'),
      _SortOption(
        _ProductSort.mostOrdered,
        Icons.local_fire_department_outlined,
        'الأكثر طلباً',
      ),
      _SortOption(
        _ProductSort.lowPrice,
        Icons.south_east_rounded,
        'الأقل سعراً',
      ),
      _SortOption(
        _ProductSort.highPrice,
        Icons.north_east_rounded,
        'الأعلى سعراً',
      ),
    ];

    return SizedBox(
      height: 62,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = selected == option.value;
          return ChoiceChip(
            selected: isSelected,
            onSelected: (_) => onChanged(option.value),
            avatar: Icon(
              option.icon,
              size: 17,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.64),
            ),
            label: Text(option.label),
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
            selectedColor: ColorManager.teal,
            backgroundColor: Theme.of(context).colorScheme.surface,
            side: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(0.45),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: options.length,
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.device, required this.isFav});

  final DeviceModel device;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationManager.pushNamed(
          RouteName.devicesDetailsView,
          arguments: device,
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.42),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest.withOpacity(0.45),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          device.name,
                          style: context.b1.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManager.teal.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '\$${device.price}',
                            style: context.b1.copyWith(
                              color: ColorManager.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
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
          Positioned(
            top: 8,
            left: 8,
            child: IconButton(
              onPressed: () {
                context.read<FavoriteController>().toggleFavorite(device);
              },
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.all(8),
              ),
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav
                    ? Colors.red
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 82,
              width: 82,
              decoration: BoxDecoration(
                color: ColorManager.teal.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 42,
                color: ColorManager.teal,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد منتجات حالياً',
              style: context.h1.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'سيتم إضافة منتجات جديدة لهذا التصنيف قريباً.',
              textAlign: TextAlign.center,
              style: context.b1.copyWith(
                fontSize: 14,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.62),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortOption {
  const _SortOption(this.value, this.icon, this.label);

  final _ProductSort value;
  final IconData icon;
  final String label;
}

enum _ProductSort { latest, mostOrdered, lowPrice, highPrice }
