import 'package:flutter/material.dart';

class AnimatedEntry extends StatelessWidget {
  const AnimatedEntry({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.08),
  });

  final Widget child;
  final Duration delay;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 650 + delay.inMilliseconds),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final delayed = (delay.inMilliseconds == 0
                ? value
                : ((value * (650 + delay.inMilliseconds) -
                            delay.inMilliseconds) /
                        650)
                    .clamp(0.0, 1.0))
            .toDouble();
        return Opacity(
          opacity: delayed,
          child: Transform.translate(
            offset: Offset(offset.dx * 80 * (1 - delayed),
                offset.dy * 80 * (1 - delayed)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
