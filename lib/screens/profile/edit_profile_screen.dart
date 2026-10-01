import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/calorie_service.dart';
import '../../services/user_service.dart';
import '../../theme/app_colors.dart';
import '../onboarding/activity_level_screen.dart';
import '../onboarding/goals_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  UserModel? _user;

  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _currentWeightController;
  late final TextEditingController _goalWeightController;

  FitnessGoal? _selectedGoal;
  ActivityLevel? _selectedActivityLevel;
  WeeklyTarget? _selectedWeeklyTarget;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _heightController = TextEditingController();
    _currentWeightController = TextEditingController();
    _goalWeightController = TextEditingController();

    _loadUser();
  }

  // ============================================================
  // LOAD USER
  // ============================================================

  void _loadUser() {
    final user = UserService.getUser();

    _user = user;

    if (user == null) {
      return;
    }

    _nameController.text = user.name;
    _ageController.text = user.age.toString();
    _heightController.text = user.height.toString();
    _currentWeightController.text =
        user.currentWeight.toString();
    _goalWeightController.text =
        user.goalWeight.toString();

    _selectedGoal = user.goal;
    _selectedActivityLevel = user.activityLevel;
    _selectedWeeklyTarget = user.weeklyTarget;
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _currentWeightController.dispose();
    _goalWeightController.dispose();

    super.dispose();
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> _save() async {
    if (_saving) {
      return;
    }

    final user = _user;

    if (user == null) {
      return;
    }

    final name = _nameController.text.trim();

    final age = int.tryParse(
      _ageController.text.trim(),
    );

    final height = double.tryParse(
      _heightController.text.trim(),
    );

    final currentWeight = double.tryParse(
      _currentWeightController.text.trim(),
    );

    final goalWeight = double.tryParse(
      _goalWeightController.text.trim(),
    );

    if (name.isEmpty) {
      _showMessage(
        'Please enter your name.',
      );
      return;
    }

    if (age == null || age <= 0) {
      _showMessage(
        'Please enter a valid age.',
      );
      return;
    }

    if (height == null || height <= 0) {
      _showMessage(
        'Please enter a valid height.',
      );
      return;
    }

    if (currentWeight == null ||
        currentWeight <= 0) {
      _showMessage(
        'Please enter a valid current weight.',
      );
      return;
    }

    if (goalWeight == null || goalWeight <= 0) {
      _showMessage(
        'Please enter a valid goal weight.',
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final selectedGoal =
          _selectedGoal ?? user.goal;

      final selectedActivityLevel =
          _selectedActivityLevel ??
              user.activityLevel;

      // ----------------------------------------------------------
      // RECALCULATE NUTRITION TARGETS
      // ----------------------------------------------------------

      final nutritionTargets =
          CalorieService.calculateNutritionTargets(
        weight: currentWeight,
        height: height,
        age: age,
        isMale: true,
        activityLevel:
            _convertActivityLevel(
          selectedActivityLevel,
        ),
        goal: _convertGoal(
          selectedGoal,
        ),
      );

      // ----------------------------------------------------------
      // UPDATE USER
      // ----------------------------------------------------------

      final updatedUser = user.copyWith(
        name: name,
        age: age,
        height: height,
        currentWeight: currentWeight,
        goalWeight: goalWeight,
        goal: selectedGoal,
        activityLevel: selectedActivityLevel,
        weeklyTarget:
            _selectedWeeklyTarget ??
                user.weeklyTarget,

        targetCalories:
            nutritionTargets.calories,
        targetProtein:
            nutritionTargets.protein,
        targetCarbs:
            nutritionTargets.carbohydrates,
        targetFats:
            nutritionTargets.fats,

        updatedAt: DateTime.now(),
      );

      await UserService.updateUser(
        updatedUser,
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(
        context,
        true,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _saving = false;
      });

      _showMessage(
        'Could not save your profile. Please try again.',
      );
    }
  }

  // ============================================================
  // ENUM CONVERSION
  // ============================================================

  GrowFitGoal _convertGoal(
    FitnessGoal goal,
  ) {
    return GrowFitGoal.values.firstWhere(
      (item) => item.name == goal.name,
      orElse: () =>
          GrowFitGoal.maintainWeight,
    );
  }

  GrowFitActivityLevel _convertActivityLevel(
    ActivityLevel level,
  ) {
    return GrowFitActivityLevel.values.firstWhere(
      (item) => item.name == level.name,
      orElse: () =>
          GrowFitActivityLevel.moderatelyActive,
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    if (_user == null) {
      return Scaffold(
        backgroundColor:
            AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
          ),
        ),
        body: const Center(
          child: Text(
            'No user profile found.',
            style: TextStyle(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          AppColors.background,
      appBar: AppBar(
        backgroundColor:
            AppColors.background,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics:
              const BouncingScrollPhysics(),
          padding:
              const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),
          children: [
            // ------------------------------------------------------
            // PERSONAL INFORMATION
            // ------------------------------------------------------

            _sectionTitle(
              'Personal Information',
            ),

            const SizedBox(
              height: 12,
            ),

            _textField(
              controller:
                  _nameController,
              label: 'Name',
              icon:
                  Icons.person_outline_rounded,
              keyboardType:
                  TextInputType.name,
            ),

            const SizedBox(
              height: 12,
            ),

            _textField(
              controller:
                  _ageController,
              label: 'Age',
              icon:
                  Icons.cake_outlined,
              keyboardType:
                  TextInputType.number,
            ),

            const SizedBox(
              height: 12,
            ),

            _textField(
              controller:
                  _heightController,
              label: 'Height (cm)',
              icon:
                  Icons.height_rounded,
              keyboardType:
                  const TextInputType
                      .numberWithOptions(
                decimal: true,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            // ------------------------------------------------------
            // WEIGHT
            // ------------------------------------------------------

            _sectionTitle(
              'Weight',
            ),

            const SizedBox(
              height: 12,
            ),

            _textField(
              controller:
                  _currentWeightController,
              label:
                  'Current Weight (kg)',
              icon:
                  Icons
                      .monitor_weight_rounded,
              keyboardType:
                  const TextInputType
                      .numberWithOptions(
                decimal: true,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            _textField(
              controller:
                  _goalWeightController,
              label:
                  'Goal Weight (kg)',
              icon:
                  Icons.flag_rounded,
              keyboardType:
                  const TextInputType
                      .numberWithOptions(
                decimal: true,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            // ------------------------------------------------------
            // GOAL
            // ------------------------------------------------------

            _sectionTitle(
              'Goal',
            ),

            const SizedBox(
              height: 12,
            ),

            _dropdownCard<FitnessGoal>(
              label:
                  'Fitness Goal',
              value:
                  _selectedGoal,
              items:
                  FitnessGoal.values,
              itemLabel:
                  _goalName,
              onChanged:
                  (value) {
                setState(() {
                  _selectedGoal =
                      value;
                });
              },
            ),

            const SizedBox(
              height: 12,
            ),

            _dropdownCard<WeeklyTarget>(
              label:
                  'Weekly Target',
              value:
                  _selectedWeeklyTarget,
              items:
                  WeeklyTarget.values,
              itemLabel:
                  (value) {
                switch (value) {
                  case WeeklyTarget
                      .zeroPoint25Kg:
                    return '0.25 kg per week';

                  case WeeklyTarget
                      .zeroPoint5Kg:
                    return '0.50 kg per week';

                  case WeeklyTarget.custom:
                    return 'Custom';
                }
              },
              onChanged:
                  (value) {
                setState(() {
                  _selectedWeeklyTarget =
                      value;
                });
              },
            ),

            const SizedBox(
              height: 12,
            ),

            _dropdownCard<ActivityLevel>(
              label:
                  'Activity Level',
              value:
                  _selectedActivityLevel,
              items:
                  ActivityLevel.values,
              itemLabel:
                  _activityName,
              onChanged:
                  (value) {
                setState(() {
                  _selectedActivityLevel =
                      value;
                });
              },
            ),

            const SizedBox(
              height: 30,
            ),

            // ------------------------------------------------------
            // SAVE BUTTON
            // ------------------------------------------------------

            SizedBox(
              width: double.infinity,
              height: 56,
              child:
                  ElevatedButton(
                onPressed:
                    _saving
                        ? null
                        : _save,
                child: _saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                            CircularProgressIndicator(
                          strokeWidth:
                              2.5,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(
    String title,
  ) {
    return Text(
      title,
      style: const TextStyle(
        color:
            AppColors.textPrimary,
        fontSize: 19,
        fontWeight:
            FontWeight.w800,
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _textField({
    required TextEditingController
        controller,
    required String label,
    required IconData icon,
    required TextInputType
        keyboardType,
  }) {
    return TextField(
      controller:
          controller,
      enabled: !_saving,
      keyboardType:
          keyboardType,
      style:
          const TextStyle(
        color: Colors.white,
      ),
      decoration:
          InputDecoration(
        labelText:
            label,
        labelStyle:
            const TextStyle(
          color:
              Color(0xFF94A3B8),
        ),
        prefixIcon:
            Icon(
          icon,
          color:
              AppColors.primary,
        ),
        filled: true,
        fillColor:
            const Color(
          0xFF081226,
        ),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            16,
          ),
          borderSide:
              BorderSide.none,
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            16,
          ),
          borderSide:
              BorderSide(
            color:
                const Color(
              0xFF334155,
            ).withValues(
              alpha: 0.5,
            ),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            16,
          ),
          borderSide:
              const BorderSide(
            color:
                AppColors.primary,
            width: 1.4,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DROPDOWN
  // ============================================================

  Widget _dropdownCard<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T)
        itemLabel,
    required ValueChanged<T?>
        onChanged,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 3,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFF081226,
        ),
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        border:
            Border.all(
          color:
              const Color(
            0xFF334155,
          ).withValues(
            alpha: 0.5,
          ),
        ),
      ),
      child:
          DropdownButtonHideUnderline(
        child:
            DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor:
              const Color(
            0xFF081226,
          ),
          icon:
              const Icon(
            Icons
                .keyboard_arrow_down_rounded,
            color:
                Color(
              0xFF94A3B8,
            ),
          ),
          style:
              const TextStyle(
            color:
                Colors.white,
            fontSize: 14,
            fontWeight:
                FontWeight.w600,
          ),
          hint:
              Text(
            label,
            style:
                const TextStyle(
              color:
                  Color(
                0xFF94A3B8,
              ),
              fontSize: 14,
            ),
          ),
          items:
              items.map(
            (item) {
              return DropdownMenuItem<T>(
                value: item,
                child:
                    Text(
                  itemLabel(
                    item,
                  ),
                ),
              );
            },
          ).toList(),
          onChanged:
              _saving
                  ? null
                  : onChanged,
        ),
      ),
    );
  }

  // ============================================================
  // GOAL NAME
  // ============================================================

  String _goalName(
    FitnessGoal goal,
  ) {
    switch (goal) {
      case FitnessGoal.loseWeight:
        return 'Lose Weight';

      case FitnessGoal.gainWeight:
        return 'Gain Weight';

      case FitnessGoal.gainMuscle:
        return 'Gain Muscle';

      case FitnessGoal.maintainWeight:
        return 'Maintain Weight';

      case FitnessGoal.improveFitness:
        return 'Improve Fitness';
    }
  }

  // ============================================================
  // ACTIVITY NAME
  // ============================================================

  String _activityName(
    ActivityLevel level,
  ) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Sedentary';

      case ActivityLevel.lightlyActive:
        return 'Lightly Active';

      case ActivityLevel.moderatelyActive:
        return 'Moderately Active';

      case ActivityLevel.veryActive:
        return 'Very Active';

      case ActivityLevel.extremelyActive:
        return 'Extremely Active';
    }
  }
}