import 'package:flutter/material.dart';
import 'package:medical_devices_app/core/widgets/netwrok_image_widget.dart';
import '../../../core/router/router.dart';
import '../../../core/router/routers_name.dart';
import '../../../core/services/remote_services/base_model.dart';
import '../../../core/utils/extentions.dart';
import '../../../core/widgets/appbar_custom.dart';
import '../controller/category_controller.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CategoryController>().getCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(title: 'الفئات'),
      body: Consumer<CategoryController>(
        builder: (context, provider, child) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              /// 🔹 Header
              const SliverToBoxAdapter(child: _Header()),

              /// 🔹 Content
              if (provider.categories.status == Status.COMPLETED)
                _CategoriesGrid(data: provider.categories.data ?? const [])
              else if (provider.categories.status == Status.ERROR)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      provider.categories.message ?? 'حدث خطأ ما',
                      style: context.h1.copyWith(color: Colors.red),
                    ),
                  ),
                )
              else
                const _CategoriesSkeleton(),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('اختر الفئة المناسبة', style: context.h1.copyWith(fontSize: 20)),
          const SizedBox(height: 6),
          Text(
            'تصفح الأجهزة حسب الفئات بسهولة',
            style: context.b1.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _CategoriesGrid extends StatelessWidget {
  final List<dynamic> data;

  const _CategoriesGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final category = data[index];

          return GestureDetector(
            onTap: () {
              NavigationManager.pushNamed(
                RouteName.devicesView,
                arguments: category,
              );
            },
            child: _CategoryCard(category: category),
          );
        }, childCount: data.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final dynamic category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            /// 🖼 Image
            Positioned.fill(
              child: NetworkCustomImageWidget(
                imageUrl: category.image,
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),

            /// 🌑 Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  ),
                ),
              ),
            ),

            /// 🏷 Title
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Text(
                category.name,
                style: context.h1.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesSkeleton extends StatelessWidget {
  const _CategoriesSkeleton();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey,
              ),
            ),
          );
        }, childCount: 4),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
      ),
    );
  }
}
