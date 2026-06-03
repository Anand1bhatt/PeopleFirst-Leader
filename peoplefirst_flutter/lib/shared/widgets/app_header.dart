import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AppHeader extends StatelessWidget {
  final String name;
  final String initials;
  final VoidCallback onSearch;
  final VoidCallback onBell;
  final VoidCallback onProfile;
  final int badgeCount;

  const AppHeader({
    super.key,
    required this.name,
    required this.initials,
    required this.onSearch,
    required this.onBell,
    required this.onProfile,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceMinimal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good morning,', style: AppTextStyles.greeting),
                Text(name, style: AppTextStyles.subGreeting),
              ],
            ),
          ),
          _IconBtn(
            icon: Icons.search_rounded,
            onTap: onSearch,
          ),
          const SizedBox(width: 4),
          _BellBtn(
            onTap: onBell,
            badgeCount: badgeCount,
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onProfile,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.relianceBase,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(icon, size: 22, color: AppColors.contentHeavy),
      ),
    );
  }
}

class _BellBtn extends StatelessWidget {
  final VoidCallback onTap;
  final int badgeCount;

  const _BellBtn({required this.onTap, required this.badgeCount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.notifications_outlined,
              size: 22,
              color: AppColors.contentHeavy,
            ),
            if (badgeCount > 0)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.badgeRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
