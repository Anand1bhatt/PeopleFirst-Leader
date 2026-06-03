import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task_item.dart';
import '../../data/repositories/mock/mock_employee_repository.dart';
import 'attendance_provider.dart';

final tasksProvider =
    StateNotifierProvider<TasksNotifier, AsyncValue<List<TaskItem>>>(
  (ref) => TasksNotifier(ref.read(employeeRepositoryProvider)),
);

class TasksNotifier extends StateNotifier<AsyncValue<List<TaskItem>>> {
  final MockEmployeeRepository _repo;

  TasksNotifier(this._repo) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final tasks = await _repo.getTasks();
      state = AsyncValue.data(tasks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void toggleTask(String id) {
    state.whenData((tasks) {
      state = AsyncValue.data(
        tasks
            .map((t) => t.id == id ? t.copyWith(completed: !t.completed) : t)
            .toList(),
      );
    });
  }

  List<TaskItem> get todayTasks =>
      state.valueOrNull
          ?.where((t) => t.due == TaskDue.today)
          .toList() ??
      [];

  int get openTodayCount =>
      state.valueOrNull
          ?.where((t) => t.due == TaskDue.today && !t.completed)
          .length ??
      0;
}

final employeeBookingsProvider = FutureProvider((ref) async {
  return ref.read(employeeRepositoryProvider).getBookings();
});

final employeeNewsProvider = FutureProvider((ref) async {
  return ref.read(employeeRepositoryProvider).getNews();
});

final quickLinksProvider = FutureProvider((ref) async {
  return ref.read(employeeRepositoryProvider).getQuickLinks();
});

final morningBriefProvider = FutureProvider((ref) async {
  return ref.read(employeeRepositoryProvider).getMorningBriefItems();
});
