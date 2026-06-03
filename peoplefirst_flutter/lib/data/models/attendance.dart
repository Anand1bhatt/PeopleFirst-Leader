enum AttendanceStatus { out, in_, done }

class AttendanceRecord {
  final AttendanceStatus status;
  final DateTime? markedIn;
  final DateTime? markedOut;

  const AttendanceRecord({
    required this.status,
    this.markedIn,
    this.markedOut,
  });

  Duration get duration {
    if (markedIn == null) return Duration.zero;
    final end = markedOut ?? DateTime.now();
    return end.difference(markedIn!);
  }

  AttendanceRecord copyWith({
    AttendanceStatus? status,
    DateTime? markedIn,
    DateTime? markedOut,
  }) {
    return AttendanceRecord(
      status: status ?? this.status,
      markedIn: markedIn ?? this.markedIn,
      markedOut: markedOut ?? this.markedOut,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceRecord &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          markedIn == other.markedIn &&
          markedOut == other.markedOut;

  @override
  int get hashCode => status.hashCode ^ markedIn.hashCode ^ markedOut.hashCode;
}
