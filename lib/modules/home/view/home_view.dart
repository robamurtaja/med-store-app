import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medical_devices_app/core/utils/color_manager.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/extentions.dart';
import '../../../core/widgets/animated_entry.dart';
import '../../../core/widgets/appbar_custom.dart';
import '../../category/controller/category_controller.dart';
import '../../order/controller/order_controller.dart';
import '../controller/home_controller.dart';
import 'category_section.dart';
import 'last_added_section.dart';
import 'most_ordered_section.dart';
import 'search_delegate_devices.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _promoController = PageController(
    viewportFraction: 0.92,
  );
  Timer? _promoTimer;
  int _promoIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HomeController>().getDevices();
      context.read<CategoryController>().getCategory();
      context.read<HomeController>().getLastAddedDevices();
      context.read<HomeController>().getMostOrderedDevices();
      context.read<OrderController>().getCartDevices();
      _startPromoAnimation();
    });
  }

  void _startPromoAnimation() {
    _promoTimer?.cancel();
    _promoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_promoController.hasClients) return;
      final nextIndex = (_promoIndex + 1) % _promos.length;
      _promoController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(title: 'الرئيسية', showCart: true),
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          context.read<CategoryController>().getCategory(),
          context.read<HomeController>().getLastAddedDevices(),
          context.read<HomeController>().getMostOrderedDevices(),
        ]),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            const SizedBox(height: 10),
            AnimatedEntry(
              child: _PromoCarousel(
                controller: _promoController,
                activeIndex: _promoIndex,
                onChanged: (index) => setState(() => _promoIndex = index),
              ),
            ),
            const SizedBox(height: 14),
            const _SmartSearchBar(),
            const SizedBox(height: 26),
            const _SectionTitle(
              title: 'الفئات',
              subtitle: 'اختصر وصولك للجهاز المناسب',
            ),
            const SizedBox(height: 14),
            const CategorySection(),
            const SizedBox(height: 28),
            const _SectionTitle(
              title: 'الأكثر طلباً',
              subtitle: 'منتجات يثق بها العملاء',
            ),
            const SizedBox(height: 12),
            const MostOrderedSection(),
            const SizedBox(height: 28),
            const _SectionTitle(
              title: 'المضافة حديثاً',
              subtitle: 'أحدث الأجهزة المتوفرة الآن',
            ),
            const SizedBox(height: 12),
            const LastAddedSection(),
          ],
        ),
      ),
    );
  }
}

class _SmartSearchBar extends StatelessWidget {
  const _SmartSearchBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedEntry(
        delay: const Duration(milliseconds: 90),
        child: Material(
          color: theme.colorScheme.surface,
          elevation: 0,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              showSearch(context: context, delegate: DevicesSearchDelegate());
            },
            child: Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.dividerColor.withOpacity(0.55)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'ابحث عن جهاز طبي...',
                      style: context.b1.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.58),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: theme.colorScheme.primary,
                      size: 19,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.h1.copyWith(
                    fontSize: 21,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: context.b1.copyWith(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withOpacity(0.56),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _PromoCarousel extends StatelessWidget {
  const _PromoCarousel({
    required this.controller,
    required this.activeIndex,
    required this.onChanged,
  });

  final PageController controller;
  final int activeIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: controller,
            itemCount: _promos.length,
            onPageChanged: onChanged,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  double value = 1;
                  if (controller.hasClients &&
                      controller.position.haveDimensions) {
                    value =
                        (1 - ((controller.page ?? index) - index).abs() * 0.08)
                            .clamp(0.92, 1.0);
                  }
                  return Transform.scale(scale: value, child: child);
                },
                child: _PromoCard(promo: _promos[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _promos.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: activeIndex == index ? 24 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: activeIndex == index
                    ? ColorManager.teal
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.22),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.promo});

  final _PromoItem promo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: promo.accent.withOpacity(0.22),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(promo.image, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.78),
                  Colors.black.withOpacity(0.34),
                  Colors.transparent,
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: Colors.white.withOpacity(0.22)),
              ),
              child: Text(
                promo.tag,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  promo.title,
                  style: context.h1.copyWith(
                    color: Colors.white,
                    fontSize: 25,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  promo.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.b1.copyWith(
                    color: Colors.white.withOpacity(0.86),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: promo.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'تسوق الآن',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoItem {
  const _PromoItem({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.image,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String tag;
  final String image;
  final Color accent;
}

const _promos = [
  _PromoItem(
    title: 'خصومات على الأجهزة الأساسية',
    subtitle: 'عروض مختارة على أجهزة القياس والرعاية اليومية.',
    tag: 'خصومات',
    image: 'assets/images/splash_image.png',
    accent: ColorManager.gold,
  ),
  _PromoItem(
    title: 'أجهزة طبية موثوقة للمنزل',
    subtitle: 'كل ما تحتاجه للرعاية والمتابعة في مكان واحد.',
    tag: 'الأجهزة',
    image: 'assets/images/device.jpeg',
    accent: ColorManager.teal,
  ),
  _PromoItem(
    title: 'رعاية أسهل وتجربة أسرع',
    subtitle: 'تصفح، أضف للسلة، وتابع طلباتك بسلاسة.',
    tag: 'رعاية',
    image: 'assets/images/device1.jpeg',
    accent: ColorManager.blue,
  ),
];
