import 'package:flutter/material.dart';
import 'package:medical_devices_app/core/widgets/netwrok_image_widget.dart';
import 'package:medical_devices_app/modules/order/controller/order_controller.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/extentions.dart';
import '../../../core/widgets/appbar_custom.dart';
import '../model/order_model.dart';

class _OrderStatusTimeline extends StatelessWidget {
  const _OrderStatusTimeline({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final steps = const [
      _StatusStep('تم الطلب', Icons.receipt_long_outlined),
      _StatusStep('قيد التجهيز', Icons.inventory_2_outlined),
      _StatusStep('خرج للتوصيل', Icons.local_shipping_outlined),
      _StatusStep('تم التسليم', Icons.verified_outlined),
    ];
    final activeIndex = status == 'completed' ? 3 : 1;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.42),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تتبع الطلب',
              style: context.h1.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(steps.length, (index) {
                final isActive = index <= activeIndex;
                final step = steps[index];
                return Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          if (index != 0)
                            Expanded(
                              child: Container(
                                height: 2,
                                color: isActive
                                    ? ColorManager.teal
                                    : Theme.of(context).dividerColor,
                              ),
                            ),
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? ColorManager.teal
                                  : Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              step.icon,
                              color: isActive
                                  ? Colors.white
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.5),
                              size: 18,
                            ),
                          ),
                          if (index != steps.length - 1)
                            Expanded(
                              child: Container(
                                height: 2,
                                color: index < activeIndex
                                    ? ColorManager.teal
                                    : Theme.of(context).dividerColor,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        step.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.b1.copyWith(
                          fontSize: 11,
                          color: isActive
                              ? ColorManager.teal
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.58),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusStep {
  const _StatusStep(this.label, this.icon);

  final String label;
  final IconData icon;
}

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(title: 'تفاصيل الطلب'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.surface,
                            Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withOpacity(0.32),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'المنتجات',
                            style: context.h1.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          if (order.devices.isEmpty)
                            const Text('لا يوجد منتجات')
                          else
                            Column(
                              children: order.devices.map((device) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      // Image
                                      Container(
                                        height: 70,
                                        width: 70,
                                        margin: const EdgeInsets.only(left: 12),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surfaceContainerHighest,
                                        ),
                                        child: NetworkCustomImageWidget(
                                          imageUrl: device.deviceModel.image,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                      // Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${device.deviceModel.name} ${device.count}x",
                                              style: context.h1.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              '\$${device.deviceModel.price}',
                                              style: context.b1.copyWith(
                                                color: ColorManager.teal,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _OrderStatusTimeline(status: order.status),
                  const SizedBox(height: 20),

                  // Order Information Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.surface,
                            Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withOpacity(0.32),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'معلومات الطلب',
                            style: context.h1.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Order ID
                          _buildInfoRow(
                            context,
                            icon: Icons.receipt,
                            label: 'رقم الطلب',
                            value: order.orderId,
                          ),
                          const SizedBox(height: 12),

                          // Status
                          _buildInfoRow(
                            context,
                            icon: Icons.info_outline,
                            label: 'الحالة',
                            value: order.status == 'pending'
                                ? 'قيد التنفيذ'
                                : 'تم الاستلام',
                            statusColor: order.status == 'pending'
                                ? Colors.orange.shade700
                                : Colors.green.shade700,
                          ),
                          const SizedBox(height: 12),

                          // Phone
                          _buildInfoRow(
                            context,
                            icon: Icons.phone_outlined,
                            label: 'رقم الجوال',
                            value: order.phone,
                          ),
                          const SizedBox(height: 12),

                          // Address
                          _buildInfoRow(
                            context,
                            icon: Icons.location_on_outlined,
                            label: 'العنوان',
                            value: order.address,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Summary Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          colors: [
                            ColorManager.blue.withOpacity(0.05),
                            Theme.of(context).colorScheme.surface,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الملخص',
                            style: context.h1.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Price Row
                          ...order.devices.map(
                            (value) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${value.deviceModel.name} ${value.count}x",
                                  style: context.b1.copyWith(
                                    fontSize: 16,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.68),
                                  ),
                                ),
                                Text(
                                  '\$${value.deviceModel.price}',
                                  style: context.b1.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Divider
                          Container(
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                          const SizedBox(height: 12),

                          // Total
                          // Total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الإجمالي',
                                style: context.h1.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorManager.teal.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '\$${order.devices.fold(0, (sum, device) => sum + (device.deviceModel.priceValue * device.count)).toStringAsFixed(2)}',
                                  style: context.h1.copyWith(
                                    color: ColorManager.teal,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          Visibility(
            visible: order.status == 'pending',
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 30,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  context.read<OrderController>().cancelOrder(order.orderId);
                },
                child: Text(
                  'الغاء الطلب',
                  style: context.b1.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? statusColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ColorManager.teal.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: ColorManager.teal, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.b1.copyWith(
                  fontSize: 13,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.62),
                ),
              ),
              const SizedBox(height: 4),
              if (statusColor != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    value,
                    style: context.b1.copyWith(
                      fontSize: 14,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Text(
                  value,
                  style: context.b1.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
