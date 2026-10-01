import 'attendance_service.dart';
import 'daily_history_service.dart';

class CalendarStatsService {
  CalendarStatsService._();

  static int attendedDays(
    DateTime month,
  ) {
    int count = 0;

    final days =
        DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;

    for (int day = 1;
        day <= days;
        day++) {
      final date = DateTime(
        month.year,
        month.month,
        day,
      );

      if (AttendanceService.isPresent(
        date,
      )) {
        count++;
      }
    }

    return count;
  }

  static int foodDays(
    DateTime month,
  ) {
    int count = 0;

    final days =
        DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;

    for (int day = 1;
        day <= days;
        day++) {
      final date = DateTime(
        month.year,
        month.month,
        day,
      );

      if (DailyHistoryService
          .hasFoodForDate(date)) {
        count++;
      }
    }

    return count;
  }

  static int activityDays(
    DateTime month,
  ) {
    int count = 0;

    final days =
        DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;

    for (int day = 1;
        day <= days;
        day++) {
      final date = DateTime(
        month.year,
        month.month,
        day,
      );

      if (AttendanceService.isPresent(
            date,
          ) ||
          DailyHistoryService
              .hasFoodForDate(date)) {
        count++;
      }
    }

    return count;
  }

  static double attendancePercentage(
    DateTime month,
  ) {
    final days =
        DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;

    if (days == 0) {
      return 0;
    }

    return attendedDays(month) /
        days;
  }
}