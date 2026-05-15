import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/utils/extentions.dart';
import 'package:provider/provider.dart';

import '../../../core/router/router.dart';
import '../../../core/router/routers_name.dart';
import '../../../core/services/remote_services/base_model.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/widgets/animated_entry.dart';
import '../../category/controller/category_controller.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {
        final isLoaded = categoryProvider.categories.status == Status.COMPLETED;
        final categories = categoryProvider.categories.data ?? [];

        return SizedBox(
          height: 92,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: isLoaded ? categories.length : 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (isLoaded) {
                final category = categories[index];
                final icons = [
                  Icons.monitor_heart_outlined,
                  Icons.medical_services_outlined,
                  Icons.health_and_safety_outlined,
                  Icons.biotech_outlined,
                ];
                return AnimatedEntry(
                  delay: Duration(milliseconds: 40 * index),
                  offset: const Offset(0.04, 0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      NavigationManager.pushNamed(
                        RouteName.devicesView,
                        arguments: category,
                      );
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).dividerColor.withOpacity(0.45),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.045),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              color: ColorManager.blue.withOpacity(0.11),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              icons[index % icons.length],
                              color: ColorManager.blue,
                              size: 23,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              category.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.h1.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (categoryProvider.categories.status == Status.ERROR) {
                return Text(
                  categoryProvider.categories.message ?? 'something went wrong',
                );
              } else {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 150,
                    height: 78,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                );
              }
            },
            separatorBuilder: (context, index) => const SizedBox(width: 10),
          ),
        );
      },
    );
  }
}
