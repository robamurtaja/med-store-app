import 'package:flutter/material.dart';
import '../../../../core/services/local_services/shared_perf.dart';
import '../../../../core/utils/extentions.dart';

import '../../../../core/utils/color_manager.dart';

class PersonalCardInfo extends StatefulWidget {
  const PersonalCardInfo({super.key});

  @override
  State<PersonalCardInfo> createState() => _PersonalCardInfoState();
}

class _PersonalCardInfoState extends State<PersonalCardInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              ColorManager.blue.withOpacity(0.14),
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.blue.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.blue.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                size: 30,
                color: ColorManager.blue,
              ),
            ),
            const SizedBox(width: 16),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    SharedPrefController().getUser().name,
                    style: context.h1.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    SharedPrefController().getUser().email,
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
          ],
        ),
      ),
    );
  }
}
