import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class PfCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool elevated;
  final Color? color;

  const PfCard({
    super.key,
    required this.child,
    this.padding,
    this.elevated = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.surfaceMinimal,
        borderRadius: BorderRadius.circular(16),
        boxShadow: elevated
            ? const [
                BoxShadow(
                  color: Color(0x0A0F172A),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
        border: elevated
            ? null
            : Border.all(color: AppColors.strokeMinimal, width: 1),
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
  }
}
