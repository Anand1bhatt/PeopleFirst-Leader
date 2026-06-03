enum ApprovalType { leave, travel, expense, signOff }

enum ApprovalStatus { pending, approved, rejected }

class Approval {
  final String id;
  final ApprovalType type;
  final String requesterName;
  final String requesterRole;
  final String description;
  final double? amount;
  final String dateLabel;
  final bool isCritical;
  final ApprovalStatus status;
  final bool isLowRisk;

  const Approval({
    required this.id,
    required this.type,
    required this.requesterName,
    required this.requesterRole,
    required this.description,
    this.amount,
    required this.dateLabel,
    this.isCritical = false,
    this.status = ApprovalStatus.pending,
    this.isLowRisk = false,
  });

  Approval copyWith({
    String? id,
    ApprovalType? type,
    String? requesterName,
    String? requesterRole,
    String? description,
    double? amount,
    String? dateLabel,
    bool? isCritical,
    ApprovalStatus? status,
    bool? isLowRisk,
  }) {
    return Approval(
      id: id ?? this.id,
      type: type ?? this.type,
      requesterName: requesterName ?? this.requesterName,
      requesterRole: requesterRole ?? this.requesterRole,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      dateLabel: dateLabel ?? this.dateLabel,
      isCritical: isCritical ?? this.isCritical,
      status: status ?? this.status,
      isLowRisk: isLowRisk ?? this.isLowRisk,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Approval && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ApprovalSummary {
  final int total;
  final int lowRisk;
  final int leaveCount;
  final int travelCount;
  final int expenseCount;
  final int signOffCount;
  final int criticalCount;

  const ApprovalSummary({
    required this.total,
    required this.lowRisk,
    required this.leaveCount,
    required this.travelCount,
    required this.expenseCount,
    required this.signOffCount,
    required this.criticalCount,
  });

  ApprovalSummary copyWith({
    int? total,
    int? lowRisk,
    int? leaveCount,
    int? travelCount,
    int? expenseCount,
    int? signOffCount,
    int? criticalCount,
  }) {
    return ApprovalSummary(
      total: total ?? this.total,
      lowRisk: lowRisk ?? this.lowRisk,
      leaveCount: leaveCount ?? this.leaveCount,
      travelCount: travelCount ?? this.travelCount,
      expenseCount: expenseCount ?? this.expenseCount,
      signOffCount: signOffCount ?? this.signOffCount,
      criticalCount: criticalCount ?? this.criticalCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApprovalSummary &&
          runtimeType == other.runtimeType &&
          total == other.total &&
          lowRisk == other.lowRisk;

  @override
  int get hashCode => total.hashCode ^ lowRisk.hashCode;
}
