import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/news_briefing.dart';
import '../../../../providers/leader/news_briefing_provider.dart';
import '../../../../shared/widgets/section_header.dart';

class AiNewsBriefingWidget extends ConsumerWidget {
  const AiNewsBriefingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(newsBriefingProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'AI News Briefing'),
        const SizedBox(height: 10),
        async.when(
          loading: () => _Shimmer(),
          error: (_, __) => const SizedBox.shrink(),
          data: (ep) => _EpisodeCard(episode: ep),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Main episode card
// ──────────────────────────────────────────────────────────────────────────────

class _EpisodeCard extends StatefulWidget {
  final NewsBriefingEpisode episode;

  const _EpisodeCard({required this.episode});

  @override
  State<_EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<_EpisodeCard>
    with TickerProviderStateMixin {
  int _activeSection = 0;
  bool _playing = false;
  int _activeTurn = 0;
  bool _showTranscript = false;
  Timer? _playTimer;

  late final AnimationController _waveCtrl;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _playTimer?.cancel();
    _waveCtrl.dispose();
    super.dispose();
  }

  NewsBriefingStory get _story =>
      widget.episode.stories[_activeSection];

  void _togglePlay() {
    setState(() => _playing = !_playing);
    if (_playing) {
      _waveCtrl.repeat(reverse: true);
      _activeTurn = 0;
      _advanceTurn();
    } else {
      _waveCtrl.stop();
      _playTimer?.cancel();
    }
  }

  void _advanceTurn() {
    final turns = _story.turns;
    _playTimer?.cancel();
    _playTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted || !_playing) return;
      final next = _activeTurn + 1;
      if (next < turns.length) {
        setState(() => _activeTurn = next);
        _advanceTurn();
      } else {
        setState(() {
          _playing = false;
          _activeTurn = 0;
        });
        _waveCtrl.stop();
      }
    });
  }

  void _selectSection(int idx) {
    _playTimer?.cancel();
    _waveCtrl.stop();
    setState(() {
      _activeSection = idx;
      _playing = false;
      _activeTurn = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceMinimal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.strokeMinimal),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(episode: widget.episode, waveCtrl: _waveCtrl, playing: _playing),
          _SectionTabs(
            sections: widget.episode.stories.map((s) => s.section).toList(),
            active: _activeSection,
            onTap: _selectSection,
          ),
          _StoryHeadline(story: _story),
          _PlayerBar(
            playing: _playing,
            onToggle: _togglePlay,
            activeTurn: _activeTurn,
            totalTurns: _story.turns.length,
            waveCtrl: _waveCtrl,
            currentSpeaker: _playing ? _story.turns[_activeTurn].speaker : null,
          ),
          if (_playing || _showTranscript)
            _TranscriptView(
              turns: _story.turns,
              activeTurn: _activeTurn,
              playing: _playing,
            ),
          _Footer(
            summaryPoints: widget.episode.summaryPoints,
            showTranscript: _showTranscript,
            onToggleTranscript: () =>
                setState(() => _showTranscript = !_showTranscript),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Header
// ──────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final NewsBriefingEpisode episode;
  final AnimationController waveCtrl;
  final bool playing;

  const _Header({
    required this.episode,
    required this.waveCtrl,
    required this.playing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A5C8A), Color(0xFF2F8FD4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          // Hosts avatars
          _HostAvatarStack(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI News Briefing',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Kriti & Akshay · ${episode.updatedAt}',
                  style: const TextStyle(
                    color: Color(0xCCFFFFFF),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (playing)
            AnimatedBuilder(
              animation: waveCtrl,
              builder: (_, __) => _LivePill(pulse: waveCtrl.value),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4ADE80),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Fresh',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HostAvatarStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 32,
      child: Stack(
        children: [
          Positioned(
            left: 20,
            child: _Avatar(initials: 'A', color: const Color(0xFF1D4ED8)),
          ),
          Positioned(
            left: 0,
            child: _Avatar(initials: 'K', color: const Color(0xFF7C3AED)),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  final Color color;

  const _Avatar({required this.initials, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LivePill extends StatelessWidget {
  final double pulse;

  const _LivePill({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(3, (i) {
            final heightFrac = i == 1 ? pulse : (i == 0 ? 1 - pulse : pulse * 0.7 + 0.3);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 2.5,
                height: 6 * heightFrac.clamp(0.3, 1.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
          const SizedBox(width: 4),
          const Text(
            'Playing',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Section tabs
// ──────────────────────────────────────────────────────────────────────────────

class _SectionTabs extends StatelessWidget {
  final List<BriefingSection> sections;
  final int active;
  final ValueChanged<int> onTap;

  const _SectionTabs({
    required this.sections,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: List.generate(sections.length, (i) {
          final selected = i == active;
          return Padding(
            padding: EdgeInsets.only(right: i < sections.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: selected ? AppColors.skyInk : AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _sectionLabel(sections[i]),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.contentModerate,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  String _sectionLabel(BriefingSection s) {
    switch (s) {
      case BriefingSection.reliance:
        return 'Reliance · Jio';
      case BriefingSection.maharashtra:
        return 'Maharashtra';
      case BriefingSection.panIndia:
        return 'Pan India';
    }
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Story headline
// ──────────────────────────────────────────────────────────────────────────────

class _StoryHeadline extends StatelessWidget {
  final NewsBriefingStory story;

  const _StoryHeadline({required this.story});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Text(
        story.headline,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.contentHeavy,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Player bar
// ──────────────────────────────────────────────────────────────────────────────

class _PlayerBar extends StatelessWidget {
  final bool playing;
  final VoidCallback onToggle;
  final int activeTurn;
  final int totalTurns;
  final AnimationController waveCtrl;
  final String? currentSpeaker;

  const _PlayerBar({
    required this.playing,
    required this.onToggle,
    required this.activeTurn,
    required this.totalTurns,
    required this.waveCtrl,
    required this.currentSpeaker,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.skyInk,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.skyInk.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: totalTurns > 0 ? (activeTurn + (playing ? 0.5 : 0)) / totalTurns : 0,
                    backgroundColor: AppColors.surfaceModerate,
                    color: AppColors.skyBase,
                    minHeight: 3,
                  ),
                ),
                const SizedBox(height: 4),
                if (playing && currentSpeaker != null)
                  Text(
                    '${_speakerName(currentSpeaker!)} is speaking…',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.contentModerate,
                    ),
                  )
                else
                  const Text(
                    'Tap play to listen',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.contentMinimal,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _speakerName(String speaker) =>
      speaker == 'kriti' ? 'Kriti' : 'Akshay';
}

// ──────────────────────────────────────────────────────────────────────────────
// Transcript view
// ──────────────────────────────────────────────────────────────────────────────

class _TranscriptView extends StatelessWidget {
  final List<DialogueTurn> turns;
  final int activeTurn;
  final bool playing;

  const _TranscriptView({
    required this.turns,
    required this.activeTurn,
    required this.playing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(turns.length, (i) {
          final turn = turns[i];
          final isActive = playing && i == activeTurn;
          final isPast = i < activeTurn;
          return _TurnRow(
            turn: turn,
            isActive: isActive,
            isPast: isPast,
          );
        }),
      ),
    );
  }
}

class _TurnRow extends StatelessWidget {
  final DialogueTurn turn;
  final bool isActive;
  final bool isPast;

  const _TurnRow({
    required this.turn,
    required this.isActive,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    final isKriti = turn.speaker == 'kriti';
    final avatarColor =
        isKriti ? const Color(0xFF7C3AED) : const Color(0xFF1D4ED8);
    final initials = isKriti ? 'K' : 'A';
    final name = isKriti ? 'Kriti' : 'Akshay';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.skyLight
            : Colors.white.withOpacity(isPast ? 0.4 : 1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? AppColors.skyBorder : Colors.transparent,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: avatarColor.withOpacity(isPast && !isActive ? 0.5 : 1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? AppColors.skyInk
                        : AppColors.contentModerate,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  turn.text,
                  style: TextStyle(
                    fontSize: 12,
                    color: isPast && !isActive
                        ? AppColors.contentMinimal
                        : AppColors.contentHeavy,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            const Padding(
              padding: EdgeInsets.only(left: 4, top: 2),
              child: Icon(
                Icons.volume_up_rounded,
                size: 14,
                color: AppColors.skyBase,
              ),
            ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Footer: summary + transcript toggle
// ──────────────────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  final List<String> summaryPoints;
  final bool showTranscript;
  final VoidCallback onToggleTranscript;

  const _Footer({
    required this.summaryPoints,
    required this.showTranscript,
    required this.onToggleTranscript,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            "Today's briefing",
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.contentModerate,
            ),
          ),
        ),
        ...summaryPoints.map((point) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 3, 16, 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.only(top: 5, right: 8),
                    decoration: const BoxDecoration(
                      color: AppColors.skyBase,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(point, style: AppTextStyles.caption),
                  ),
                ],
              ),
            )),
        GestureDetector(
          onTap: onToggleTranscript,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Row(
              children: [
                Icon(
                  showTranscript
                      ? Icons.unfold_less_rounded
                      : Icons.unfold_more_rounded,
                  size: 14,
                  color: AppColors.skyBase,
                ),
                const SizedBox(width: 4),
                Text(
                  showTranscript ? 'Hide transcript' : 'Read transcript',
                  style: AppTextStyles.link.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Shimmer placeholder
// ──────────────────────────────────────────────────────────────────────────────

class _Shimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.surfaceModerate,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
