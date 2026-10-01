import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../theme/app_theme_controller.dart';
import 'edit_profile_screen.dart';
import '../subscription/subscription_management_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // ============================================================
  // LOAD USER
  // ============================================================

  void _loadUser() {
    setState(() {
      _user = UserService.getUser();
    });
  }

  // ============================================================
  // EDIT PROFILE
  // ============================================================

  Future<void> _editProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const EditProfileScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    _loadUser();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final user = _user;

    if (user == null) {
      return Scaffold(
        backgroundColor:
            scheme.surface,

        appBar:
            AppBar(
          backgroundColor:
              scheme.surface,
          elevation: 0,
          title:
              Text(
            'Profile',
          ),
        ),

        body:
            Center(
          child:
              Text(
            'No user profile found.',
            style:
                TextStyle(
              color:
                  scheme.onSurface,
              fontSize:
                  16,
            ),
          ),
        ),
      );
    }

    final calories =
        user.targetCalories ?? 0;

    final protein =
        user.targetProtein ?? 0;

    final carbs =
        user.targetCarbs ?? 0;

    final fats =
        user.targetFats ?? 0;

    return Scaffold(
      backgroundColor:
          scheme.surface,

      appBar:
          AppBar(
        backgroundColor:
            scheme.surface,
        elevation: 0,

        title:
            Text(
          'Profile',
          style:
              TextStyle(
            color:
                scheme.onSurface,
            fontWeight:
                FontWeight.w800,
          ),
        ),

        actions: [
          IconButton(
            tooltip:
                'Edit Profile',

            onPressed:
                _editProfile,

            icon:
                Icon(
              Icons
                  .edit_rounded,
              color:
                  scheme.primary,
            ),
          ),
        ],
      ),

      body:
          SafeArea(
        child:
            SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),

          padding:
              const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),

          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [
              _profileHeader(
                user,
              ),

              const SizedBox(
                height:
                    20,
              ),

              _goalCard(
                user,
              ),

              const SizedBox(
                height:
                    18,
              ),

              _personalDetailsCard(
                user,
              ),

              const SizedBox(
                height:
                    18,
              ),

              _bodyCard(
                user,
              ),

              const SizedBox(
                height:
                    18,
              ),

              _activityCard(
                user,
              ),

              const SizedBox(
                height:
                    18,
              ),

              _nutritionCard(
                calories:
                    calories,
                protein:
                    protein,
                carbs:
                    carbs,
                fats:
                    fats,
              ),

              const SizedBox(
                height:
                    18,
              ),

              _appearanceCard(),

              const SizedBox(
                height: 18,
              ),

              _subscriptionCard(user),

              const SizedBox(
                height: 18,
              ),

              if (user.habits.isNotEmpty)
                _habitsCard(
                  user,
                ),

              if (user.habits.isNotEmpty)
                const SizedBox(
                  height:
                      18,
                ),

              if (user
                  .nutritionPreferences
                  .isNotEmpty)
                _preferencesCard(
                  user,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _profileHeader(
    UserModel user,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final displayName =
        user.name.trim().isEmpty
            ? 'GrowFit User'
            : user.name.trim();

    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        22,
      ),

      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            scheme.secondary,
            scheme.surfaceContainerHighest,
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          24,
        ),

        border:
            Border.all(
          color:
              scheme.primary
                  .withValues(
            alpha:
                0.25,
          ),
        ),
      ),

      child:
          Row(
        children: [
          Container(
            width:
                68,

            height:
                68,

            decoration:
                BoxDecoration(
              color:
                  scheme.primary
                      .withValues(
                alpha:
                    0.12,
              ),

              shape:
                  BoxShape.circle,

              border:
                  Border.all(
                color:
                    scheme.primary
                        .withValues(
                  alpha:
                      0.30,
                ),
              ),
            ),

            child:
                Icon(
              Icons
                  .person_rounded,
              color:
                  scheme.primary,
              size:
                  34,
            ),
          ),

          const SizedBox(
            width:
                15,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  displayName,

                  maxLines:
                      1,

                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      TextStyle(
                    color:
                        scheme
                            .onSurface,
                    fontSize:
                        23,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(
                  height:
                      5,
                ),

                Text(
                  user.goalName,

                  style:
                      TextStyle(
                    color:
                        scheme.primary,
                    fontSize:
                        13,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height:
                      4,
                ),

                Text(
                  user.activityLevelName,

                  style:
                      TextStyle(
                    color:
                        scheme
                            .onSurfaceVariant,
                    fontSize:
                        11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GOAL CARD
  // ============================================================

  Widget _goalCard(
    UserModel user,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final progress =
        _goalProgress(user);

    return _sectionCard(
      title:
          'Your Goal',

      icon:
          Icons.flag_rounded,

      color:
          scheme.primary,

      child:
          Column(
        children: [
          Row(
            children: [
              Expanded(
                child:
                    _valueItem(
                  title:
                      'Goal',
                  value:
                      user.goalName,
                ),
              ),

              const SizedBox(
                width:
                    12,
              ),

              Expanded(
                child:
                    _valueItem(
                  title:
                      'Target',
                  value:
                      '${user.goalWeight.toStringAsFixed(1)} kg',
                ),
              ),
            ],
          ),

          const SizedBox(
            height:
                18,
          ),

          Align(
            alignment:
                Alignment.centerLeft,

            child:
                Text(
              'Weekly Target',

              style:
                  TextStyle(
                color:
                    scheme
                        .onSurfaceVariant,
                fontSize:
                    11,
              ),
            ),
          ),

          const SizedBox(
            height:
                5,
          ),

          Align(
            alignment:
                Alignment.centerLeft,

            child:
                Text(
              _weeklyTargetText(
                user.weeklyTarget,
                user.goal,
              ),

              style:
                  TextStyle(
                color:
                    scheme
                        .onSurface,
                fontSize:
                    15,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(
            height:
                18,
          ),

          LinearProgressIndicator(
            value:
                progress,

            minHeight:
                9,

            borderRadius:
                BorderRadius.circular(
              20,
            ),

            backgroundColor:
                scheme.outlineVariant,

            color:
                scheme.primary,
          ),

          const SizedBox(
            height:
                9,
          ),

          Row(
            children: [
              Expanded(
                child:
                    Text(
                  '${(progress * 100).round()}% progress',

                  style:
                      TextStyle(
                    color:
                        scheme.onSurfaceVariant,
                    fontSize:
                        10,
                  ),
                ),
              ),

              Text(
                'Current ${user.currentWeight.toStringAsFixed(1)} kg',

                style:
                    TextStyle(
                  color:
                      scheme.onSurfaceVariant,
                  fontSize:
                      10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PERSONAL DETAILS
  // ============================================================

  Widget _personalDetailsCard(
    UserModel user,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return _sectionCard(
      title:
          'Personal Details',

      icon:
          Icons.person_outline_rounded,

      color:
          scheme.secondary,

      child:
          Column(
        children: [
          _detailRow(
            icon:
                Icons.person_outline_rounded,
            title:
                'Name',
            value:
                user.name.isEmpty
                    ? 'Not set'
                    : user.name,
          ),

          _detailDivider(),

          _detailRow(
            icon:
                Icons.cake_outlined,
            title:
                'Age',
            value:
                user.age > 0
                    ? '${user.age} years'
                    : 'Not set',
          ),

          _detailDivider(),

          _detailRow(
            icon:
                Icons.height_rounded,
            title:
                'Height',
            value:
                user.height > 0
                    ? '${user.height.toStringAsFixed(1)} cm'
                    : 'Not set',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BODY CARD
  // ============================================================

  Widget _bodyCard(
    UserModel user,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return _sectionCard(
      title:
          'Body Information',

      icon:
          Icons.monitor_heart_rounded,

      color:
          scheme.primary,

      child:
          Column(
        children: [
          Row(
            children: [
              Expanded(
                child:
                    _metricBox(
                  title:
                      'Current',
                  value:
                      '${user.currentWeight.toStringAsFixed(1)} kg',
                  icon:
                      Icons
                          .monitor_weight_rounded,
                ),
              ),

              const SizedBox(
                width:
                    10,
              ),

              Expanded(
                child:
                    _metricBox(
                  title:
                      'Goal',
                  value:
                      '${user.goalWeight.toStringAsFixed(1)} kg',
                  icon:
                      Icons
                          .flag_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(
            height:
                12,
          ),

          Container(
            width:
                double.infinity,

            padding:
                const EdgeInsets.all(
              15,
            ),

            decoration:
                BoxDecoration(
              color:
                  scheme.surfaceContainerHighest,

              borderRadius:
                  BorderRadius.circular(
                15,
              ),
            ),

            child:
                Row(
              children: [
                Icon(
                  Icons
                      .monitor_heart_rounded,

                  color:
                      scheme.primary,

                  size:
                      22,
                ),

                const SizedBox(
                  width:
                      10,
                ),

                Expanded(
                  child:
                      Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      Text(
                        'BMI',

                        style:
                            TextStyle(
                          color:
                              scheme.onSurfaceVariant,

                          fontSize:
                              10,
                        ),
                      ),

                      const SizedBox(
                        height:
                            3,
                      ),

                      Text(
                        user.bmi > 0
                            ? user.bmi
                                .toStringAsFixed(
                                1,
                              )
                            : '—',

                        style:
                            TextStyle(
                          color:
                              scheme.onSurface,

                          fontSize:
                              17,

                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  user.bmiCategory,

                  style:
                      TextStyle(
                    color:
                        scheme.primary,

                    fontSize:
                        12,

                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVITY CARD
  // ============================================================

  Widget _activityCard(
    UserModel user,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return _sectionCard(
      title:
          'Activity',

      icon:
          Icons.directions_run_rounded,

      color:
          scheme.primary,

      child:
          _detailRow(
        icon:
            Icons
                .directions_run_rounded,

        title:
            'Activity Level',

        value:
            user.activityLevelName,
      ),
    );
  }

  // ============================================================
  // NUTRITION CARD
  // ============================================================

  Widget _nutritionCard({
    required double calories,
    required double protein,
    required double carbs,
    required double fats,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return _sectionCard(
      title:
          'Daily Nutrition Targets',

      icon:
          Icons.restaurant_menu_rounded,

      color:
          scheme.tertiary,

      child:
          Column(
        children: [
          _nutritionRow(
            title:
                'Calories',
            value:
                calories > 0
                    ? '${calories.toStringAsFixed(0)} kcal'
                    : 'Not set',
            icon:
                Icons
                    .local_fire_department_rounded,
          ),

          _detailDivider(),

          _nutritionRow(
            title:
                'Protein',
            value:
                protein > 0
                    ? '${protein.toStringAsFixed(0)} g'
                    : 'Not set',
            icon:
                Icons
                    .fitness_center_rounded,
          ),

          _detailDivider(),

          _nutritionRow(
            title:
                'Carbs',
            value:
                carbs > 0
                    ? '${carbs.toStringAsFixed(0)} g'
                    : 'Not set',
            icon:
                Icons.grain_rounded,
          ),

          _detailDivider(),

          _nutritionRow(
            title:
                'Fats',
            value:
                fats > 0
                    ? '${fats.toStringAsFixed(0)} g'
                    : 'Not set',
            icon:
                Icons.water_drop_rounded,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HABITS CARD
  // ============================================================

  Widget _habitsCard(
    UserModel user,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return _sectionCard(
      title:
          'Your Habits',

      icon:
          Icons.check_circle_rounded,

      color:
          scheme.primary,

      child:
          Wrap(
        spacing:
            8,

        runSpacing:
            8,

        children:
            user.habits.map(
          (habit) {
            return _chip(
              habit,
              scheme.primary,
            );
          },
        ).toList(),
      ),
    );
  }

  // ============================================================
  // PREFERENCES CARD
  // ============================================================

  Widget _preferencesCard(
    UserModel user,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return _sectionCard(
      title:
          'Nutrition Preferences',

      icon:
          Icons.restaurant_rounded,

      color:
          scheme.secondary,

      child:
          Wrap(
        spacing:
            8,

        runSpacing:
            8,

        children:
            user
                .nutritionPreferences
                .map(
          (preference) {
            return _chip(
              preference,
              scheme.secondary,
            );
          },
        ).toList(),
      ),
    );
  }

  // ============================================================
  // APPEARANCE
  // ============================================================

  Widget _appearanceCard() {
    return _sectionCard(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      color: Theme.of(context).colorScheme.secondary,
      child: const _AppearanceToggle(),
    );
  }

  // ============================================================
  // SUBSCRIPTION CARD
  // ============================================================

  Widget _subscriptionCard(UserModel user) {
    final scheme = Theme.of(context).colorScheme;
    final subscription = user.subscription;

    return _sectionCard(
      title: 'Subscription',
      icon: Icons.workspace_premium_rounded,
      color: scheme.primary,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const SubscriptionManagementScreen(),
            ),
          );

          if (!mounted) {
            return;
          }

          _loadUser();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: scheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${subscription.planName} Plan',
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subscription.isActive
                          ? 'Manage your GrowFit subscription'
                          : 'Subscription inactive',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION CARD
  // ============================================================

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration:
          BoxDecoration(
        color:
            scheme.surface,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        border:
            Border.all(
          color:
              scheme.outlineVariant.withValues(
            alpha:
                0.4,
          ),
        ),
      ),

      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width:
                    38,

                height:
                    38,

                decoration:
                    BoxDecoration(
                  color:
                      color.withValues(
                    alpha:
                        0.10,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),

                child:
                    Icon(
                  icon,
                  color:
                      color,
                  size:
                      20,
                ),
              ),

              const SizedBox(
                width:
                    10,
              ),

              Text(
                title,

                style:
                    TextStyle(
                  color:
                      scheme.onSurface,
                  fontSize:
                      16,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(
            height:
                16,
          ),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // VALUE ITEM
  // ============================================================

  Widget _valueItem({
    required String title,
    required String value,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding:
          const EdgeInsets.all(
        14,
      ),

      decoration:
          BoxDecoration(
        color:
            scheme.surfaceContainerHighest,

        borderRadius:
            BorderRadius.circular(
          15,
        ),
      ),

      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [
          Text(
            title,

            style:
                TextStyle(
              color:
                  scheme.onSurfaceVariant,
              fontSize:
                  10,
            ),
          ),

          const SizedBox(
            height:
                5,
          ),

          Text(
            value,

            maxLines:
                2,

            overflow:
                TextOverflow.ellipsis,

            style:
                TextStyle(
              color:
                  scheme.onSurface,
              fontSize:
                  13,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // METRIC BOX
  // ============================================================

  Widget _metricBox({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding:
          const EdgeInsets.all(
        15,
      ),

      decoration:
          BoxDecoration(
        color:
            scheme.surfaceContainerHighest,

        borderRadius:
            BorderRadius.circular(
          15,
        ),
      ),

      child:
          Row(
        children: [
          Icon(
            icon,

            color:
                scheme.primary,

            size:
                20,
          ),

          const SizedBox(
            width:
                9,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  title,

                  style:
                      TextStyle(
                    color:
                        scheme.onSurfaceVariant,
                    fontSize:
                        9,
                  ),
                ),

                const SizedBox(
                  height:
                      3,
                ),

                Text(
                  value,

                  style:
                      TextStyle(
                    color:
                        scheme.onSurface,
                    fontSize:
                        13,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget _detailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width:
              38,

          height:
              38,

          decoration:
              BoxDecoration(
            color:
                scheme.primary
                    .withValues(
              alpha:
                  0.08,
            ),

            borderRadius:
                BorderRadius.circular(
              12,
            ),
          ),

          child:
              Icon(
            icon,
            color:
                scheme.primary,
            size:
                20,
          ),
        ),

        const SizedBox(
          width:
              11,
        ),

        Expanded(
          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style:
                    TextStyle(
                  color:
                      scheme.onSurfaceVariant,
                  fontSize:
                      10,
                ),
              ),

              const SizedBox(
                height:
                    3,
              ),

              Text(
                value,

                style:
                    TextStyle(
                  color:
                      scheme.onSurface,
                  fontSize:
                      13,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // NUTRITION ROW
  // ============================================================

  Widget _nutritionRow({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(
          icon,
          color:
              scheme.primary,
          size:
              20,
        ),

        const SizedBox(
          width:
              10,
        ),

        Expanded(
          child:
              Text(
            title,

            style:
                TextStyle(
              color:
                  scheme
                      .onSurfaceVariant,
              fontSize:
                  12,
            ),
          ),
        ),

        Text(
          value,

          style:
              TextStyle(
            color:
                scheme.onSurface,
            fontSize:
                13,
            fontWeight:
                FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _detailDivider() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height:
          1,

      margin:
          const EdgeInsets.symmetric(
        vertical:
            12,
      ),

      color:
          scheme.outlineVariant,
    );
  }

  // ============================================================
  // CHIP
  // ============================================================

  Widget _chip(
    String text,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            12,
        vertical:
            9,
      ),

      decoration:
          BoxDecoration(
        color:
            color.withValues(
          alpha:
              0.08,
        ),

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        border:
            Border.all(
          color:
              color.withValues(
            alpha:
                0.18,
          ),
        ),
      ),

      child:
          Text(
        text,

        style:
            TextStyle(
          color:
              color,
          fontSize:
              11,
          fontWeight:
              FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // GOAL PROGRESS
  // ============================================================

  double _goalProgress(
    UserModel user,
  ) {
    final start =
        user.currentWeight;

    final current =
        user.currentWeight;

    final goal =
        user.goalWeight;

    if (start <= 0 ||
        current <= 0 ||
        goal <= 0) {
      return 0;
    }

    final distance =
        (start - goal).abs();

    if (distance <= 0) {
      return 1;
    }

    final completed =
        (start - current).abs();

    final value =
        completed /
            distance;

    return value
        .clamp(
          0.0,
          1.0,
        )
        .toDouble();
  }

  // ============================================================
  // WEEKLY TARGET TEXT
  // ============================================================

  String _weeklyTargetText(
    WeeklyTarget target,
    FitnessGoal goal,
  ) {
    switch (target) {
      case WeeklyTarget.zeroPoint25Kg:
        return _targetDescription(
          0.25,
          goal,
        );

      case WeeklyTarget.zeroPoint5Kg:
        return _targetDescription(
          0.5,
          goal,
        );

      case WeeklyTarget.custom:
        return 'Custom weekly target';
    }
  }

  String _targetDescription(
    double value,
    FitnessGoal goal,
  ) {
    switch (goal) {
      case FitnessGoal.loseWeight:
        return 'Lose ${value.toStringAsFixed(2)} kg per week';

      case FitnessGoal.gainWeight:
        return 'Gain ${value.toStringAsFixed(2)} kg per week';

      case FitnessGoal.gainMuscle:
        return '${value.toStringAsFixed(2)} kg weekly target';

      case FitnessGoal.maintainWeight:
        return 'Maintain current weight';

      case FitnessGoal.improveFitness:
        return 'Fitness-focused weekly target';
    }
  }
}

class _AppearanceToggle extends StatelessWidget {
  const _AppearanceToggle();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = AppThemeController.instance;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final brightness = Theme.of(context).brightness;
        final isDark = controller.mode == ThemeMode.dark ||
            (controller.mode == ThemeMode.system &&
                brightness == Brightness.dark);

        return Container(
          height: 56,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: scheme.outline.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _AppearanceOption(
                  icon: Icons.light_mode_rounded,
                  label: 'Light',
                  selected: !isDark,
                  onTap: () => controller.setMode(ThemeMode.light),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _AppearanceOption(
                  icon: Icons.dark_mode_rounded,
                  label: 'Dark',
                  selected: isDark,
                  onTap: () => controller.setMode(ThemeMode.dark),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AppearanceOption extends StatelessWidget {
  const _AppearanceOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: selected
          ? scheme.primary.withValues(alpha: 0.12)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 19,
                color: selected
                    ? scheme.primary
                    : scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? scheme.primary
                      : scheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: selected
                      ? FontWeight.w800
                      : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
