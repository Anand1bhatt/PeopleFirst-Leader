import 'decision.dart';

class RecruitmentRole {
  final String id;
  final String title;
  final int openPositions;
  final int applicants;
  final SignalTone tone;
  final String? aiTip;
  final bool isUrgent;

  const RecruitmentRole({
    required this.id,
    required this.title,
    required this.openPositions,
    required this.applicants,
    required this.tone,
    this.aiTip,
    this.isUrgent = false,
  });

  RecruitmentRole copyWith({
    String? id,
    String? title,
    int? openPositions,
    int? applicants,
    SignalTone? tone,
    String? aiTip,
    bool? isUrgent,
  }) {
    return RecruitmentRole(
      id: id ?? this.id,
      title: title ?? this.title,
      openPositions: openPositions ?? this.openPositions,
      applicants: applicants ?? this.applicants,
      tone: tone ?? this.tone,
      aiTip: aiTip ?? this.aiTip,
      isUrgent: isUrgent ?? this.isUrgent,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecruitmentRole &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class RecruitmentSummary {
  final int totalCvs;
  final int targetCvs;
  final double trendPercent;
  final List<RecruitmentRole> roles;
  final int urgentCount;

  const RecruitmentSummary({
    required this.totalCvs,
    required this.targetCvs,
    required this.trendPercent,
    required this.roles,
    required this.urgentCount,
  });

  RecruitmentSummary copyWith({
    int? totalCvs,
    int? targetCvs,
    double? trendPercent,
    List<RecruitmentRole>? roles,
    int? urgentCount,
  }) {
    return RecruitmentSummary(
      totalCvs: totalCvs ?? this.totalCvs,
      targetCvs: targetCvs ?? this.targetCvs,
      trendPercent: trendPercent ?? this.trendPercent,
      roles: roles ?? this.roles,
      urgentCount: urgentCount ?? this.urgentCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecruitmentSummary &&
          runtimeType == other.runtimeType &&
          totalCvs == other.totalCvs;

  @override
  int get hashCode => totalCvs.hashCode;
}
