import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/approval.dart';
import '../../data/repositories/mock/mock_leader_repository.dart';
import 'decisions_provider.dart';

final approvalsListProvider =
    StateNotifierProvider<ApprovalsNotifier, AsyncValue<List<Approval>>>(
  (ref) => ApprovalsNotifier(ref.read(leaderRepositoryProvider)),
);

class ApprovalsNotifier extends StateNotifier<AsyncValue<List<Approval>>> {
  final MockLeaderRepository _repo;

  ApprovalsNotifier(this._repo) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final approvals = await _repo.getApprovals();
      state = AsyncValue.data(approvals);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void approve(String id) {
    state.whenData((list) {
      state = AsyncValue.data(
        list
            .map((a) => a.id == id ? a.copyWith(status: ApprovalStatus.approved) : a)
            .toList(),
      );
    });
  }

  void reject(String id) {
    state.whenData((list) {
      state = AsyncValue.data(
        list
            .map((a) => a.id == id ? a.copyWith(status: ApprovalStatus.rejected) : a)
            .toList(),
      );
    });
  }

  int get pendingCount =>
      state.valueOrNull
          ?.where((a) => a.status == ApprovalStatus.pending)
          .length ??
      0;
}
