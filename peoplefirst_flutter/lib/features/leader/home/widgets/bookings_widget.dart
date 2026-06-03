import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/booking.dart';
import '../../../../providers/leader/decisions_provider.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/pf_card.dart';

class BookingsWidget extends ConsumerWidget {
  const BookingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(leaderBookingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Today\'s Schedule'),
        const SizedBox(height: 10),
        asyncData.when(
          loading: () => Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surfaceModerate,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (bookings) => PfCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: List.generate(bookings.length, (i) {
                final booking = bookings[i];
                return Column(
                  children: [
                    _BookingRow(booking: booking),
                    if (i < bookings.length - 1)
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class _BookingRow extends StatelessWidget {
  final Booking booking;

  const _BookingRow({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Time column
          SizedBox(
            width: 44,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  booking.timeLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.contentHeavy,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  booking.dateLabel,
                  style: AppTextStyles.captionMinimal.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          // Color stripe
          Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              color: _typeColor(booking.type),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        booking.title,
                        style: AppTextStyles.body.copyWith(fontSize: 13),
                      ),
                    ),
                    if (booking.isPresenter)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.reliance50,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'You present',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.relianceBase,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitle(booking),
                  style: AppTextStyles.captionMinimal,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            booking.timeAway,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.contentMinimal,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _subtitle(Booking b) {
    final parts = <String>[];
    if (b.attendees != null) parts.add('${b.attendees} attendees');
    if (b.durationMinutes > 0) {
      final h = b.durationMinutes ~/ 60;
      final m = b.durationMinutes % 60;
      if (h > 0 && m > 0) {
        parts.add('${h}h ${m}m');
      } else if (h > 0) {
        parts.add('${h}h');
      } else {
        parts.add('${m}m');
      }
    }
    return parts.join(' · ');
  }

  Color _typeColor(BookingType type) {
    switch (type) {
      case BookingType.meeting:
        return AppColors.relianceBase;
      case BookingType.oneOnOne:
        return AppColors.skyBase;
      case BookingType.gym:
        return AppColors.positive;
      case BookingType.teamMeet:
        return AppColors.warning;
      case BookingType.conference:
        return AppColors.relianceBase;
    }
  }
}
