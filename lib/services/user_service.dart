import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import 'storage_service.dart';

class UserService {
  UserService._();

  static SupabaseClient get _supabase =>
      Supabase.instance.client;

  // ============================================================
  // ENSURE AUTH USER
  // ============================================================

  static Future<User> _ensureAuthenticatedUser() async {
    final existingUser = _supabase.auth.currentUser;

    debugPrint(
      'SUPABASE AUTH CURRENT USER: ${existingUser?.id}',
    );

    if (existingUser != null) {
      return existingUser;
    }

    debugPrint(
      'SUPABASE AUTH: Creating anonymous user...',
    );

    try {
      final response =
          await _supabase.auth.signInAnonymously();

      final user = response.user;

      debugPrint(
        'SUPABASE AUTH: Created user: ${user?.id}',
      );

      if (user == null) {
        throw Exception(
          'Supabase returned no user.',
        );
      }

      return user;
    } on AuthException catch (e) {
      debugPrint(
        'SUPABASE AUTH ERROR: '
        'message=${e.message}, '
        'statusCode=${e.statusCode}',
      );
      rethrow;
    } catch (e) {
      debugPrint(
        'SUPABASE AUTH UNKNOWN ERROR: $e',
      );
      rethrow;
    }
  }

  // ============================================================
  // NORMALIZE LOCAL PROFILE
  // ============================================================

  static Map<String, dynamic>? _normalizeLocalProfile(
    Map<String, dynamic>? source,
  ) {
    if (source == null) {
      return null;
    }

    final data = Map<String, dynamic>.from(source);

    // ----------------------------------------------------------
    // SUBSCRIPTION COMPATIBILITY
    //
    // Older versions could store:
    //   "Free"
    //   "Plus"
    //   "Pro"
    //
    // Current UserModel expects a JSON object.
    // ----------------------------------------------------------

    final subscription = data['subscription'];

    if (subscription is String) {
      final value = subscription.trim().toLowerCase();

      String plan;

      switch (value) {
        case 'plus':
          plan = 'plus';
          break;

        case 'pro':
          plan = 'pro';
          break;

        case 'free':
        default:
          plan = 'free';
          break;
      }

      data['subscription'] = <String, dynamic>{
        'plan': plan,
        'isActive': true,
        'startDate': null,
        'expiryDate': null,
        'autoRenew': false,
        'purchaseId': null,
        'platform': null,
      };
    } else if (subscription == null) {
      data['subscription'] = <String, dynamic>{
        'plan': 'free',
        'isActive': true,
        'startDate': null,
        'expiryDate': null,
        'autoRenew': false,
        'purchaseId': null,
        'platform': null,
      };
    } else if (subscription is Map) {
      data['subscription'] =
          Map<String, dynamic>.from(subscription);
    }

    return data;
  }

  // ============================================================
  // SAVE USER
  // ============================================================

