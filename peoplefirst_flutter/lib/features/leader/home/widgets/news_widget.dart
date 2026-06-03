import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/news_item.dart';
import '../../../../providers/leader/decisions_provider.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/pf_card.dart';

class NewsWidget extends ConsumerWidget {
  const NewsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(leaderNewsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Highlights'),
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
          data: (news) => PfCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: List.generate(news.length, (i) {
                final item = news[i];
                return Column(
                  children: [
                    _NewsRow(item: item),
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

class _NewsRow extends StatelessWidget {
  final NewsItem item;

  const _NewsRow({required this.item});

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
              color: _categoryBg(item.category),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              item.emoji ?? _categoryEmoji(item.category),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: _categoryBg(item.category),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              _categoryLabel(item.category),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: _categoryColor(item.category),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _categoryEmoji(NewsCategory cat) {
    switch (cat) {
      case NewsCategory.policy:
        return '🏢';
      case NewsCategory.people:
        return '👋';
      case NewsCategory.celebration:
        return '🎉';
      case NewsCategory.win:
        return '🏆';
      case NewsCategory.announcement:
        return '📣';
    }
  }

  Color _categoryBg(NewsCategory cat) {
    switch (cat) {
      case NewsCategory.policy:
        return AppColors.reliance50;
      case NewsCategory.people:
        return AppColors.skyLight;
      case NewsCategory.celebration:
        return AppColors.warningLight;
      case NewsCategory.win:
        return AppColors.positiveLight;
      case NewsCategory.announcement:
        return AppColors.reliance50;
    }
  }

  Color _categoryColor(NewsCategory cat) {
    switch (cat) {
      case NewsCategory.policy:
        return AppColors.relianceBase;
      case NewsCategory.people:
        return AppColors.skyInk;
      case NewsCategory.celebration:
        return AppColors.warning;
      case NewsCategory.win:
        return AppColors.positive;
      case NewsCategory.announcement:
        return AppColors.relianceBase;
    }
  }

  String _categoryLabel(NewsCategory cat) {
    switch (cat) {
      case NewsCategory.policy:
        return 'Policy';
      case NewsCategory.people:
        return 'People';
      case NewsCategory.celebration:
        return 'Celebration';
      case NewsCategory.win:
        return 'Win';
      case NewsCategory.announcement:
        return 'Announcement';
    }
  }
}
