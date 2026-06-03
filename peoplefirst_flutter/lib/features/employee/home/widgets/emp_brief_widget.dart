import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../providers/employee/tasks_provider.dart';

class EmpBriefWidget extends ConsumerWidget {
  const EmpBriefWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final briefAsync = ref.watch(morningBriefProvider);

    return briefAsync.when(
      loading: () => Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surfaceModerate,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (items) => Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A5C8A), Color(0xFF2F8FD4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Good morning, Priya',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${items.length} things need your attention today',
              style: const TextStyle(
                color: Color(0xCCFFFFFF),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => _BriefItem(item: item)),
          ],
        ),
      ),
    );
  }
}

class _BriefItem extends StatelessWidget {
  final Map<String, String> item;

  const _BriefItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Icon(
              _icon(item['type'] ?? ''),
              size: 13,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  item['detail'] ?? '',
                  style: const TextStyle(
                    color: Color(0xCCFFFFFF),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _icon(String type) {
    switch (type) {
      case 'task':
        return Icons.task_alt_rounded;
      case 'leave':
        return Icons.beach_access_rounded;
      case 'goals':
        return Icons.flag_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }
}
