import 'package:flutter/material.dart';

import 'personal_details_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // GrowFit blue / indigo / violet palette.
  static const Color _navy = Color(0xFF050B18);
  static const Color _deepIndigo = Color(0xFF1A1F3D);
  static const Color _indigo = Color(0xFF4C2BD9);
  static const Color _violet = Color(0xFF7A5CFF);
  static const Color _lavender = Color(0xFFA78BFA);
  static const Color _lightLavender = Color(0xFFEDE9FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _deepIndigo,
              _navy,
            ],
            stops: [
              0.0,
              0.78,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              24,
              24,
              18,
            ),
            child: Column(
              children: [
                const Spacer(),

                // GrowFit icon.
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _indigo,
                        _violet,
                      ],
                    ),
                    border: Border.all(
                      color: _lavender.withValues(
                        alpha: 0.45,
                      ),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _violet.withValues(
                          alpha: 0.24,
                        ),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.fitness_center_rounded,
                    size: 50,
                    color: _lightLavender,
                  ),
                ),

                const SizedBox(height: 34),

                // Main heading.
                const Text(
                  'Welcome to GrowFit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.7,
                  ),
                ),

                const SizedBox(height: 13),

                // Accent subtitle.
                const Text(
                  'Build Your Better Self',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _lavender,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),

                const SizedBox(height: 18),

                // Description.
                Text(
                  'Your personal fitness companion for nutrition, '
                  'workouts, progress and healthier habits.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(
                      alpha: 0.68,
                    ),
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(),

                // Get Started button.
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          _indigo,
                          _violet,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: _violet.withValues(
                            alpha: 0.28,
                          ),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const PersonalDetailsScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: _lightLavender,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  'Your journey starts here.',
                  style: TextStyle(
                    color: Colors.white.withValues(
                      alpha: 0.50,
                    ),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}