import 'package:flutter/material.dart';

import 'home/home_screen.dart';
import 'food/food_home_screen.dart';
import 'progress/progress_screen.dart';
import 'workout/workout_home_screen.dart';
import 'profile/profile_screen.dart';
import 'progress/weight_entry_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  final int initialIndex;

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  late int _currentIndex;

  late final List<Widget> _screens = [
    const HomeScreen(),
    const FoodHomeScreen(),
    const ProgressScreen(),
    const WorkoutHomeScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex.clamp(0, 4);
  }

  void _changeTab(int index) {
    if (_currentIndex == index) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  void _showQuickAdd() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor:
          Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        final scheme =
            Theme.of(sheetContext).colorScheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color:
                        scheme.onSurfaceVariant,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  'Quick Add',
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 18),

                _quickAddButton(
                  context: sheetContext,
                  icon:
                      Icons.restaurant_rounded,
                  title: 'Add Food',
                  subtitle: 'Log your meal',
                  color: scheme.tertiary,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _changeTab(1);
                  },
                ),

                const SizedBox(height: 10),

                _quickAddButton(
                  context: sheetContext,
                  icon:
                      Icons.fitness_center_rounded,
                  title: 'Start Workout',
                  subtitle:
                      'Track your exercise',
                  color: scheme.primary,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _changeTab(3);
                  },
                ),

                const SizedBox(height: 10),

                _quickAddButton(
                  context: sheetContext,
                  icon:
                      Icons.monitor_weight_rounded,
                  title: 'Log Weight',
                  subtitle: 'Update your weight',
                  color: scheme.secondary,
                  onTap: () {
                    Navigator.pop(sheetContext);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const WeightEntryScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _quickAddButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final scheme =
        Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(17),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              scheme.surfaceContainerHighest,
          borderRadius:
              BorderRadius.circular(17),
          border: Border.all(
            color: scheme.outlineVariant
                .withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(
                  alpha: 0.10,
                ),
                borderRadius:
                    BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color:
                          scheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              color:
                  scheme.onSurfaceVariant,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavigationBar() {
    final scheme =
        Theme.of(context).colorScheme;

    const items = [
      (
        Icons.home_rounded,
        'Home',
      ),
      (
        Icons.restaurant_menu_rounded,
        'Food',
      ),
      (
        Icons.show_chart_rounded,
        'Progress',
      ),
      (
        Icons.fitness_center_rounded,
        'Workout',
      ),
      (
        Icons.person_rounded,
        'Profile',
      ),
    ];

    return Container(
      height: 78,
      padding: const EdgeInsets.fromLTRB(
        8,
        8,
        82,
        11,
      ),
      decoration: BoxDecoration(
        color:
            scheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: scheme.secondary.withValues(
              alpha: 0.18,
            ),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (
              int i = 0;
              i < items.length;
              i++
            )
              Expanded(
                child: GestureDetector(
                  behavior:
                      HitTestBehavior.opaque,
                  onTap: () => _changeTab(i),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Icon(
                        items[i].$1,
                        color:
                            _currentIndex == i
                                ? scheme.secondary
                                : scheme
                                    .onSurfaceVariant,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[i].$2,
                        style: TextStyle(
                          color:
                              _currentIndex == i
                                  ? scheme.secondary
                                  : scheme
                                      .onSurfaceVariant,
                          fontSize: 9,
                          fontWeight:
                              FontWeight.w600,
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

  Widget _floatingActionButton() {
    final scheme =
        Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _showQuickAdd,
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.secondary,
              scheme.primary,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.secondary
                  .withValues(alpha: 0.38),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          Icons.add_rounded,
          color: scheme.onSurface,
          size: 34,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),

      bottomNavigationBar:
          _buildBottomArea(),
    );
  }

  Widget _buildBottomArea() {
    return SizedBox(
      height: 78,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: _bottomNavigationBar(),
          ),
          Positioned(
            right: 14,
            top: -27,
            child: _floatingActionButton(),
          ),
        ],
      ),
    );
  }
}