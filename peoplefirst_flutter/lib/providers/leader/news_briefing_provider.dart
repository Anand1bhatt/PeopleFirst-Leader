import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/news_briefing.dart';

final newsBriefingProvider = FutureProvider<NewsBriefingEpisode>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return const NewsBriefingEpisode(
    id: 'ep-20260612',
    episodeHeadline: 'Jio 5G Push, Mumbai Infra & India Q1 Growth',
    updatedAt: 'Today · 8:47 am',
    durationSeconds: 78,
    summaryPoints: [
      'Jio expands 5G to 50 new cities this quarter',
      'Mumbai announces ₹4,200 cr metro phase 3 fast-track',
      'India GDP grows 7.2% in Q1, beats analyst forecasts',
    ],
    stories: [
      NewsBriefingStory(
        section: BriefingSection.reliance,
        headline: 'Jio 5G Reaches 50 New Cities',
        turns: [
          DialogueTurn(
            speaker: 'kriti',
            text:
                'Big news from the Jio camp today — Jio just announced it\'s rolling out 5G to 50 new cities this quarter, which brings their total 5G coverage to over 400 cities across India.',
          ),
          DialogueTurn(
            speaker: 'akshay',
            text: 'That\'s a significant jump in just three months.',
          ),
          DialogueTurn(
            speaker: 'kriti',
            text:
                'Exactly. And what makes this interesting is that many of these new cities are Tier 2 — places like Nashik, Surat, and Coimbatore. So 5G is no longer just a metro thing.',
          ),
          DialogueTurn(
            speaker: 'akshay',
            text:
                'That\'s the real story here. Tier 2 and 3 cities are where the next hundred million internet users will come from. Getting 5G infrastructure in early is a smart long-term play for Reliance.',
          ),
        ],
      ),
      NewsBriefingStory(
        section: BriefingSection.maharashtra,
        headline: 'Mumbai Metro Phase 3 Fast-Tracked',
        turns: [
          DialogueTurn(
            speaker: 'akshay',
            text:
                'Switching to Maharashtra — the state government has announced it\'s fast-tracking Mumbai Metro Phase 3, with ₹4,200 crore in fresh funding approved for the Colaba–Bandra–SEEPZ corridor.',
          ),
          DialogueTurn(
            speaker: 'kriti',
            text: 'Oh, that\'s the underground line, right?',
          ),
          DialogueTurn(
            speaker: 'akshay',
            text:
                'That\'s right. It goes fully underground through some of Mumbai\'s most congested stretches. Once complete, the commute from Colaba to SEEPZ drops from about 75 minutes to under 25.',
          ),
          DialogueTurn(
            speaker: 'kriti',
            text:
                'That\'s a massive quality-of-life change for people who make that commute every day. And the timing matters — they\'re targeting completion before the 2027 elections.',
          ),
        ],
      ),
      NewsBriefingStory(
        section: BriefingSection.panIndia,
        headline: 'India Q1 GDP Grows 7.2%',
        turns: [
          DialogueTurn(
            speaker: 'kriti',
            text:
                'And finally, some strong macro news — India\'s GDP grew 7.2% in Q1, which came in above most analyst forecasts. The manufacturing and services sectors both contributed strongly.',
          ),
          DialogueTurn(
            speaker: 'akshay',
            text:
                'What\'s surprising is that this comes despite global headwinds. Most major economies are seeing slower growth right now.',
          ),
          DialogueTurn(
            speaker: 'kriti',
            text:
                'Exactly, which makes India stand out. The RBI\'s inflation management seems to be holding, and domestic consumption is still strong — those are the two engines keeping growth healthy.',
          ),
          DialogueTurn(
            speaker: 'akshay',
            text:
                'For businesses, this kind of growth backdrop generally means better hiring conditions and more confidence in capital spending — so it\'s good context for Q2 planning.',
          ),
        ],
      ),
    ],
  );
});
