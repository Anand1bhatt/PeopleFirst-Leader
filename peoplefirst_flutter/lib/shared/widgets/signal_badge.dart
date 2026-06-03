import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/decision.dart';

class SignalBadge extends StatelessWidget {
  final SignalTone tone;
  final bool compact;

  const SignalBadge({
    super.key,
    required this.tone,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _label,
            style: TextStyle(
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }

  Color get _bgColor {
    switch (tone) {
      case SignalTone.healthy:
        return AppColors.positiveLight;
      case SignalTone.risk:
        return AppColors.warningLight;
      case SignalTone.off:
        return AppColors.negativeLight;
      case SignalTone.info:
        return AppColors.skyLight;
    }
  }

  Color get _dotColor {
    switch (tone) {
      case SignalTone.healthy:
        return AppColors.positive;
      case SignalTone.risk:
        return AppColors.warning;
      case SignalTone.off:
        return AppColors.negative;
      case SignalTone.info:
        return AppColors.skyBase;
    }
  }

  Color get _textColor {
    switch (tone) {
      case SignalTone.healthy:
        return AppColors.positive;
      case SignalTone.risk:
        return AppColors.warning;
      case SignalTone.off:
        return AppColors.negative;
      case SignalTone.info:
        return AppColors.skyInk;
    }
  }

  String get _label {
    switch (tone) {
      case SignalTone.healthy:
        return 'Healthy';
      case SignalTone.risk:
        return 'At risk';
      case SignalTone.off:
        return 'Off track';
      case SignalTone.info:
        return 'Info';
    }
  }
}

Color signalDotColor(SignalTone tone) {
  switch (tone) {
    case SignalTone.healthy:
      return AppColors.positive;
    case SignalTone.risk:
      return AppColors.warning;
    case SignalTone.off:
      return AppColors.negative;
    case SignalTone.info:
      return AppColors.skyBase;
  }
}

Color signalStripeColor(SignalTone tone) {
  switch (tone) {
    case SignalTone.healthy:
      return Colors.transparent;
    case SignalTone.risk:
      return AppColors.warning;
    case SignalTone.off:
      return AppColors.negative;
    case SignalTone.info:
      return AppColors.skyBase;
  }
}
