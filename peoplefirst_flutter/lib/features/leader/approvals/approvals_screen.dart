import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/approval.dart';
import '../../../providers/leader/approvals_provider.dart';
import '../../../providers/toast_provider.dart';
import '../../../shared/widgets/pf_card.dart';
import '../../../shared/widgets/pf_button.dart';
import '../../../shared/widgets/signal_badge.dart';

class ApprovalsScreen extends ConsumerWidget {
  const ApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final approvalsAsync = ref.watch(approvalsListProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceSubtle,
      appBar: AppBar(
        title: const Text(
          'Approvals',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.contentHeavy,
          ),
        ),
        backgroundColor: AppColors.surfaceMinimal,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              final notifier = ref.read(approvalsListProvider.notifier);
              approvalsAsync.whenData((list) {
                for (final a in list) {
                  if (a.isLowRisk && a.status == ApprovalStatus.pending) {
                    notifier.approve(a.id);
                  }
                }
                ref.read(toastProvider.notifier).show(
                      '14 low-risk approvals bulk approved',
                    );
              });
            },
            icon: const Icon(
              Icons.done_all_rounded,
              size: 16,
              color: AppColors.relianceBase,
            ),
            label: const Text(
              'Bulk approve',
              style: TextStyle(
                color: AppColors.relianceBase,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      body: approvalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (approvals) {
          final critical =
              approvals.where((a) => a.isCritical).toList();
          final pending =
              approvals.where((a) => !a.isCritical && a.status == ApprovalStatus.pending).toList();
          final done = approvals
              .where((a) => a.status != ApprovalStatus.pending)
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (critical.isNotEmpty) ...[
                Text(
                  'CRITICAL',
                  style: AppTextStyles.sectionHeader
                      .copyWith(color: AppColors.negative),
                ),
                const SizedBox(height: 8),
                ...critical.map((a) => _ApprovalCard(approval: a)),
                const SizedBox(height: 16),
              ],
              if (pending.isNotEmpty) ...[
                Text('PENDING', style: AppTextStyles.sectionHeader),
                const SizedBox(height: 8),
                ...pending.map((a) => _ApprovalCard(approval: a)),
                const SizedBox(height: 16),
              ],
              if (done.isNotEmpty) ...[
                Text('ACTIONED', style: AppTextStyles.sectionHeader),
                const SizedBox(height: 8),
                ...done.map((a) => _ApprovalCard(approval: a)),
              ],
              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }
}

class _ApprovalCard extends ConsumerWidget {
  final Approval approval;

  const _ApprovalCard({required this.approval});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDone = approval.status != ApprovalStatus.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: PfCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _TypeIcon(type: approval.type),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              approval.requesterName,
                              style: AppTextStyles.body.copyWith(fontSize: 13),
                            ),
                          ),
                          if (approval.isCritical)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.negativeLight,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'Critical',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.negative,
                                ),
                              ),
                            ),
                          if (isDone)
                            Icon(
                              approval.status == ApprovalStatus.approved
                                  ? Icons.check_circle_rounded
                                  : Icons.cancel_rounded,
                              size: 18,
                              color: approval.status ==
                                      ApprovalStatus.approved
                                  ? AppColors.positive
                                  : AppColors.negative,
                            ),
                        ],
                      ),
                      Text(
                        approval.requesterRole,
                        style: AppTextStyles.captionMinimal,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              approval.description,
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 12,
                  color: AppColors.contentMinimal,
                ),
                const SizedBox(width: 4),
                Text(
                  approval.dateLabel,
                  style: AppTextStyles.captionMinimal,
                ),
              ],
            ),
            if (!isDone) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: PfButton(
                      label: 'Approve',
                      onPressed: () {
                        ref
                            .read(approvalsListProvider.notifier)
                            .approve(approval.id);
                        ref
                            .read(toastProvider.notifier)
                            .show('Approved ${approval.requesterName}\'s request');
                      },
                      variant: PfButtonVariant.primary,
                      compact: true,
                      fullWidth: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PfButton(
                      label: 'Reject',
                      onPressed: () {
                        ref
                            .read(approvalsListProvider.notifier)
                            .reject(approval.id);
                        ref
                            .read(toastProvider.notifier)
                            .show('Rejected ${approval.requesterName}\'s request');
                      },
                      variant: PfButtonVariant.secondary,
                      compact: true,
                      fullWidth: true,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  final ApprovalType type;

  const _TypeIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (type) {
      case ApprovalType.leave:
        icon = Icons.beach_access_rounded;
        color = AppColors.skyBase;
        break;
      case ApprovalType.travel:
        icon = Icons.flight_rounded;
        color = AppColors.warning;
        break;
      case ApprovalType.expense:
        icon = Icons.receipt_long_rounded;
        color = AppColors.positive;
        break;
      case ApprovalType.signOff:
        icon = Icons.draw_rounded;
        color = AppColors.relianceBase;
        break;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 18, color: color),
    );
  }
}
