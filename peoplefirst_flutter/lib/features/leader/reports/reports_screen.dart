import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/pf_card.dart';
import '../../../shared/widgets/signal_badge.dart';
import '../../../data/models/decision.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surfaceSubtle,
      appBar: AppBar(
        title: const Text(
          'Reports',
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
          PfCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('QUICK REPORTS', style: AppTextStyles.sectionHeader),
                const SizedBox(height: 12),
                _ReportTile(
                  icon: Icons.bar_chart_rounded,
                  label: 'Q2 Performance Summary',
                  subtitle: 'Team · May 2025',
                  tone: SignalTone.healthy,
                ),
                const Divider(height: 1),
                _ReportTile(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Budget Utilisation',
                  subtitle: 'Q2 · 83% spent',
                  tone: SignalTone.risk,
                ),
                const Divider(height: 1),
                _ReportTile(
                  icon: Icons.people_rounded,
                  label: 'Headcount Report',
                  subtitle: 'As of today · 250 people',
                  tone: SignalTone.healthy,
                ),
                const Divider(height: 1),
                _ReportTile(
                  icon: Icons.task_alt_rounded,
                  label: 'Delivery Metrics',
                  subtitle: 'Sprint 24 · 86% on time',
                  tone: SignalTone.healthy,
                ),
                const Divider(height: 1),
                _ReportTile(
                  icon: Icons.work_rounded,
                  label: 'Recruitment Pipeline',
                  subtitle: '379 CVs · 3 roles open',
                  tone: SignalTone.risk,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PfCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SCHEDULED REPORTS', style: AppTextStyles.sectionHeader),
                const SizedBox(height: 12),
                _ReportTile(
                  icon: Icons.schedule_rounded,
                  label: 'Weekly Pulse',
                  subtitle: 'Every Monday · Auto-generated',
                  tone: SignalTone.info,
                ),
                const Divider(height: 1),
                _ReportTile(
                  icon: Icons.trending_up_rounded,
                  label: 'Monthly Performance',
                  subtitle: '1st of every month',
                  tone: SignalTone.info,
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final SignalTone tone;

  const _ReportTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: AppColors.relianceBase),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.body.copyWith(fontSize: 13)),
                Text(subtitle, style: AppTextStyles.captionMinimal),
              ],
            ),
          ),
          SignalBadge(tone: tone, compact: true),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AppColors.contentMinimal,
          ),
        ],
      ),
    );
  }
}
