import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/attendance.dart';
import '../../data/repositories/mock/mock_employee_repository.dart';

final employeeRepositoryProvider = Provider((_) => MockEmployeeRepository());

final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, AsyncValue<AttendanceRecord>>(
  (ref) => AttendanceNotifier(ref.read(employeeRepositoryProvider)),
);

class AttendanceNotifier
    extends StateNotifier<AsyncValue<AttendanceRecord>> {
  final MockEmployeeRepository _repo;
  Timer? _timer;

  AttendanceNotifier(this._repo) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final record = await _repo.getAttendance();
      state = AsyncValue.data(record);
      if (record.status == AttendanceStatus.in_) {
        _startTimer();
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      state.whenData((record) {
        if (record.status == AttendanceStatus.in_) {
          // Trigger rebuild for duration update
          state = AsyncValue.data(record.copyWith());
        }
      });
    });
  }

  void markIn() {
    state.whenData((record) {
      final updated = AttendanceRecord(
        status: AttendanceStatus.in_,
        markedIn: DateTime.now(),
      );
      state = AsyncValue.data(updated);
      _startTimer();
    });
  }

  void markOut() {
    state.whenData((record) {
      _timer?.cancel();
      final updated = record.copyWith(
        status: AttendanceStatus.done,
        markedOut: DateTime.now(),
      );
      state = AsyncValue.data(updated);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
