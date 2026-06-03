import 'decision.dart';

class PerformanceSubMetric {
  final String label;
  final String value;
  final SignalTone tone;

  const PerformanceSubMetric({
    required this.label,
    required this.value,
    required this.tone,
  });

  PerformanceSubMetric copyWith({
    String? label,
    String? value,
    SignalTone? tone,
  }) {
    return PerformanceSubMetric(
      label: label ?? this.label,
      value: value ?? this.value,
      tone: tone ?? this.tone,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PerformanceSubMetric &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          value == other.value;

  @override
  int get hashCode => label.hashCode ^ value.hashCode;
}

class PerformanceData {
  final String headline;
  final double mainValue;
  final double trendPoints;
  final String period;
  final List<double> sparkline;
  final List<PerformanceSubMetric> subMetrics;

  const PerformanceData({
    required this.headline,
    required this.mainValue,
    required this.trendPoints,
    required this.period,
    required this.sparkline,
    required this.subMetrics,
  });

  PerformanceData copyWith({
    String? headline,
    double? mainValue,
    double? trendPoints,
    String? period,
    List<double>? sparkline,
    List<PerformanceSubMetric>? subMetrics,
  }) {
    return PerformanceData(
      headline: headline ?? this.headline,
      mainValue: mainValue ?? this.mainValue,
      trendPoints: trendPoints ?? this.trendPoints,
      period: period ?? this.period,
      sparkline: sparkline ?? this.sparkline,
      subMetrics: subMetrics ?? this.subMetrics,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PerformanceData &&
          runtimeType == other.runtimeType &&
          headline == other.headline &&
          mainValue == other.mainValue;

  @override
  int get hashCode => headline.hashCode ^ mainValue.hashCode;
}
