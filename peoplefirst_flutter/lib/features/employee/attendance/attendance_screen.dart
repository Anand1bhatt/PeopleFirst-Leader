import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/attendance.dart';
import '../../../providers/employee/attendance_provider.dart';
import '../../../providers/toast_provider.dart';
import '../../../shared/widgets/pf_card.dart';
import '../../../shared/widgets/pf_button.dart';
import '../../../core/utils/formatters.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(attendanceProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceSubtle,
      appBar: AppBar(
        title: const Text(
          'Attendance',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.contentHeavy,
          ),
        ),
        backgroundColor: AppColors.surfaceMinimal,
        elevation: 0,
      ),
      body: attendanceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (record) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Today card
            PfCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.contentHeavy,
                        ),
                      ),
                      const Spacer(),
                      _StatusChip(status: record.status),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _TimeCol(
                        label: 'Mark In',
                        value: record.markedIn != null
                            ? Formatters.timeOfDay(record.markedIn!)
                            : '--',
                        color: AppColors.positive,
                      ),
                      Container(
                        width: 1,
                        height: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: AppColors.strokeMinimal,
                      ),
                      _TimeCol(
                        label: 'Mark Out',
                        value: record.markedOut != null
                            ? Formatters.timeOfDay(record.markedOut!)
                            : record.status == AttendanceStatus.in_
                                ? 'Active'
                                : '--',
                        color: record.status == AttendanceStatus.in_
                            ? AppColors.warning
                            : AppColors.negative,
                      ),
                      Container(
                        width: 1,
                        height: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: AppColors.strokeMinimal,
                      ),
                      _TimeCol(
                        label: 'Duration',
                        value: record.duration == Duration.zero
                            ? '--'
                            : Formatters.duration(record.duration),
                        color: AppColors.relianceBase,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (record.status == AttendanceStatus.out)
                    PfButton(
                      label: 'Mark In',
                      onPressed: () {
                        ref.read(attendanceProvider.notifier).markIn();
                        ref.read(toastProvider.notifier).show(
                              'Marked in at ${Formatters.timeOfDay(DateTime.now())}',
                            );
                      },
                      variant: PfButtonVariant.primary,
                      fullWidth: true,
                    )
                  else if (record.status == AttendanceStatus.in_)
                    PfButton(
                      label: 'Mark Out',
                      onPressed: () {
                        ref.read(attendanceProvider.notifier).markOut();
                        ref.read(toastProvider.notifier).show(
                              'Marked out at ${Formatters.timeOfDay(DateTime.now())}',
                            );
                      },
                      variant: PfButtonVariant.secondary,
                      fullWidth: true,
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.positiveLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.positive,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Attendance logged for today',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.positive,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text('THIS WEEK', style: AppTextStyles.sectionHeader),
            const SizedBox(height: 10),

            PfCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _HistoryRow(
                    day: 'Monday',
                    date: 'Jun 2',
                    inTime: '9:28 AM',
                    outTime: '6:02 PM',
                    duration: '8h 34m',
                    status: AttendanceStatus.done,
                  ),
                  const Divider(height: 1),
                  _HistoryRow(
                    day: 'Tuesday',
                    date: 'Jun 3',
                    inTime: '9:30 AM',
                    outTime: '5:45 PM',
                    duration: '8h 15m',
                    status: AttendanceStatus.done,
                  ),
                  const Divider(height: 1),
                  _HistoryRow(
                    day: 'Wednesday',
                    date: 'Jun 4',
                    inTime: '--',
                    outTime: '--',
                    duration: '--',
                    status: AttendanceStatus.out,
                    isToday: false,
                    isFuture: true,
                  ),
                  const Divider(height: 1),
                  _HistoryRow(
                    day: 'Thursday',
                    date: 'Jun 5',
                    inTime: '--',
                    outTime: '--',
                    duration: '--',
                    status: AttendanceStatus.out,
                    isFuture: true,
                  ),
                  const Divider(height: 1),
                  _HistoryRow(
                    day: 'Friday',
                    date: 'Jun 6',
                    inTime: '--',
                    outTime: '--',
                    duration: '--',
                    status: AttendanceStatus.out,
                    isFuture: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _TimeCol extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TimeCol({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: AppTextStyles.captionMinimal),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final AttendanceStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    Color bg;

    switch (status) {
      case AttendanceStatus.done:
        label = 'Done';
        color = AppColors.positive;
        bg = AppColors.positiveLight;
        break;
      case AttendanceStatus.in_:
        label = 'Clocked in';
        color = AppColors.warning;
        bg = AppColors.warningLight;
        break;
      case AttendanceStatus.out:
        label = 'Not in';
        color = AppColors.contentModerate;
        bg = AppColors.surfaceModerate;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final String day;
  final String date;
  final String inTime;
  final String outTime;
  final String duration;
  final AttendanceStatus status;
  final bool isToday;
  final bool isFuture;

  const _HistoryRow({
    required this.day,
    required this.date,
    required this.inTime,
    required this.outTime,
    required this.duration,
    required this.status,
    this.isToday = false,
    this.isFuture = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isFuture
                        ? AppColors.contentMinimal
                        : AppColors.contentHeavy,
                  ),
                ),
                Text(date, style: AppTextStyles.captionMinimal),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TimeVal(label: 'In', value: inTime, faded: isFuture),
                _TimeVal(label: 'Out', value: outTime, faded: isFuture),
                _TimeVal(label: 'Hrs', value: duration, faded: isFuture),
              ],
            ),
          ),
          if (!isFuture)
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.positive,
              size: 16,
            ),
        ],
      ),
    );
  }
}

class _TimeVal extends StatelessWidget {
  final String label;
  final String value;
  final bool faded;

  const _TimeVal({
    required this.label,
    required this.value,
    this.faded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.captionMinimal.copyWith(fontSize: 10),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: faded ? AppColors.contentMinimal : AppColors.contentHeavy,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
