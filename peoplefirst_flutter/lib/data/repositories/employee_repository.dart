import '../models/task_item.dart';
import '../models/booking.dart';
import '../models/news_item.dart';
import '../models/attendance.dart';

abstract class EmployeeRepository {
  Future<List<TaskItem>> getTasks();
  Future<AttendanceRecord> getAttendance();
  Future<List<Booking>> getBookings();
  Future<List<NewsItem>> getNews();
  Future<List<Map<String, dynamic>>> getQuickLinks();
  Future<List<Map<String, String>>> getMorningBriefItems();
}
