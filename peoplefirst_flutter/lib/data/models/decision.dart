enum SignalTone { healthy, risk, off, info }

class Decision {
  final String id;
  final String title;
  final String detail;
  final String primaryCta;
  final String secondaryCta;
  final SignalTone tone;
  final bool resolved;

  const Decision({
    required this.id,
    required this.title,
    required this.detail,
    required this.primaryCta,
    required this.secondaryCta,
    required this.tone,
    this.resolved = false,
  });

  Decision copyWith({
    String? id,
    String? title,
    String? detail,
    String? primaryCta,
    String? secondaryCta,
    SignalTone? tone,
    bool? resolved,
  }) {
    return Decision(
      id: id ?? this.id,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      primaryCta: primaryCta ?? this.primaryCta,
      secondaryCta: secondaryCta ?? this.secondaryCta,
      tone: tone ?? this.tone,
      resolved: resolved ?? this.resolved,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Decision && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