  static Future<void> saveUser(
    UserModel user,
  ) async {
    try {
      debugPrint(
        'SUPABASE SAVE: Starting...',
      );

      final authUser =
          await _ensureAuthenticatedUser();

      // --------------------------------------------------------
      // USE SUPABASE AUTH UID AS PROFILE ID
      // --------------------------------------------------------

      final syncedUser = user.copyWith(
        id: authUser.id,
      );

      debugPrint(
        'SUPABASE SAVE: profile id = '
        '${syncedUser.id}',
      );

      // --------------------------------------------------------
      // LOCAL STORAGE
      // --------------------------------------------------------

      await StorageService.saveUserProfile(
        syncedUser.toJson(),
      );

      // --------------------------------------------------------
      // PROFILE DATA
      // --------------------------------------------------------

      final profileData = <String, dynamic>{
        'id': authUser.id,
        'name': syncedUser.name,
        'age': syncedUser.age,
        'height': syncedUser.height,
        'current_weight':
            syncedUser.currentWeight,
        'goal_weight':
            syncedUser.goalWeight,
        'goal':
            syncedUser.goal.name,
        'weekly_target':
            syncedUser.weeklyTarget.name,
        'activity_level':
            syncedUser.activityLevel.name,
        'habits':
            syncedUser.habits,
        'nutrition_preferences':
            syncedUser.nutritionPreferences,
        'target_calories':
            syncedUser.targetCalories,
        'target_protein':
            syncedUser.targetProtein,
        'target_carbs':
            syncedUser.targetCarbs,
        'target_fats':
            syncedUser.targetFats,

        // Keep database representation as it is currently
        // expected by the existing profiles table.
        'subscription': syncedUser.subscription.planName,

        'created_at':
            syncedUser.createdAt.toIso8601String(),
        'updated_at':
            (syncedUser.updatedAt ??
                    syncedUser.createdAt)
                .toIso8601String(),
      };

      debugPrint(
        'SUPABASE SAVE DATA: $profileData',
      );

      // --------------------------------------------------------
      // UPSERT
      // --------------------------------------------------------

      debugPrint(
        'SUPABASE SAVE: Sending upsert...',
      );

      final result = await _supabase
          .from('profiles')
          .upsert(
            profileData,
            onConflict: 'id',
          )
          .select();

      debugPrint(
        'SUPABASE SAVE SUCCESS: $result',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        '==============================',
      );
      debugPrint(
        'SUPABASE DATABASE ERROR',
      );
      debugPrint(
        'message: ${e.message}',
      );
      debugPrint(
        'code: ${e.code}',
      );
      debugPrint(
        'details: ${e.details}',
      );
      debugPrint(
        'hint: ${e.hint}',
      );
      debugPrint(
        '==============================',
      );

      rethrow;
    } on AuthException catch (e) {
      debugPrint(
        '==============================',
      );
      debugPrint(
        'SUPABASE AUTH ERROR',
      );
      debugPrint(
        'message: ${e.message}',
      );
      debugPrint(
        'statusCode: ${e.statusCode}',
      );
      debugPrint(
        '==============================',
      );

      rethrow;
    } catch (e, stackTrace) {
      debugPrint(
        '==============================',
      );
      debugPrint(
        'SUPABASE UNKNOWN ERROR',
      );
      debugPrint(
        '$e',
      );
      debugPrint(
        '$stackTrace',
      );
      debugPrint(
        '==============================',
      );

      rethrow;
    }
  }

  // ============================================================
  // LOAD USER FROM LOCAL STORAGE
  // ============================================================

  static UserModel? getUser() {
    final rawData =
        StorageService.getUserProfile();

    if (rawData == null) {
      return null;
    }

    try {
      final data = _normalizeLocalProfile(
        Map<String, dynamic>.from(rawData),
      );

      if (data == null) {
        return null;
      }

      final parsedUser =
          UserModel.fromJson(data);

      // Save the normalized representation so the legacy
      // subscription format is repaired permanently.
      StorageService.saveUserProfile(
        parsedUser.toJson(),
      );

      return parsedUser;
    } catch (e, stackTrace) {
      debugPrint(
        'LOCAL USER LOAD ERROR: $e',
      );
      debugPrint(
        '$stackTrace',
      );
      return null;
    }
  }

  // ============================================================
  // LOAD USER FROM SUPABASE
  // ============================================================

