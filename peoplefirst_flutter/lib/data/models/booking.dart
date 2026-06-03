enum BookingType { meeting, gym, oneOnOne, teamMeet, conference }

class Booking {
  final String id;
  final String title;
  final String timeLabel;
  final String dateLabel;
  final BookingType type;
  final int? attendees;
  final int durationMinutes;
  final String? location;
  final String timeAway;
  final bool isPresenter;

  const Booking({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.dateLabel,
    required this.type,
    this.attendees,
    required this.durationMinutes,
    this.location,
    required this.timeAway,
    this.isPresenter = false,
  });

  Booking copyWith({
    String? id,
    String? title,
    String? timeLabel,
    String? dateLabel,
    BookingType? type,
    int? attendees,
    int? durationMinutes,
    String? location,
    String? timeAway,
    bool? isPresenter,
  }) {
    return Booking(
      id: id ?? this.id,
      title: title ?? this.title,
      timeLabel: timeLabel ?? this.timeLabel,
      dateLabel: dateLabel ?? this.dateLabel,
      type: type ?? this.type,
      attendees: attendees ?? this.attendees,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      location: location ?? this.location,
      timeAway: timeAway ?? this.timeAway,
      isPresenter: isPresenter ?? this.isPresenter,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Booking && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
