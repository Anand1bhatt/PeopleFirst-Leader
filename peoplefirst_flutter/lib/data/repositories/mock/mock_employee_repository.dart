import '../../models/task_item.dart';
import '../../models/booking.dart';
import '../../models/news_item.dart';
import '../../models/attendance.dart';
import '../employee_repository.dart';

class MockEmployeeRepository implements EmployeeRepository {
  @override
  Future<List<TaskItem>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const TaskItem(
        id: 't1',
        title: 'Review "Checkout redesign" PR',
        priority: TaskPriority.high,
        source: TaskSource.azure,
        due: TaskDue.today,
        dueLabel: 'Today',
      ),
      const TaskItem(
        id: 't2',
        title: 'Ship empty-states for Tasks widget',
        priority: TaskPriority.high,
        source: TaskSource.azure,
        due: TaskDue.today,
        dueLabel: 'Today',
      ),
      const TaskItem(
        id: 't3',
        title: 'Prep handoff notes for dev',
        priority: TaskPriority.medium,
        source: TaskSource.self,
        due: TaskDue.today,
        dueLabel: 'Today',
      ),
      const TaskItem(
        id: 't4',
        title: 'Update design tokens doc',
        priority: TaskPriority.medium,
        source: TaskSource.azure,
        due: TaskDue.tomorrow,
        dueLabel: 'Tomorrow',
      ),
      const TaskItem(
        id: 't5',
        title: 'Book usability sessions',
        priority: TaskPriority.low,
        source: TaskSource.self,
        due: TaskDue.thisWeek,
        dueLabel: 'Fri',
      ),
    ];
  }

  @override
  Future<AttendanceRecord> getAttendance() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final now = DateTime.now();
    final markedIn = DateTime(now.year, now.month, now.day, 9, 30);
    final markedOut = DateTime(now.year, now.month, now.day, 17, 45);
    return AttendanceRecord(
      status: AttendanceStatus.done,
      markedIn: markedIn,
      markedOut: markedOut,
    );
  }

  @override
  Future<List<Booking>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      const Booking(
        id: 'eb1',
        title: 'Gym',
        timeLabel: '8:00 PM',
        dateLabel: 'Tonight',
        type: BookingType.gym,
        location: 'Building 4A',
        durationMinutes: 60,
        timeAway: 'Today · 2hrs away',
      ),
      const Booking(
        id: 'eb2',
        title: 'Team meet',
        timeLabel: '10:00 AM',
        dateLabel: 'Tomorrow',
        type: BookingType.teamMeet,
        location: 'Conference Room B3',
        durationMinutes: 60,
        timeAway: 'in 21hrs',
      ),
      const Booking(
        id: 'eb3',
        title: '1:1 with manager',
        timeLabel: '3:30 PM',
        dateLabel: 'Wed',
        type: BookingType.oneOnOne,
        location: 'Huddle Room 2',
        durationMinutes: 30,
        timeAway: 'in 2 days',
      ),
    ];
  }

  @override
  Future<List<NewsItem>> getNews() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      const NewsItem(
        id: 'en1',
        category: NewsCategory.announcement,
        headline: 'Hybrid policy update from Monday',
        detail: '3 office days/week starting June 10',
        emoji: '🏢',
      ),
      const NewsItem(
        id: 'en2',
        category: NewsCategory.win,
        headline: 'Design won Q2 craft award',
        detail: 'Your team was recognised for exceptional design quality',
        emoji: '🏆',
      ),
      const NewsItem(
        id: 'en3',
        category: NewsCategory.celebration,
        headline: 'Rohit Sharma\'s birthday today',
        detail: 'Engineering · Wish him well!',
        emoji: '🎂',
        hasAction: true,
        actionLabel: 'Send wish',
      ),
      const NewsItem(
        id: 'en4',
        category: NewsCategory.celebration,
        headline: 'Ananya Gupta\'s birthday tomorrow',
        detail: 'Product · Don\'t forget to wish her',
        emoji: '🎉',
      ),
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getQuickLinks() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return [
      {'label': 'Reimbursement', 'icon': 'currency_rupee', 'color': 0xFF16A34A},
      {'label': 'Benefits', 'icon': 'card_giftcard', 'color': 0xFFD97706},
      {'label': 'Recruitment', 'icon': 'person_search', 'color': 0xFF1a3aa8},
      {'label': 'Virtual ID', 'icon': 'badge', 'color': 0xFF1a3aa8},
      {'label': 'Medibuddy', 'icon': 'support_agent', 'color': 0xFF2F8FD4},
      {'label': 'PME', 'icon': 'check_circle', 'color': 0xFF16A34A},
    ];
  }

  @override
  Future<List<Map<String, String>>> getMorningBriefItems() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return [
      {
        'type': 'task',
        'title': 'Checkout redesign review due 11:00',
        'detail': '2 hours away · high priority',
      },
      {
        'type': 'leave',
        'title': 'Last day to apply for leave',
        'detail': 'June planned leave closes at 6pm',
      },
      {
        'type': 'goals',
        'title': 'Goals & objectives filing has started',
        'detail': 'H2 goals due 15 Jun',
      },
    ];
  }
}