  static Future<UserModel?> loadUserFromSupabase() async {
    try {
      final authUser =
          _supabase.auth.currentUser;

      if (authUser == null) {
        debugPrint(
          'SUPABASE LOAD: No authenticated user.',
        );
        return null;
      }

      debugPrint(
        'SUPABASE LOAD: Loading profile '
        '${authUser.id}...',
      );

      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', authUser.id)
          .maybeSingle();

      if (response == null) {
        debugPrint(
          'SUPABASE LOAD: Profile not found.',
        );
        return null;
      }

      debugPrint(
        'SUPABASE LOAD SUCCESS: $response',
      );

      // --------------------------------------------------------
      // START FROM EXISTING LOCAL JSON
      // --------------------------------------------------------

      final existingUser = getUser();

      final localJson =
          existingUser?.toJson() ??
              <String, dynamic>{};

      // --------------------------------------------------------
      // MERGE SUPABASE VALUES INTO LOCAL JSON
      // --------------------------------------------------------

      localJson['id'] =
          response['id'] ?? authUser.id;

      localJson['name'] =
          response['name'];

      localJson['age'] =
          response['age'];

      localJson['height'] =
          (response['height'] as num?)
              ?.toDouble();

      localJson['currentWeight'] =
          (response['current_weight'] as num?)
              ?.toDouble();

      localJson['goalWeight'] =
          (response['goal_weight'] as num?)
              ?.toDouble();

      final goalValue =
          response['goal'] as String?;

      if (goalValue != null &&
          goalValue.isNotEmpty) {
        localJson['goal'] = goalValue;
      }

      final weeklyTargetValue =
          response['weekly_target'] as String?;

      if (weeklyTargetValue != null &&
          weeklyTargetValue.isNotEmpty) {
        localJson['weeklyTarget'] =
            weeklyTargetValue;
      }

      final activityLevelValue =
          response['activity_level'] as String?;

      if (activityLevelValue != null &&
          activityLevelValue.isNotEmpty) {
        localJson['activityLevel'] =
            activityLevelValue;
      }

      // --------------------------------------------------------
      // JSONB ARRAYS
      // --------------------------------------------------------

      final habits =
          response['habits'];

      if (habits is List) {
        localJson['habits'] =
            List<String>.from(habits);
      }

      final nutritionPreferences =
          response['nutrition_preferences'];

      if (nutritionPreferences is List) {
        localJson['nutritionPreferences'] =
            List<String>.from(
          nutritionPreferences,
        );
      }

      // --------------------------------------------------------
      // NUTRITION TARGETS
      // --------------------------------------------------------

      localJson['targetCalories'] =
          (response['target_calories'] as num?)
              ?.toDouble();

      localJson['targetProtein'] =
          (response['target_protein'] as num?)
              ?.toDouble();

      localJson['targetCarbs'] =
          (response['target_carbs'] as num?)
              ?.toDouble();

      localJson['targetFats'] =
          (response['target_fats'] as num?)
              ?.toDouble();

      // --------------------------------------------------------
      // SUBSCRIPTION
      // --------------------------------------------------------
      //
      // Database stores this as "Free", "Plus", or "Pro".
      // Convert it into the JSON structure expected by
      // UserModel before parsing.
      // --------------------------------------------------------

      final databaseSubscription =
          response['subscription'];

      if (databaseSubscription is String) {
        final value =
            databaseSubscription
                .trim()
                .toLowerCase();

        final normalizedPlan =
            value == 'plus'
                ? 'plus'
                : value == 'pro'
                    ? 'pro'
                    : 'free';

        localJson['subscription'] =
            <String, dynamic>{
          'plan': normalizedPlan,
          'isActive': true,
          'startDate': null,
          'expiryDate': null,
          'autoRenew': false,
          'purchaseId': null,
          'platform': null,
        };
      }

      // --------------------------------------------------------
      // DATES
      // --------------------------------------------------------

      final createdAt =
          response['created_at'] as String?;

      if (createdAt != null &&
          createdAt.isNotEmpty) {
        localJson['createdAt'] =
            createdAt;
      }

      final updatedAt =
          response['updated_at'] as String?;

      if (updatedAt != null &&
          updatedAt.isNotEmpty) {
        localJson['updatedAt'] =
            updatedAt;
      }

      // --------------------------------------------------------
      // NORMALIZE BEFORE MODEL PARSING
      // --------------------------------------------------------

      final normalizedJson =
          _normalizeLocalProfile(localJson);

      if (normalizedJson == null) {
        return null;
      }

      // --------------------------------------------------------
      // BUILD USER MODEL
      // --------------------------------------------------------

      final syncedUser =
          UserModel.fromJson(
        normalizedJson,
      );

      // --------------------------------------------------------
      // UPDATE LOCAL CACHE
      // --------------------------------------------------------

      await StorageService.saveUserProfile(
        syncedUser.toJson(),
      );

      debugPrint(
        'LOCAL USER UPDATED FROM SUPABASE',
      );

      return syncedUser;
    } on PostgrestException catch (e) {
      debugPrint(
        'SUPABASE LOAD DATABASE ERROR: '
        '${e.message}',
      );
      debugPrint(
        'code: ${e.code}',
      );
      debugPrint(
        'details: ${e.details}',
      );
      debugPrint(
        'hint: ${e.hint}',
      );
      return null;
    } catch (e, stackTrace) {
      debugPrint(
        'SUPABASE LOAD ERROR: $e',
      );
      debugPrint(
        '$stackTrace',
      );
      return null;
    }
  }

  // ============================================================
  // USER EXISTS
  // ============================================================

  static bool get hasUser {
    return getUser() != null;
  }

  // ============================================================
  // CLEAR USER
  // ============================================================

  static Future<void> clearUser() async {
    await StorageService.clearUserProfile();
  }

  // ============================================================
  // UPDATE USER
  // ============================================================

  static Future<void> updateUser(
    UserModel user,
  ) async {
    await saveUser(user);
  }
}