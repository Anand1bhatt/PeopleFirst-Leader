import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/pf_card.dart';
import '../../../shared/widgets/pf_button.dart';
import '../../../providers/toast_provider.dart';

class LeaveScreen extends ConsumerWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surfaceSubtle,
      appBar: AppBar(
        title: const Text(
          'Leave',
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
          // Balance summary
          PfCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LEAVE BALANCE',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.contentModerate,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _BalanceCell(
                      label: 'Annual',
                      total: 21,
                      used: 8,
                      color: AppColors.relianceBase,
                    ),
                    _vDivider(),
                    _BalanceCell(
                      label: 'Sick',
                      total: 12,
                      used: 2,
                      color: AppColors.positive,
                    ),
                    _vDivider(),
                    _BalanceCell(
                      label: 'Casual',
                      total: 7,
                      used: 5,
                      color: AppColors.warning,
                    ),
                    _vDivider(),
                    _BalanceCell(
                      label: 'Comp-off',
                      total: 3,
                      used: 0,
                      color: AppColors.skyBase,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          PfButton(
            label: 'Apply for Leave',
            onPressed: () {
              ref.read(toastProvider.notifier).show('Leave application submitted');
            },
            variant: PfButtonVariant.primary,
            fullWidth: true,
          ),

          const SizedBox(height: 20),

          Text('RECENT APPLICATIONS', style: AppTextStyles.sectionHeader),
          const SizedBox(height: 10),

          PfCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _LeaveRow(
                  type: 'Annual Leave',
                  dates: 'May 12–14',
                  days: '3 days',
                  status: 'Approved',
                  statusColor: AppColors.positive,
                ),
                const Divider(height: 1),
                _LeaveRow(
                  type: 'Sick Leave',
                  dates: 'Apr 28',
                  days: '1 day',
                  status: 'Approved',
                  statusColor: AppColors.positive,
                ),
                const Divider(height: 1),
                _LeaveRow(
                  type: 'Casual Leave',
                  dates: 'Apr 5–6',
                  days: '2 days',
                  status: 'Approved',
                  statusColor: AppColors.positive,
                ),
                const Divider(height: 1),
                _LeaveRow(
                  type: 'Annual Leave',
                  dates: 'Jun 17–20',
                  days: '4 days',
                  status: 'Pending',
                  statusColor: AppColors.warning,
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
        width: 1,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: AppColors.strokeMinimal,
      );
}

class _BalanceCell extends StatelessWidget {
  final String label;
  final int total;
  final int used;
  final Color color;

  const _BalanceCell({
    required this.label,
    required this.total,
    required this.used,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '${total - used}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            label,
            style: AppTextStyles.captionMinimal.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
          ),
          Text(
            'of $total',
            style: AppTextStyles.captionMinimal.copyWith(fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class _LeaveRow extends StatelessWidget {
  final String type;
  final String dates;
  final String days;
  final String status;
  final Color statusColor;

  const _LeaveRow({
    required this.type,
    required this.dates,
    required this.days,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: AppTextStyles.body.copyWith(fontSize: 13)),
                Text(
                  '$dates · $days',
                  style: AppTextStyles.captionMinimal,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
