import 'package:flutter/material.dart';

import 'goals_screen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({
    super.key,
  });

  @override
  State<PersonalDetailsScreen> createState() =>
      _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState
    extends State<PersonalDetailsScreen> {
  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _ageController =
      TextEditingController();

  final TextEditingController _heightController =
      TextEditingController();

  final TextEditingController _currentWeightController =
      TextEditingController();

  final TextEditingController _goalWeightController =
      TextEditingController();

  Color get _background =>
      Theme.of(context).scaffoldBackgroundColor;

  Color get _surface =>
      Theme.of(context).colorScheme.surface;

  Color get _primary =>
      Theme.of(context).colorScheme.primary;

  Color get _textPrimary =>
      Theme.of(context).colorScheme.onSurface;

  Color get _textSecondary =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  Color get _border =>
      Theme.of(context).colorScheme.outlineVariant;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _currentWeightController.dispose();
    _goalWeightController.dispose();

    super.dispose();
  }

  void _next() {
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
      _showError('Please enter your name.');
      return;
    }

    if (age == null || age <= 0) {
      _showError('Please enter a valid age.');
      return;
    }

    if (height == null || height <= 0) {
      _showError('Please enter a valid height.');
      return;
    }

    if (currentWeight == null || currentWeight <= 0) {
      _showError('Please enter your current weight.');
      return;
    }

    if (goalWeight == null || goalWeight <= 0) {
      _showError('Please enter your goal weight.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GoalsScreen(
          name: name,
          age: age,
          height: height,
          currentWeight: currentWeight,
          goalWeight: goalWeight,
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================================
            // TOP BAR
            // ==========================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: _textPrimary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Personal Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ==========================================================
            // CONTENT
            // ==========================================================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  28,
                  24,
                  30,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tell us about yourself',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'We use these details to create a personalized fitness and nutrition plan for you.',
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ==================================================
                    // NAME
                    // ==================================================

                    _buildLabel('Name'),

                    const SizedBox(height: 8),

                    _buildTextField(
                      controller: _nameController,
                      hintText: 'Enter your name',
                      icon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // AGE
                    // ==================================================

                    _buildLabel('Age'),

                    const SizedBox(height: 8),

                    _buildTextField(
                      controller: _ageController,
                      hintText: 'Enter your age',
                      icon: Icons.cake_outlined,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // HEIGHT
                    // ==================================================

                    _buildLabel('Height'),

                    const SizedBox(height: 8),

                    _buildTextField(
                      controller: _heightController,
                      hintText: 'Height in cm',
                      icon: Icons.height_rounded,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // CURRENT WEIGHT
                    // ==================================================

                    _buildLabel('Current Weight'),

                    const SizedBox(height: 8),

                    _buildTextField(
                      controller:
                          _currentWeightController,
                      hintText: 'Weight in kg',
                      icon:
                          Icons.monitor_weight_outlined,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // GOAL WEIGHT
                    // ==================================================

                    _buildLabel('Goal Weight'),

                    const SizedBox(height: 8),

                    _buildTextField(
                      controller:
                          _goalWeightController,
                      hintText: 'Goal weight in kg',
                      icon: Icons.flag_outlined,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),

                    const SizedBox(height: 35),

                    // ==================================================
                    // INFO CARD
                    // ==================================================

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius:
                            BorderRadius.circular(18),
                        border: Border.all(
                          color: _primary.withValues(
                            alpha: 0.20,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: _primary,
                            size: 22,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              'Your information stays part of your personal fitness profile and helps us calculate your BMI, calories, and nutrition targets.',
                              style: TextStyle(
                                color:
                                    _textSecondary,
                                fontSize: 12,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    // ==================================================
                    // NEXT BUTTON
                    // ==================================================

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _next,
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // LABEL
  // ================================================================

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: _textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // ================================================================
  // TEXT FIELD
  // ================================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        color: _textPrimary,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: _textSecondary,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: _primary,
        ),
        filled: true,
        fillColor: _surface,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide(
            color: _border.withValues(
              alpha: 0.70,
            ),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide(
            color: _primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}