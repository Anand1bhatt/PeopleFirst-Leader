import '../models/decision.dart';
import '../models/approval.dart';
import '../models/performance_metric.dart';
import '../models/expense_category.dart';
import '../models/recruitment_role.dart';
import '../models/booking.dart';
import '../models/news_item.dart';

abstract class LeaderRepository {
  Future<List<Decision>> getDecisions();
  Future<ApprovalSummary> getApprovalSummary();
  Future<List<Approval>> getApprovals();
  Future<PerformanceData> getPerformanceData();
  Future<ExpenseBudgetData> getExpenseBudgetData();
  Future<RecruitmentSummary> getRecruitmentSummary();
  Future<List<Booking>> getBookings();
  Future<List<NewsItem>> getNews();
  Future<Map<String, int>> getTeamSnapshot();
}
