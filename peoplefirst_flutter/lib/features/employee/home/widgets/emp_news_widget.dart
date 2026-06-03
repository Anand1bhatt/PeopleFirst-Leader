import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/news_item.dart';
import '../../../../providers/employee/tasks_provider.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/pf_card.dart';

class EmpNewsWidget extends ConsumerWidget {
  const EmpNewsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(employeeNewsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Highlights'),
        const SizedBox(height: 10),
        newsAsync.when(
          loading: () => Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.surfaceModerate,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (news) => PfCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: List.generate(news.length, (i) {
                final item = news[i];
                return Column(
                  children: [
                    _EmpNewsRow(item: item),
                    if (i < news.length - 1)
                      const Divider(height: 1, indent: 50, endIndent: 16),
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

class _EmpNewsRow extends StatelessWidget {
  final NewsItem item;

  const _EmpNewsRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _catBg(item.category),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              item.emoji ?? '📣',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.headline,
                  style: AppTextStyles.body.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(item.detail, style: AppTextStyles.captionMinimal),
                if (item.hasAction && item.actionLabel != null) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      item.actionLabel!,
                      style: AppTextStyles.link.copyWith(fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _catBg(NewsCategory cat) {
    switch (cat) {
      case NewsCategory.policy:
      case NewsCategory.announcement:
        return AppColors.reliance50;
      case NewsCategory.people:
        return AppColors.skyLight;
      case NewsCategory.celebration:
        return AppColors.warningLight;
      case NewsCategory.win:
        return AppColors.positiveLight;
    }
  }
}
