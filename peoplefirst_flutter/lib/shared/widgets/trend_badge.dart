import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class TrendBadge extends StatelessWidget {
  final double value;
  final String suffix;

  const TrendBadge({
    super.key,
    required this.value,
    this.suffix = 'pts',
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    final color = isPositive ? AppColors.positive : AppColors.negative;
    final bgColor = isPositive ? AppColors.positiveLight : AppColors.negativeLight;
    final icon = isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded;
    final sign = isPositive ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 2),
          Text(
            '$sign${value.toStringAsFixed(0)} $suffix',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
