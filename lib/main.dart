import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'services/storage_service.dart';
import 'services/purchase_service.dart';
import 'services/user_service.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'theme/app_theme.dart';
import 'theme/app_theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase.
  await Supabase.initialize(
    url: 'https://nppnkkjfyntyrawnzkrs.supabase.co',
    publishableKey:
        'sb_publishable_DgO0Ayc2WLuiIxUbqqVSbg_z6rV8HD-',
  );

  // Initialize local storage.
  await StorageService.init();

  // Load saved theme.
  await AppThemeController.instance.load();

  // Initialize in-app purchase system.
  try {
    await PurchaseService.initialize();
  } catch (error) {
    debugPrint(
      'PurchaseService initialization failed: $error',
    );
  }

  runApp(const GrowFitApp());
}

class GrowFitApp extends StatelessWidget {
  const GrowFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppThemeController.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'GrowFit',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: AppThemeController.instance.mode,
          home: UserService.hasUser
              ? const MainNavigationScreen()
              : const WelcomeScreen(),
        );
      },
    );
  }
}