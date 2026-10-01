import '../models/subscription_model.dart';
import '../models/user_model.dart';
import 'user_service.dart';

class SubscriptionService {
  SubscriptionService._();

  static SubscriptionModel _subscription =
      const SubscriptionModel();

  // ============================================================
  // CURRENT SUBSCRIPTION
  // ============================================================

  static SubscriptionModel get currentSubscription {
    final user = UserService.getUser();

    if (user != null) {
      _subscription = user.subscription;
    }

    return _subscription;
  }

  // ============================================================
  // SYNC WITH USER
  // ============================================================

  static void syncFromUser(UserModel user) {
    _subscription = user.subscription;
  }

  // ============================================================
  // SET SUBSCRIPTION
  // ============================================================

  static void setSubscription(
    SubscriptionModel subscription,
  ) {
    _subscription = subscription;
  }

  // ============================================================
  // PLAN CHECKS
  // ============================================================

  static bool get isFree {
    return currentSubscription.isFree;
  }

  static bool get isPlus {
    return currentSubscription.isPlus;
  }

  static bool get isPro {
    return currentSubscription.isPro;
  }

  static bool get hasPlusAccess {
    return currentSubscription.hasPlusAccess;
  }

  static bool get hasProAccess {
    return currentSubscription.hasProAccess;
  }

  // ============================================================
  // FEATURE ACCESS
  // ============================================================

  static bool canAccess(String feature) {
    switch (feature) {
      // --------------------------------------------------------
      // FREE FEATURES
      // --------------------------------------------------------

      case 'basic_food_tracking':
      case 'basic_calorie_tracking':
      case 'basic_workouts':
      case 'basic_progress':
      case 'basic_recipes':
        return true;

      // --------------------------------------------------------
      // PLUS FEATURES
      // --------------------------------------------------------

      case 'advanced_recipes':
      case 'diet_plans':
      case 'advanced_progress':
      case 'advanced_workouts':
        return hasPlusAccess;

      // --------------------------------------------------------
      // PRO FEATURES
      // --------------------------------------------------------

      case 'mini_ai':
      case 'personalized_ai':
      case 'advanced_nutrition':
      case 'personalized_diet':
      case 'advanced_analytics':
        return hasProAccess;

      default:
        return false;
    }
  }

  // ============================================================
  // UPGRADE REQUIRED
  // ============================================================

  static SubscriptionPlan? requiredPlan(
    String feature,
  ) {
    switch (feature) {
      case 'basic_food_tracking':
      case 'basic_calorie_tracking':
      case 'basic_workouts':
      case 'basic_progress':
      case 'basic_recipes':
        return null;

      case 'advanced_recipes':
      case 'diet_plans':
      case 'advanced_progress':
      case 'advanced_workouts':
        return SubscriptionPlan.plus;

      case 'mini_ai':
      case 'personalized_ai':
      case 'advanced_nutrition':
      case 'personalized_diet':
      case 'advanced_analytics':
        return SubscriptionPlan.pro;

      default:
        return SubscriptionPlan.pro;
    }
  }

  // ============================================================
  // PLAN COMPARISON
  // ============================================================

  static int planLevel(
    SubscriptionPlan plan,
  ) {
    switch (plan) {
      case SubscriptionPlan.free:
        return 0;

      case SubscriptionPlan.plus:
        return 1;

      case SubscriptionPlan.pro:
        return 2;
    }
  }

  static bool isPlanAtLeast(
    SubscriptionPlan requiredPlan,
  ) {
    return planLevel(currentSubscription.plan) >=
        planLevel(requiredPlan);
  }

  // ============================================================
  // UPDATE USER SUBSCRIPTION
  // ============================================================

  static Future<void> _saveSubscription(
    SubscriptionModel subscription,
  ) async {
    final user = UserService.getUser();

    if (user == null) {
      throw StateError(
        'Cannot update subscription because no user profile exists.',
      );
    }

    final updatedUser = user.copyWith(
      subscription: subscription,
      updatedAt: DateTime.now(),
    );

    await UserService.updateUser(updatedUser);

    _subscription = subscription;
  }

  // ============================================================
  // UPGRADE TO PLUS
  // ============================================================
  //
  // This method should only be called after the purchase has been
  // successfully verified by the app-store billing system.
  //

  static Future<void> upgradeToPlus({
    DateTime? startDate,
    DateTime? expiryDate,
    bool autoRenew = true,
    String? purchaseId,
    String? platform,
  }) async {
    final subscription = SubscriptionModel(
      plan: SubscriptionPlan.plus,
      isActive: true,
      startDate: startDate ?? DateTime.now(),
      expiryDate: expiryDate,
      autoRenew: autoRenew,
      purchaseId: purchaseId,
      platform: platform,
    );

    await _saveSubscription(subscription);
  }

  // ============================================================
  // UPGRADE TO PRO
  // ============================================================
  //
  // This method should only be called after the purchase has been
  // successfully verified by the app-store billing system.
  //

  static Future<void> upgradeToPro({
    DateTime? startDate,
    DateTime? expiryDate,
    bool autoRenew = true,
    String? purchaseId,
    String? platform,
  }) async {
    final subscription = SubscriptionModel(
      plan: SubscriptionPlan.pro,
      isActive: true,
      startDate: startDate ?? DateTime.now(),
      expiryDate: expiryDate,
      autoRenew: autoRenew,
      purchaseId: purchaseId,
      platform: platform,
    );

    await _saveSubscription(subscription);
  }

  // ============================================================
  // RESET TO FREE
  // ============================================================

  static Future<void> resetToFree() async {
    const subscription = SubscriptionModel(
      plan: SubscriptionPlan.free,
      isActive: true,
      autoRenew: false,
    );

    await _saveSubscription(subscription);
  }

  // ============================================================
  // EXPIRY CHECK
  // ============================================================

  static bool get isExpired {
    return currentSubscription.isExpired;
  }

  static bool get hasValidSubscription {
    return currentSubscription.hasValidSubscription;
  }
}