import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/decision.dart';
import '../../data/repositories/mock/mock_leader_repository.dart';

final leaderRepositoryProvider = Provider((_) => MockLeaderRepository());

final decisionsProvider =
    StateNotifierProvider<DecisionsNotifier, AsyncValue<List<Decision>>>(
  (ref) => DecisionsNotifier(ref.read(leaderRepositoryProvider)),
);

class DecisionsNotifier extends StateNotifier<AsyncValue<List<Decision>>> {
  final MockLeaderRepository _repo;

  DecisionsNotifier(this._repo) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final decisions = await _repo.getDecisions();
      state = AsyncValue.data(decisions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void resolve(String id) {
    state.whenData((decisions) {
      state = AsyncValue.data(
        decisions.map((d) => d.id == id ? d.copyWith(resolved: true) : d).toList(),
      );
    });
  }

  bool get allResolved =>
      state.valueOrNull?.every((d) => d.resolved) ?? false;

  int get unresolvedCount =>
      state.valueOrNull?.where((d) => !d.resolved).length ?? 0;
}

final approvalSummaryProvider = FutureProvider((ref) async {
  return ref.read(leaderRepositoryProvider).getApprovalSummary();
});

final performanceProvider = FutureProvider((ref) async {
  return ref.read(leaderRepositoryProvider).getPerformanceData();
});

final expenseBudgetProvider = FutureProvider((ref) async {
  return ref.read(leaderRepositoryProvider).getExpenseBudgetData();
});

final recruitmentProvider = FutureProvider((ref) async {
  return ref.read(leaderRepositoryProvider).getRecruitmentSummary();
});

final leaderBookingsProvider = FutureProvider((ref) async {
  return ref.read(leaderRepositoryProvider).getBookings();
});

final leaderNewsProvider = FutureProvider((ref) async {
  return ref.read(leaderRepositoryProvider).getNews();
});

final teamSnapshotProvider = FutureProvider((ref) async {
  return ref.read(leaderRepositoryProvider).getTeamSnapshot();
});
