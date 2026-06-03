import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/pf_card.dart';
import '../../../shared/widgets/signal_badge.dart';
import '../../../data/models/decision.dart';

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surfaceSubtle,
      appBar: AppBar(
        title: const Text(
          'My Team',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.contentHeavy,
          ),
        ),
        backgroundColor: AppColors.surfaceMinimal,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded, color: AppColors.contentHeavy),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary strip
          PfCard(
            child: Row(
              children: [
                _StatCell(label: 'Total', value: '250', color: AppColors.relianceBase),
                _vDivider(),
                _StatCell(label: 'Present', value: '204', color: AppColors.positive),
                _vDivider(),
                _StatCell(label: 'On leave', value: '20', color: AppColors.warning),
                _vDivider(),
                _StatCell(label: 'Not in', value: '10', color: AppColors.negative),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Department sections
          _DeptSection(
            dept: 'Product & Design',
            count: 42,
            members: [
              _Member('Karan Mehta', 'Product Manager', SignalTone.healthy, 'KM'),
              _Member('Sana Mirza', 'Engineering Manager', SignalTone.healthy, 'SM'),
              _Member('Priya Nair', 'UX Researcher', SignalTone.healthy, 'PN'),
              _Member('Ananya Singh', 'Designer', SignalTone.risk, 'AS'),
            ],
          ),
          const SizedBox(height: 12),
          _DeptSection(
            dept: 'Engineering',
            count: 120,
            members: [
              _Member('Rohan Das', 'Senior Engineer', SignalTone.off, 'RD'),
              _Member('Devansh Roy', 'Backend Engineer', SignalTone.healthy, 'DR'),
              _Member('Raj Patel', 'DevOps Engineer', SignalTone.healthy, 'RP'),
              _Member('Imran Khan', 'Tech Lead', SignalTone.healthy, 'IK'),
            ],
          ),
          const SizedBox(height: 12),
          _DeptSection(
            dept: 'Analytics & Data',
            count: 28,
            members: [
              _Member('Aanya Verma', 'Data Analyst', SignalTone.healthy, 'AV'),
              _Member('Meena Krishnan', 'QA Engineer', SignalTone.risk, 'MK'),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
        width: 1,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: AppColors.strokeMinimal,
      );
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCell({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(label, style: AppTextStyles.captionMinimal.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}

class _Member {
  final String name;
  final String role;
  final SignalTone status;
  final String initials;

  const _Member(this.name, this.role, this.status, this.initials);
}

class _DeptSection extends StatelessWidget {
  final String dept;
  final int count;
  final List<_Member> members;

  const _DeptSection({
    required this.dept,
    required this.count,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text(
                dept.toUpperCase(),
                style: AppTextStyles.sectionHeader,
              ),
              const SizedBox(width: 8),
              Text(
                '($count)',
                style: AppTextStyles.captionMinimal,
              ),
            ],
          ),
        ),
        PfCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: List.generate(members.length, (i) {
              final m = members[i];
              return Column(
                children: [
                  _MemberRow(member: m),
                  if (i < members.length - 1)
                    const Divider(height: 1, indent: 60, endIndent: 16),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _MemberRow extends StatelessWidget {
  final _Member member;

  const _MemberRow({required this.member});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceModerate,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  member.initials,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.contentModerate,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _statusColor(member.status),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.surfaceMinimal,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name, style: AppTextStyles.body.copyWith(fontSize: 13)),
                Text(member.role, style: AppTextStyles.captionMinimal),
              ],
            ),
          ),
          SignalBadge(tone: member.status, compact: true),
        ],
      ),
    );
  }

  Color _statusColor(SignalTone tone) {
    switch (tone) {
      case SignalTone.healthy:
        return AppColors.positive;
      case SignalTone.risk:
        return AppColors.warning;
      case SignalTone.off:
        return AppColors.negative;
      case SignalTone.info:
        return AppColors.skyBase;
    }
  }
}
