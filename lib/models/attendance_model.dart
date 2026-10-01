enum AttendanceType {
  gym,
  home,
  rest,
}

class AttendanceModel {
  final String id;
  final DateTime date;
  final AttendanceType type;
  final String? workoutId;
  final String? workoutName;
  final int workoutCount;
  final double caloriesBurned;
  final int durationSeconds;
  final bool manuallyMarked;
  final String? note;

  const AttendanceModel({
    required this.id,
    required this.date,
    required this.type,
    this.workoutId,
    this.workoutName,
    this.workoutCount = 0,
    this.caloriesBurned = 0,
    this.durationSeconds = 0,
    this.manuallyMarked = false,
    this.note,
  });

  AttendanceModel copyWith({
    String? id,
    DateTime? date,
    AttendanceType? type,
    String? workoutId,
    String? workoutName,
    int? workoutCount,
    double? caloriesBurned,
    int? durationSeconds,
    bool? manuallyMarked,
    String? note,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      workoutId: workoutId ?? this.workoutId,
      workoutName: workoutName ?? this.workoutName,
      workoutCount: workoutCount ?? this.workoutCount,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      manuallyMarked: manuallyMarked ?? this.manuallyMarked,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type.name,
      'workoutId': workoutId,
      'workoutName': workoutName,
      'workoutCount': workoutCount,
      'caloriesBurned': caloriesBurned,
      'durationSeconds': durationSeconds,
      'manuallyMarked': manuallyMarked,
      'note': note,
    };
  }

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    final rawType = json['type']?.toString();

    final type = AttendanceType.values.firstWhere(
      (value) => value.name == rawType,
      orElse: () => AttendanceType.rest,
    );

    return AttendanceModel(
      id: json['id']?.toString() ?? '',
      date: DateTime.tryParse(
            json['date']?.toString() ?? '',
          ) ??
          DateTime.now(),
      type: type,
      workoutId: json['workoutId']?.toString(),
      workoutName: json['workoutName']?.toString(),
      workoutCount:
          _toInt(json['workoutCount']),
      caloriesBurned:
          _toDouble(json['caloriesBurned']),
      durationSeconds:
          _toInt(json['durationSeconds']),
      manuallyMarked:
          json['manuallyMarked'] == true,
      note: json['note']?.toString(),
    );
  }

  String get typeLabel {
    switch (type) {
      case AttendanceType.gym:
        return 'Gym';
      case AttendanceType.home:
        return 'Home';
      case AttendanceType.rest:
        return 'Rest Day';
    }
  }

  bool get isWorkoutDay =>
      type == AttendanceType.gym ||
      type == AttendanceType.home;

  bool get isGymDay => type == AttendanceType.gym;

  bool get isHomeDay => type == AttendanceType.home;

  bool get isRestDay => type == AttendanceType.rest;

  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;

    if (minutes <= 0) {
      return '${seconds}s';
    }

    if (seconds == 0) {
      return '${minutes}m';
    }

    return '${minutes}m ${seconds}s';
  }

  @override
  String toString() {
    return 'AttendanceModel('
        'id: $id, '
        'date: $date, '
        'type: ${type.name}, '
        'workoutCount: $workoutCount, '
        'caloriesBurned: $caloriesBurned, '
        'durationSeconds: $durationSeconds'
        ')';
  }
}

int _toInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.round();
  }

  return int.tryParse(
        value?.toString() ?? '',
      ) ??
      0;
}

double _toDouble(dynamic value) {
  if (value is double) {
    return value;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(
        value?.toString() ?? '',
      ) ??
      0;
}
