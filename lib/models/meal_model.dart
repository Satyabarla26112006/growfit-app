import 'food_model.dart';

enum MealType {
  breakfast,
  morningSnack,
  lunch,
  eveningSnack,
  dinner,
  other,
}

class MealItem {
  final FoodModel food;
  final double quantity;

  const MealItem({
    required this.food,
    required this.quantity,
  });

  double get calories => food.caloriesFor(quantity);

  double get protein => food.proteinFor(quantity);

  double get carbs => food.carbsFor(quantity);

  double get fats => food.fatsFor(quantity);

  double get fiber => food.fiberFor(quantity);

  Map<String, dynamic> toJson() {
    return {
      'food': food.toJson(),
      'quantity': quantity,
    };
  }

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      food: FoodModel.fromJson(
        Map<String, dynamic>.from(json['food']),
      ),
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
    );
  }
}

class MealModel {
  final String id;
  final MealType type;
  final DateTime date;
  final List<MealItem> items;

  const MealModel({
    required this.id,
    required this.type,
    required this.date,
    this.items = const [],
  });

  // ============================================================
  // TOTALS
  // ============================================================

  double get totalCalories {
    return items.fold(
      0,
      (total, item) => total + item.calories,
    );
  }

  double get totalProtein {
    return items.fold(
      0,
      (total, item) => total + item.protein,
    );
  }

  double get totalCarbs {
    return items.fold(
      0,
      (total, item) => total + item.carbs,
    );
  }

  double get totalFats {
    return items.fold(
      0,
      (total, item) => total + item.fats,
    );
  }

  double get totalFiber {
    return items.fold(
      0,
      (total, item) => total + item.fiber,
    );
  }

  String get mealName {
    switch (type) {
      case MealType.breakfast:
        return 'Breakfast';

      case MealType.morningSnack:
        return 'Morning Snack';

      case MealType.lunch:
        return 'Lunch';

      case MealType.eveningSnack:
        return 'Evening Snack';

      case MealType.dinner:
        return 'Dinner';

      case MealType.other:
        return 'Other';
    }
  }

  // ============================================================
  // COPY
  // ============================================================

  MealModel copyWith({
    String? id,
    MealType? type,
    DateTime? date,
    List<MealItem>? items,
  }) {
    return MealModel(
      id: id ?? this.id,
      type: type ?? this.type,
      date: date ?? this.date,
      items: items ?? this.items,
    );
  }

  // ============================================================
  // JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory MealModel.fromJson(Map<String, dynamic> json) {
    final typeValue = json['type'] as String? ?? 'other';

    final type = MealType.values.firstWhere(
      (value) => value.name == typeValue,
      orElse: () => MealType.other,
    );

    return MealModel(
      id: json['id'] as String? ?? '',
      type: type,
      date: DateTime.tryParse(
            json['date'] as String? ?? '',
          ) ??
          DateTime.now(),
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (item) => MealItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }
}