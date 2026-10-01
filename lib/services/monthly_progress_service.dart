import 'attendance_service.dart';
import 'daily_history_service.dart';

class MonthlyProgressService {
  MonthlyProgressService._();

  static int daysInMonth(DateTime month) {
    return DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;
  }

  static int activeDays(DateTime month) {
    int count = 0;

    for (int day = 1;
        day <= daysInMonth(month);
        day++) {
      final date = DateTime(
        month.year,
        month.month,
        day,
      );

      if (AttendanceService.isPresent(date) ||
          DailyHistoryService.hasFoodForDate(
            date,
          )) {
        count++;
      }
    }

    return count;
  }

  static int attendanceDays(DateTime month) {
    int count = 0;

    for (int day = 1;
        day <= daysInMonth(month);
        day++) {
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

  static double completion(DateTime month) {
    final days = daysInMonth(month);

    if (days == 0) {
      return 0;
    }

    return activeDays(month) / days;
  }

  static String completionText(DateTime month) {
    return '${(completion(month) * 100).round()}%';
  }
}