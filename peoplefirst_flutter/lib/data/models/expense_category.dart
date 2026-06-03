import 'decision.dart';

class ExpenseCategory {
  final String id;
  final String name;
  final double spendLakhs;
  final double variancePercent;
  final SignalTone tone;

  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.spendLakhs,
    required this.variancePercent,
    required this.tone,
  });

  ExpenseCategory copyWith({
    String? id,
    String? name,
    double? spendLakhs,
    double? variancePercent,
    SignalTone? tone,
  }) {
    return ExpenseCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      spendLakhs: spendLakhs ?? this.spendLakhs,
      variancePercent: variancePercent ?? this.variancePercent,
      tone: tone ?? this.tone,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ExpenseBudgetData {
  final double spendLakhs;
  final double budgetLakhs;
  final double pacePercent;
  final String aiInsight;
  final List<ExpenseCategory> categories;

  const ExpenseBudgetData({
    required this.spendLakhs,
    required this.budgetLakhs,
    required this.pacePercent,
    required this.aiInsight,
    required this.categories,
  });

  double get spendPercent => (spendLakhs / budgetLakhs) * 100;

  ExpenseBudgetData copyWith({
    double? spendLakhs,
    double? budgetLakhs,
    double? pacePercent,
    String? aiInsight,
    List<ExpenseCategory>? categories,
  }) {
    return ExpenseBudgetData(
      spendLakhs: spendLakhs ?? this.spendLakhs,
      budgetLakhs: budgetLakhs ?? this.budgetLakhs,
      pacePercent: pacePercent ?? this.pacePercent,
      aiInsight: aiInsight ?? this.aiInsight,
      categories: categories ?? this.categories,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseBudgetData &&
          runtimeType == other.runtimeType &&
          spendLakhs == other.spendLakhs &&
          budgetLakhs == other.budgetLakhs;

  @override
  int get hashCode => spendLakhs.hashCode ^ budgetLakhs.hashCode;
}
