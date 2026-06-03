import '../../models/decision.dart';
import '../../models/approval.dart';
import '../../models/performance_metric.dart';
import '../../models/expense_category.dart';
import '../../models/recruitment_role.dart';
import '../../models/booking.dart';
import '../../models/news_item.dart';
import '../leader_repository.dart';

class MockLeaderRepository implements LeaderRepository {
  @override
  Future<List<Decision>> getDecisions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const Decision(
        id: 'd1',
        title: 'High-Impact Retention Decision',
        detail:
            'Rajeev Sharma has received an external offer. HR recommends an off-cycle increment of ₹5L within the approved range.',
        primaryCta: 'Review',
        secondaryCta: 'Dashboard',
        tone: SignalTone.off,
      ),
      const Decision(
        id: 'd2',
        title: 'OFFICE365 renewal expires in 7 days',
        detail:
            'Annual cost ₹14L. Legal cleared. Finance approved. Awaiting your approval.',
        primaryCta: 'Renew',
        secondaryCta: 'Review contract',
        tone: SignalTone.risk,
      ),
    ];
  }

  @override
  Future<ApprovalSummary> getApprovalSummary() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const ApprovalSummary(
      total: 23,
      lowRisk: 14,
      leaveCount: 12,
      travelCount: 6,
      expenseCount: 3,
      signOffCount: 2,
      criticalCount: 1,
    );
  }

  @override
  Future<List<Approval>> getApprovals() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      const Approval(
        id: 'a1',
        type: ApprovalType.travel,
        requesterName: 'Rohan Das',
        requesterRole: 'Senior Engineer',
        description:
            'Travelling to Bengaluru tomorrow. Approve ₹38,500 travel request.',
        amount: 38500,
        dateLabel: 'Tomorrow',
        isCritical: true,
        isLowRisk: false,
      ),
      const Approval(
        id: 'a2',
        type: ApprovalType.leave,
        requesterName: 'Ananya Singh',
        requesterRole: 'Product Manager',
        description: 'Annual leave – 3 days',
        dateLabel: 'Jun 10–12',
        isLowRisk: true,
      ),
      const Approval(
        id: 'a3',
        type: ApprovalType.leave,
        requesterName: 'Karan Mehta',
        requesterRole: 'Designer',
        description: 'Sick leave – 1 day',
        dateLabel: 'Today',
        isLowRisk: true,
      ),
      const Approval(
        id: 'a4',
        type: ApprovalType.expense,
        requesterName: 'Sana Mirza',
        requesterRole: 'Engineering Manager',
        description: 'Team offsite expenses – ₹22,000',
        amount: 22000,
        dateLabel: 'Jun 5',
        isLowRisk: false,
      ),
      const Approval(
        id: 'a5',
        type: ApprovalType.leave,
        requesterName: 'Devansh Roy',
        requesterRole: 'Backend Engineer',
        description: 'Casual leave – 2 days',
        dateLabel: 'Jun 14–15',
        isLowRisk: true,
      ),
      const Approval(
        id: 'a6',
        type: ApprovalType.travel,
        requesterName: 'Priya Nair',
        requesterRole: 'UX Researcher',
        description: 'Travel to Mumbai for user research – ₹15,200',
        amount: 15200,
        dateLabel: 'Jun 8',
        isLowRisk: true,
      ),
      const Approval(
        id: 'a7',
        type: ApprovalType.signOff,
        requesterName: 'Imran Khan',
        requesterRole: 'Tech Lead',
        description: 'Q2 architecture review sign-off',
        dateLabel: 'Jun 7',
        isLowRisk: false,
      ),
      const Approval(
        id: 'a8',
        type: ApprovalType.expense,
        requesterName: 'Aanya Verma',
        requesterRole: 'Data Analyst',
        description: 'Conference registration – ₹8,500',
        amount: 8500,
        dateLabel: 'Jun 6',
        isLowRisk: true,
      ),
      const Approval(
        id: 'a9',
        type: ApprovalType.leave,
        requesterName: 'Raj Patel',
        requesterRole: 'DevOps Engineer',
        description: 'Annual leave – 5 days',
        dateLabel: 'Jun 17–21',
        isLowRisk: true,
      ),
      const Approval(
        id: 'a10',
        type: ApprovalType.leave,
        requesterName: 'Meena Krishnan',
        requesterRole: 'QA Engineer',
        description: 'Maternity leave extension – 15 days',
        dateLabel: 'Jun 10',
        isLowRisk: false,
      ),
    ];
  }

  @override
  Future<PerformanceData> getPerformanceData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const PerformanceData(
      headline: 'Work finished on time',
      mainValue: 86,
      trendPoints: 4,
      period: 'May',
      sparkline: [62, 70, 66, 74, 80, 86],
      subMetrics: [
        PerformanceSubMetric(
          label: 'Team workload',
          value: '113%',
          tone: SignalTone.off,
        ),
        PerformanceSubMetric(
          label: 'Bugs found late',
          value: '14',
          tone: SignalTone.risk,
        ),
        PerformanceSubMetric(
          label: 'Delivery speed',
          value: '92 pts',
          tone: SignalTone.healthy,
        ),
      ],
    );
  }

  @override
  Future<ExpenseBudgetData> getExpenseBudgetData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const ExpenseBudgetData(
      spendLakhs: 86,
      budgetLakhs: 104,
      pacePercent: 79,
      aiInsight: '4% over plan · team travel is the main driver',
      categories: [
        ExpenseCategory(
          id: 'training',
          name: 'Training',
          spendLakhs: 10,
          variancePercent: 15,
          tone: SignalTone.off,
        ),
        ExpenseCategory(
          id: 'travel',
          name: 'Travel',
          spendLakhs: 35,
          variancePercent: 8,
          tone: SignalTone.risk,
        ),
        ExpenseCategory(
          id: 'contractors',
          name: 'Contractors',
          spendLakhs: 24,
          variancePercent: 0,
          tone: SignalTone.healthy,
        ),
        ExpenseCategory(
          id: 'tooling',
          name: 'Tooling',
          spendLakhs: 17,
          variancePercent: 0,
          tone: SignalTone.healthy,
        ),
      ],
    );
  }

  @override
  Future<RecruitmentSummary> getRecruitmentSummary() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const RecruitmentSummary(
      totalCvs: 379,
      targetCvs: 400,
      trendPercent: 12,
      urgentCount: 1,
      roles: [
        RecruitmentRole(
          id: 'r1',
          title: 'Product Designer',
          openPositions: 2,
          applicants: 0,
          tone: SignalTone.off,
          aiTip: 'Try hiring remotely and increasing salary range.',
          isUrgent: true,
        ),
        RecruitmentRole(
          id: 'r2',
          title: 'Engineering Manager Platform',
          openPositions: 1,
          applicants: 18,
          tone: SignalTone.risk,
        ),
        RecruitmentRole(
          id: 'r3',
          title: 'Sr Backend Engineer',
          openPositions: 3,
          applicants: 142,
          tone: SignalTone.healthy,
        ),
      ],
    );
  }

  @override
  Future<List<Booking>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      const Booking(
        id: 'b1',
        title: 'Q2 Leadership Review',
        timeLabel: '10:00',
        dateLabel: 'Today',
        type: BookingType.meeting,
        attendees: 6,
        durationMinutes: 90,
        timeAway: 'in 1h 8m',
        isPresenter: true,
      ),
      const Booking(
        id: 'b2',
        title: '1:1 with Karan Mehta',
        timeLabel: '14:30',
        dateLabel: 'Today',
        type: BookingType.oneOnOne,
        durationMinutes: 30,
        timeAway: 'in 5h 38m',
      ),
      const Booking(
        id: 'b3',
        title: 'Gym slot booked',
        timeLabel: '18:30',
        dateLabel: 'Today',
        type: BookingType.gym,
        durationMinutes: 45,
        timeAway: 'in 9h 38m',
      ),
    ];
  }

  @override
  Future<List<NewsItem>> getNews() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      const NewsItem(
        id: 'n1',
        category: NewsCategory.policy,
        headline: 'Hybrid work policy starts Monday',
        detail: '2 of your remote teams need a desk plan',
        emoji: '🏢',
        hasAction: true,
        actionLabel: 'Create plan',
      ),
      const NewsItem(
        id: 'n2',
        category: NewsCategory.people,
        headline: 'Sana is back from leave today',
        detail: 'Rejoins Design after 4 months',
        emoji: '👋',
      ),
      const NewsItem(
        id: 'n3',
        category: NewsCategory.celebration,
        headline: '5 birthdays & anniversaries',
        detail: 'Karan Mehta, Aanya Verma, Devansh Roy, Priya Nair, Imran Khan',
        emoji: '🎉',
        hasAction: true,
        actionLabel: 'Send wishes',
      ),
    ];
  }

  @override
  Future<Map<String, int>> getTeamSnapshot() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return {
      'total': 250,
      'present': 204,
      'onLeave': 20,
      'notIn': 10,
      'woPh': 16,
    };
  }
}
