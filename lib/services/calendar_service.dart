import 'attendance_service.dart';
import 'daily_history_service.dart';

class CalendarService {
  CalendarService._();

  static bool hasAttendance(
    DateTime date,
  ) {
    return AttendanceService.isPresent(
      date,
    );
  }

  static bool hasFood(
    DateTime date,
  ) {
    return DailyHistoryService
        .hasFoodForDate(date);
  }

  static bool hasActivity(
    DateTime date,
  ) {
    return hasAttendance(date) ||
        hasFood(date);
  }

  static String dateKey(
    DateTime date,
  ) {
    return AttendanceService.dateKey(
      date,
    );
  }

  static bool isToday(
    DateTime date,
  ) {
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isFuture(
    DateTime date,
  ) {
    final today = DateTime.now();

    final current = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final target = DateTime(
      date.year,
      date.month,
      date.day,
    );

    return target.isAfter(current);
  }
}