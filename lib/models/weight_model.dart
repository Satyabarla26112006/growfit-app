class WeightEntry {
  final String id;
  final double weight;
  final DateTime date;

  const WeightEntry({
    required this.id,
    required this.weight,
    required this.date,
  });

  // ============================================================
  // COPY WITH
  // ============================================================

  WeightEntry copyWith({
    String? id,
    double? weight,
    DateTime? date,
  }) {
    return WeightEntry(
      id: id ?? this.id,
      weight: weight ?? this.weight,
      date: date ?? this.date,
    );
  }

  // ============================================================
  // JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weight': weight,
      'date': date.toIso8601String(),
    };
  }

  factory WeightEntry.fromJson(
    Map<String, dynamic> json,
  ) {
    return WeightEntry(
      id: json['id'] as String? ?? '',
      weight:
          (json['weight'] as num?)?.toDouble() ?? 0,
      date: DateTime.tryParse(
            json['date'] as String? ?? '',
          ) ??
          DateTime.now(),
    );
  }
}