import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medical_devices_app/core/widgets/netwrok_image_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/router/router.dart';
import '../../../core/router/routers_name.dart';
import '../../../core/services/remote_services/base_model.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/extentions.dart';
import '../../../core/widgets/loading_widget.dart';
import '../controller/home_controller.dart';
import '../model/device_model.dart';

class DevicesSearchDelegate extends SearchDelegate {
  DevicesSearchDelegate()
    : super(
        searchFieldLabel: 'ابحث عن جهاز طبي...',
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
      );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'AvenirArabic',
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: theme.colorScheme.surface,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.48),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'AvenirArabic',
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.45)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.45)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: ColorManager.teal, width: 1.2),
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.isEmpty) return [];
    return [
      IconButton(
        tooltip: 'مسح',
        onPressed: () => query = '',
        icon: Icon(
          Icons.close_rounded,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'رجوع',
      onPressed: () => close(context, null),
      icon: Icon(
        Icons.arrow_back_rounded,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _SearchContent(query: query);

  @override
  Widget buildSuggestions(BuildContext context) {
    return _SearchContent(
      query: query,
      onSuggestionTap: (value) {
        query = value;
        showResults(context);
      },
    );
  }
}

class _SearchContent extends StatefulWidget {
  const _SearchContent({required this.query, this.onSuggestionTap});

  final String query;
  final ValueChanged<String>? onSuggestionTap;

  @override
  State<_SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends State<_SearchContent> {
  Timer? _debounce;
  late String _visibleQuery = widget.query;

  @override
  void didUpdateWidget(covariant _SearchContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query == widget.query) return;

    _debounce?.cancel();
    if (widget.query.trim().isEmpty) {
      setState(() => _visibleQuery = widget.query);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 220), () {
      if (mounted) setState(() => _visibleQuery = widget.query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ColoredBox(
        color: theme.scaffoldBackgroundColor,
        child: Consumer<HomeController>(
          builder: (context, homeProvider, child) {
            if (homeProvider.devices.status == Status.LOADING ||
                homeProvider.devices.status == Status.INIT) {
              return loading();
            }

            if (homeProvider.devices.status == Status.ERROR) {
              return Center(
                child: Text(
                  homeProvider.devices.message ?? 'حدث خطأ في البحث',
                  style: context.b1.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              );
            }

            final allDevices = homeProvider.devices.data ?? [];
            final devices = _filterDevices(allDevices, _visibleQuery);
            final isSearching = _visibleQuery.trim().isNotEmpty;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                isSearching ? 'نتائج البحث' : 'اقتراحات سريعة',
                                style: context.h1.copyWith(
                                  fontSize: 18,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (isSearching)
                              Text(
                                '${devices.length} نتيجة',
                                style: context.b1.copyWith(
                                  fontSize: 13,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.58),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        if (!isSearching) ...[
                          _QuickSuggestions(
                            devices: allDevices,
                            onTap: widget.onSuggestionTap,
                          ),
                          const SizedBox(height: 18),
                        ],
                      ],
                    ),
                  ),
                ),
                if (devices.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptySearchState(isSearching: isSearching),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _SearchResultCard(device: devices[index]),
                        childCount: devices.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<DeviceModel> _filterDevices(List<DeviceModel> devices, String query) {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return devices;

    return devices
        .where((device) {
          final name = device.name.toLowerCase();
          final details = device.details.toLowerCase();
          return name.contains(term) || details.contains(term);
        })
        .toList(growable: false);
  }
}

class _QuickSuggestions extends StatelessWidget {
  const _QuickSuggestions({required this.devices, this.onTap});

  final List<DeviceModel> devices;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggestions = devices.take(6).toList();
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اقتراحات سريعة',
          style: context.b1.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface.withOpacity(0.72),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions.map((device) {
            return InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => onTap?.call(device.name),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.45),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 15,
                      color: ColorManager.teal,
                    ),
                    const SizedBox(width: 6),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: Text(
                        device.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.b1.copyWith(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState({required this.isSearching});

  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 56),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withOpacity(0.45)),
      ),
      child: Column(
        children: [
          Icon(
            isSearching
                ? Icons.search_off_rounded
                : Icons.manage_search_rounded,
            size: 44,
            color: ColorManager.teal,
          ),
          const SizedBox(height: 12),
          Text(
            isSearching ? 'لا يوجد جهاز بهذا الاسم' : 'ابدأ بكتابة اسم الجهاز',
            textAlign: TextAlign.center,
            style: context.h1.copyWith(fontSize: 17),
          ),
          const SizedBox(height: 6),
          Text(
            'جرّب البحث بكلمة أقصر أو بجزء من اسم المنتج.',
            textAlign: TextAlign.center,
            style: context.b1.copyWith(
              fontSize: 13,
              color: theme.colorScheme.onSurface.withOpacity(0.58),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.device});

  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          NavigationManager.pushNamed(
            RouteName.devicesDetailsView,
            arguments: device,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: theme.dividerColor.withOpacity(0.45)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: NetworkCustomImageWidget(
                  height: 122,
                  imageUrl: device.image,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.b1.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: ColorManager.gold,
                            size: 15,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '4.8',
                            style: context.b1.copyWith(
                              fontSize: 11,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.58,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '\$${device.price}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.h1.copyWith(
                          color: ColorManager.teal,
                          fontSize: 15,
                        ),
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
