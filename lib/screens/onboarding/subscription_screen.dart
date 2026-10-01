import 'package:flutter/material.dart';

import '../../models/subscription_model.dart';
import '../../services/user_service.dart';
import '../home/home_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  final String name;
  final String goalName;

  final double calories;
  final double protein;
  final double carbs;
  final double fats;

  final double bmi;

  const SubscriptionScreen({
    super.key,
    required this.name,
    required this.goalName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.bmi,
  });

  @override
  State<SubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState
    extends State<SubscriptionScreen> {
  String selectedPlan = 'Free';

  bool saving = false;

  Color get _background =>
      Theme.of(context).scaffoldBackgroundColor;

  Color get _surface =>
      Theme.of(context).colorScheme.surface;

  Color get _text =>
      Theme.of(context).colorScheme.onSurface;

  Color get _muted =>
      Theme.of(context)
          .colorScheme
          .onSurface
          .withValues(alpha: 0.58);

  Color get _primary =>
      Theme.of(context).colorScheme.primary;

  // ============================================================
  // PLANS
  // ============================================================

  final plans = const [
    (
      'Free',
      'Start your fitness journey',
      [
        'Basic calorie tracking',
        'Basic food database',
        'Basic workouts',
        'Basic progress tracking',
      ],
    ),
    (
      'Plus',
      'More tools for serious progress',
      [
        'Everything in Free',
        'Advanced recipes',
        'Diet plans',
        'Advanced progress',
        'Advanced workouts',
      ],
    ),
    (
      'Pro',
      'The complete GrowFit experience',
      [
        'Everything in Plus',
        'Mini AI',
        'Personalized nutrition',
        'Advanced analytics',
        'Personalized plans',
      ],
    ),
  ];

  // ============================================================
  // CONVERT SELECTED PLAN
  // ============================================================

  SubscriptionPlan _selectedSubscriptionPlan() {
    switch (selectedPlan) {
      case 'Plus':
        return SubscriptionPlan.plus;

      case 'Pro':
        return SubscriptionPlan.pro;

      case 'Free':
      default:
        return SubscriptionPlan.free;
    }
  }

  // ============================================================
  // SAVE SUBSCRIPTION
  // ============================================================

  Future<void> _saveSubscription() async {
    final user = UserService.getUser();

    if (user == null) {
      throw Exception(
        'User profile was not found.',
      );
    }

    final updatedSubscription =
        user.subscription.copyWith(
      plan: _selectedSubscriptionPlan(),
      isActive: true,
    );

    final updatedUser = user.copyWith(
      subscription: updatedSubscription,
      updatedAt: DateTime.now(),
    );

    await UserService.updateUser(
      updatedUser,
    );
  }

  // ============================================================
  // CONTINUE TO HOME
  // ============================================================

  Future<void> _continue() async {
    if (saving) {
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      await _saveSubscription();

      if (!mounted) {
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Could not save subscription: $e',
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text(
          'Choose Your Plan',
        ),
      ),
      body: Column(
        children: [
          // ======================================================
          // PLANS
          // ======================================================

          Expanded(
            child: ListView(
              physics:
                  const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.all(24),
              children: [
                Text(
                  'Choose your GrowFit experience',
                  style: TextStyle(
                    color: _text,
                    fontSize: 27,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  'You can start free and upgrade later.',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                ...plans.map(
                  (plan) => _planCard(
                    name: plan.$1,
                    subtitle: plan.$2,
                    features: plan.$3,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                // ==================================================
                // SELECTED PLAN
                // ==================================================

                Container(
                  padding:
                      const EdgeInsets.all(14),
                  decoration:
                      BoxDecoration(
                    color: _primary.withValues(
                      alpha: 0.07,
                    ),
                    borderRadius:
                        BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          _primary.withValues(
                        alpha: 0.15,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons
                            .verified_rounded,
                        color: _primary,
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: Text(
                          '$selectedPlan plan selected',
                          style: TextStyle(
                            color: _text,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),

          // ======================================================
          // CONTINUE BUTTON
          // ======================================================

          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              24,
              10,
              24,
              24,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed:
                    saving ? null : _continue,
                child: saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        selectedPlan == 'Free'
                            ? 'Continue with Free'
                            : 'Continue with $selectedPlan',
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PLAN CARD
  // ============================================================

  Widget _planCard({
    required String name,
    required String subtitle,
    required List<String> features,
  }) {
    final selected =
        selectedPlan == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = name;
        });
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 180),
        margin:
            const EdgeInsets.only(bottom: 16),
        padding:
            const EdgeInsets.all(18),
        decoration:
            BoxDecoration(
          color: selected
              ? _primary.withValues(
                  alpha: 0.10,
                )
              : _surface,
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? _primary
                : _primary.withValues(
                    alpha: 0.08,
                  ),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ==================================================
            // PLAN TITLE
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: _text,
                      fontSize: 21,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ),

                Icon(
                  selected
                      ? Icons
                          .check_circle_rounded
                      : Icons
                          .circle_outlined,
                  color: selected
                      ? _primary
                      : _muted,
                ),
              ],
            ),

            const SizedBox(
              height: 5,
            ),

            // ==================================================
            // SUBTITLE
            // ==================================================

            Text(
              subtitle,
              style: TextStyle(
                color: _muted,
                fontSize: 13,
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            // ==================================================
            // FEATURES
            // ==================================================

            ...features.map(
              (feature) => Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 8,
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_rounded,
                      color: _primary,
                      size: 18,
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          color: _text,
                          fontSize: 13,
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
}