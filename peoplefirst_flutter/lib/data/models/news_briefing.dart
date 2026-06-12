enum BriefingSection { reliance, maharashtra, panIndia }

class DialogueTurn {
  final String speaker; // 'kriti' or 'akshay'
  final String text;

  const DialogueTurn({required this.speaker, required this.text});
}

class NewsBriefingStory {
  final BriefingSection section;
  final String headline;
  final List<DialogueTurn> turns;

  const NewsBriefingStory({
    required this.section,
    required this.headline,
    required this.turns,
  });
}

class NewsBriefingEpisode {
  final String id;
  final String episodeHeadline;
  final List<String> summaryPoints;
  final List<NewsBriefingStory> stories;
  final String updatedAt;
  final int durationSeconds;

  const NewsBriefingEpisode({
    required this.id,
    required this.episodeHeadline,
    required this.summaryPoints,
    required this.stories,
    required this.updatedAt,
    required this.durationSeconds,
  });

  List<DialogueTurn> get allTurns =>
      stories.expand((s) => s.turns).toList();
}
