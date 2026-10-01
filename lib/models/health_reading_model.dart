import 'package:flutter/foundation.dart';

enum HealthReadingType {
  bloodPressure,
  bloodGlucose,
}

class HealthReadingModel {
  final String id;
  final DateTime recordedAt;
  final HealthReadingType type;

  // Blood pressure
  final double? systolic;
  final double? diastolic;

  // Blood glucose in mg/dL
  final double? glucoseMgDl;

  final String? note;

  const HealthReadingModel({
    required this.id,
    required this.recordedAt,
    required this.type,
    this.systolic,
    this.diastolic,
    this.glucoseMgDl,
    this.note,
  });

  HealthReadingModel copyWith({
    String? id,
    DateTime? recordedAt,
    HealthReadingType? type,
    double? systolic,
    double? diastolic,
    double? glucoseMgDl,
    String? note,
  }) {
    return HealthReadingModel(
      id: id ?? this.id,
      recordedAt: recordedAt ?? this.recordedAt,
      type: type ?? this.type,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      glucoseMgDl: glucoseMgDl ?? this.glucoseMgDl,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recordedAt': recordedAt.toIso8601String(),
      'type': type.name,
      'systolic': systolic,
      'diastolic': diastolic,
      'glucoseMgDl': glucoseMgDl,
      'note': note,
    };
  }

  factory HealthReadingModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return HealthReadingModel(
      id: json['id'] as String,
      recordedAt:
          DateTime.parse(json['recordedAt'] as String),
      type: HealthReadingType.values.byName(
        json['type'] as String,
      ),
      systolic: (json['systolic'] as num?)?.toDouble(),
      diastolic: (json['diastolic'] as num?)?.toDouble(),
      glucoseMgDl:
          (json['glucoseMgDl'] as num?)?.toDouble(),
      note: json['note'] as String?,
    );
  }

  @override
  String toString() {
    return 'HealthReadingModel('
        'id: $id, '
        'recordedAt: $recordedAt, '
        'type: $type, '
        'systolic: $systolic, '
        'diastolic: $diastolic, '
        'glucoseMgDl: $glucoseMgDl)';
  }

  @override
  bool operator ==(Object other) {
    return other is HealthReadingModel &&
        other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Simple UI classification for a recorded blood-pressure value.
/// This is a screening label, not a diagnosis.
@immutable
class BloodPressureClassification {
  final String label;
  final bool needsAttention;
  final bool urgent;

  const BloodPressureClassification({
    required this.label,
    required this.needsAttention,
    required this.urgent,
  });
}

/// Simple UI classification for a recorded glucose value.
/// The interpretation depends heavily on whether the reading is fasting,
/// pre-meal, post-meal, or random, so this model intentionally stays general.
@immutable
class BloodGlucoseClassification {
  final String label;
  final bool needsAttention;
  final bool urgent;

  const BloodGlucoseClassification({
    required this.label,
    required this.needsAttention,
    required this.urgent,
  });
}
