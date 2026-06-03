enum NewsCategory { policy, people, celebration, win, announcement }

class NewsItem {
  final String id;
  final NewsCategory category;
  final String headline;
  final String detail;
  final String? emoji;
  final bool hasAction;
  final String? actionLabel;

  const NewsItem({
    required this.id,
    required this.category,
    required this.headline,
    required this.detail,
    this.emoji,
    this.hasAction = false,
    this.actionLabel,
  });

  NewsItem copyWith({
    String? id,
    NewsCategory? category,
    String? headline,
    String? detail,
    String? emoji,
    bool? hasAction,
    String? actionLabel,
  }) {
    return NewsItem(
      id: id ?? this.id,
      category: category ?? this.category,
      headline: headline ?? this.headline,
      detail: detail ?? this.detail,
      emoji: emoji ?? this.emoji,
      hasAction: hasAction ?? this.hasAction,
      actionLabel: actionLabel ?? this.actionLabel,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
