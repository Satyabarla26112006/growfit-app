import 'attendance_service.dart';

class MonthlyAttendanceService {
  MonthlyAttendanceService._();

  static int attendedDays(DateTime month) {
    final daysInMonth = DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;

    int count = 0;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(
        month.year,
        month.month,
        day,
      );

      if (AttendanceService.isPresent(date)) {
        count++;
      }
    }

    return count;
  }

  static int completedDaysUntilToday(
    DateTime month,
  ) {
    final now = DateTime.now();

    final daysInMonth = DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;

    int count = 0;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(
        month.year,
        month.month,
        day,
      );

      if (date.isAfter(now)) {
        continue;
      }

      if (AttendanceService.isPresent(date)) {
        count++;
      }
    }

    return count;
  }

  static double percentage(DateTime month) {
    final daysInMonth = DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;

    if (daysInMonth == 0) {
      return 0;
    }

    return attendedDays(month) / daysInMonth;
  }

  static bool isMonthComplete(DateTime month) {
    final now = DateTime.now();

    if (month.year != now.year ||
        month.month != now.month) {
      return false;
    }

    return completedDaysUntilToday(month) ==
        now.day;
  }
}