import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/persona.dart';
import '../../providers/persona_provider.dart';
import '../../shared/widgets/pf_card.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final persona = ref.watch(personaProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceSubtle,
      appBar: AppBar(
        title: const Text(
          'More',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.contentHeavy,
          ),
        ),
        backgroundColor: AppColors.surfaceMinimal,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile card
          PfCard(
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: AppColors.relianceBase,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    persona.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(persona.name, style: AppTextStyles.body),
                      const SizedBox(height: 2),
                      Text(persona.role, style: AppTextStyles.caption),
                      Text(persona.department,
                          style: AppTextStyles.captionMinimal),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.contentMinimal,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Persona switcher
          Text(
            'VIEWING AS',
            style: AppTextStyles.sectionHeader,
          ),
          const SizedBox(height: 10),
          PfCard(
            child: Column(
              children: [
                _PersonaPill(
                  label: 'Leader',
                  subtitle: 'Vikram · VP, Product & Engineering',
                  selected: persona.type == PersonaType.leader,
                  onTap: () {
                    ref
                        .read(personaProvider.notifier)
                        .switchTo(PersonaType.leader);
                    context.go('/');
                  },
                ),
                const Divider(height: 1),
                _PersonaPill(
                  label: 'Employee',
                  subtitle: 'Priya · Senior Product Designer',
                  selected: persona.type == PersonaType.employee,
                  onTap: () {
                    ref
                        .read(personaProvider.notifier)
                        .switchTo(PersonaType.employee);
                    context.go('/');
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text('SETTINGS', style: AppTextStyles.sectionHeader),
          const SizedBox(height: 10),
          PfCard(
            child: Column(
              children: [
                _SettingsRow(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsRow(
                  icon: Icons.lock_outline_rounded,
                  label: 'Privacy',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsRow(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & Support',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsRow(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  onTap: () {},
                  isDestructive: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Center(
            child: Text(
              'PeopleFirst v1.0.0',
              style: AppTextStyles.captionMinimal,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Powered by Reliance Industries',
              style: AppTextStyles.captionMinimal,
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _PersonaPill extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _PersonaPill({
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? AppColors.relianceBase
                      : AppColors.strokeHeavy,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.relianceBase,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? AppColors.relianceBase
                          : AppColors.contentHeavy,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.captionMinimal,
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

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.negative : AppColors.contentHeavy;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            if (!isDestructive)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.contentMinimal,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
