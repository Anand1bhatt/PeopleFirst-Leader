import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../providers/leader/decisions_provider.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/pf_card.dart';

class ActionItemsWidget extends ConsumerWidget {
  const ActionItemsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(approvalSummaryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Action Items',
          action: 'View all',
          onAction: () => context.go('/leader/approvals'),
        ),
        const SizedBox(height: 10),
        summaryAsync.when(
          loading: () => Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.surfaceModerate,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (summary) => PfCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Critical travel alert
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.negativeLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.negative.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.negative,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Rohan Das travelling to Bengaluru tomorrow. Approve ₹38,500 travel request.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.negative,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/leader/approvals'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Review',
                          style: TextStyle(
                            color: AppColors.negative,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Count grid
                Row(
                  children: [
                    _CountCell(
                      label: 'Total',
                      value: summary.total,
                      color: AppColors.relianceBase,
                    ),
                    _divider(),
                    _CountCell(
                      label: 'Low risk',
                      value: summary.lowRisk,
                      color: AppColors.positive,
                    ),
                    _divider(),
                    _CountCell(
                      label: 'Critical',
                      value: summary.criticalCount,
                      color: AppColors.negative,
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),

                // Type breakdown
                Row(
                  children: [
                    _TypePill(
                      label: 'Leave',
                      count: summary.leaveCount,
                    ),
                    const SizedBox(width: 8),
                    _TypePill(
                      label: 'Travel',
                      count: summary.travelCount,
                      hasAlert: true,
                    ),
                    const SizedBox(width: 8),
                    _TypePill(
                      label: 'Expense',
                      count: summary.expenseCount,
                    ),
                    const SizedBox(width: 8),
                    _TypePill(
                      label: 'Sign-offs',
                      count: summary.signOffCount,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        color: AppColors.strokeMinimal,
      );
}

class _CountCell extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _CountCell({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(label, style: AppTextStyles.captionMinimal),
        ],
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  final String label;
  final int count;
  final bool hasAlert;

  const _TypePill({
    required this.label,
    required this.count,
    this.hasAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: hasAlert ? AppColors.negativeLight : AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label $count${hasAlert ? ' ⚠' : ''}',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: hasAlert ? AppColors.negative : AppColors.contentModerate,
        ),
      ),
    );
  }
}
