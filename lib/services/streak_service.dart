import 'attendance_service.dart';

class StreakService {
  StreakService._();

  static int current() {
    return AttendanceService.currentStreak;
  }

  static int best() {
    return AttendanceService.longestStreak;
  }

  static int totalDays() {
    return AttendanceService.attendanceCount;
  }

  static bool activeToday() {
    return AttendanceService.isPresent(
      DateTime.now(),
    );
  }
}