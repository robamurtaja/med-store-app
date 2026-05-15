import 'package:flutter/material.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/extentions.dart';

class ProfileCustomListTile extends StatelessWidget {
  const ProfileCustomListTile({
    this.onTap,
    required this.text,
    this.icon = Icons.arrow_forward_ios,
    super.key,
  });
  final void Function()? onTap;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorManager.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: ColorManager.blue, size: 22),
              ),
              const SizedBox(width: 14),
              // Text
              Expanded(
                child: Text(
                  text,
                  style: context.b1.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.42),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
