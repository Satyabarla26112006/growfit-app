enum SubscriptionPlan {
  free,
  plus,
  pro,
}

class SubscriptionModel {
  final SubscriptionPlan plan;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? expiryDate;
  final bool autoRenew;
  final String? purchaseId;
  final String? platform;

  const SubscriptionModel({
    this.plan = SubscriptionPlan.free,
    this.isActive = true,
    this.startDate,
    this.expiryDate,
    this.autoRenew = false,
    this.purchaseId,
    this.platform,
  });

  // ============================================================
  // PLAN CHECKS
  // ============================================================

  bool get isFree => plan == SubscriptionPlan.free;

  bool get isPlus => plan == SubscriptionPlan.plus;

  bool get isPro => plan == SubscriptionPlan.pro;

  // ============================================================
  // PLAN NAME
  // ============================================================

  String get planName {
    switch (plan) {
      case SubscriptionPlan.free:
        return 'Free';
      case SubscriptionPlan.plus:
        return 'Plus';
      case SubscriptionPlan.pro:
        return 'Pro';
    }
  }

  // ============================================================
  // PLAN ACCESS
  // ============================================================

  bool get hasPlusAccess {
    return isActive &&
        (plan == SubscriptionPlan.plus || plan == SubscriptionPlan.pro);
  }

  bool get hasProAccess {
    return isActive && plan == SubscriptionPlan.pro;
  }

  // ============================================================
  // EXPIRY
  // ============================================================

  bool get isExpired {
    if (expiryDate == null) {
      return false;
    }

    return DateTime.now().isAfter(expiryDate!);
  }

  bool get hasValidSubscription {
    if (plan == SubscriptionPlan.free) {
      return true;
    }

    return isActive && !isExpired;
  }

  // ============================================================
  // COPY WITH
  // ============================================================

  SubscriptionModel copyWith({
    SubscriptionPlan? plan,
    bool? isActive,
    DateTime? startDate,
    DateTime? expiryDate,
    bool? autoRenew,
    String? purchaseId,
    String? platform,
  }) {
    return SubscriptionModel(
      plan: plan ?? this.plan,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      expiryDate: expiryDate ?? this.expiryDate,
      autoRenew: autoRenew ?? this.autoRenew,
      purchaseId: purchaseId ?? this.purchaseId,
      platform: platform ?? this.platform,
    );
  }

  // ============================================================
  // JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'plan': plan.name,
      'isActive': isActive,
      'startDate': startDate?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'autoRenew': autoRenew,
      'purchaseId': purchaseId,
      'platform': platform,
    };
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    final planValue = json['plan'] as String? ?? 'free';

    final plan = SubscriptionPlan.values.firstWhere(
      (value) => value.name == planValue,
      orElse: () => SubscriptionPlan.free,
    );

    return SubscriptionModel(
      plan: plan,
      isActive: json['isActive'] as bool? ?? true,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String)
          : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'] as String)
          : null,
      autoRenew: json['autoRenew'] as bool? ?? false,
      purchaseId: json['purchaseId'] as String?,
      platform: json['platform'] as String?,
    );
  }
}