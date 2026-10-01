import 'attendance_service.dart';

class WeeklyStatsService {
  WeeklyStatsService._();

  static DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  static DateTime _mondayOfWeek(
    DateTime date,
  ) {
    final day = _dateOnly(date);

    return day.subtract(
      Duration(days: day.weekday - 1),
    );
  }

  static int attendanceDays(
    DateTime weekDate,
  ) {
    final monday =
        _mondayOfWeek(weekDate);

    int count = 0;

    for (int i = 0; i < 7; i++) {
      final date = monday.add(
        Duration(days: i),
      );

      if (AttendanceService.isPresent(
        date,
      )) {
        count++;
      }
    }

    return count;
  }

  static int remainingDays(
    DateTime weekDate,
  ) {
    final today = _dateOnly(
      DateTime.now(),
    );

    final monday =
        _mondayOfWeek(weekDate);

    int count = 0;

    for (int i = 0; i < 7; i++) {
      final date = monday.add(
        Duration(days: i),
      );

      if (date.isAfter(today)) {
        count++;
      }
    }

    return count;
  }

  static double percentage(
    DateTime weekDate,
  ) {
    return attendanceDays(
          weekDate,
        ) /
        7;
  }

  static bool isDayComplete(
    DateTime date,
  ) {
    return AttendanceService.isPresent(
      date,
    );
  }
}