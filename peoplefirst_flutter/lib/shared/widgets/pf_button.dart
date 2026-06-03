import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum PfButtonVariant { primary, secondary, skyPrimary, skyGhost }

class PfButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final PfButtonVariant variant;
  final String? icon;
  final bool fullWidth;
  final bool compact;

  const PfButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PfButtonVariant.primary,
    this.icon,
    this.fullWidth = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final height = compact ? 32.0 : 40.0;
    final fontSize = compact ? 12.0 : 13.0;
    final hPad = compact ? 12.0 : 16.0;

    Widget button;
    switch (variant) {
      case PfButtonVariant.primary:
        button = ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.relianceBase,
            foregroundColor: Colors.white,
            minimumSize: Size(fullWidth ? double.infinity : 0, height),
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            elevation: 0,
          ),
          child: _buildLabel(Colors.white, fontSize),
        );
        break;
      case PfButtonVariant.secondary:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.contentHeavy,
            minimumSize: Size(fullWidth ? double.infinity : 0, height),
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            side: const BorderSide(color: AppColors.strokeHeavy),
          ),
          child: _buildLabel(AppColors.contentHeavy, fontSize),
        );
        break;
      case PfButtonVariant.skyPrimary:
        button = ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.skyBase,
            foregroundColor: Colors.white,
            minimumSize: Size(fullWidth ? double.infinity : 0, height),
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            elevation: 0,
          ),
          child: _buildLabel(Colors.white, fontSize),
        );
        break;
      case PfButtonVariant.skyGhost:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.skyBase,
            minimumSize: Size(fullWidth ? double.infinity : 0, height),
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            side: const BorderSide(color: AppColors.skyBorder),
          ),
          child: _buildLabel(AppColors.skyBase, fontSize),
        );
        break;
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildLabel(Color color, double fontSize) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      );
    }
    return Text(
      label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
