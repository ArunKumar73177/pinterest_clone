import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/router/app_router.dart';

void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // ✓ SYSTEM UI: Pinterest-style status bar configuration
  // Transparent status bar with white icons for dark theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // White icons on black
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // ✓ RIVERPOD: Wrap entire app with ProviderScope
  // This enables state management throughout the app
  runApp(
    const ProviderScope(
      child: PinterestCloneApp(),
    ),
  );
}

/// ✓ MAIN APP: Root widget with routing configuration
/// ConsumerWidget to access Riverpod providers
class PinterestCloneApp extends ConsumerWidget {
  const PinterestCloneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✓ GO_ROUTER: Watch router provider for navigation
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      // App metadata
      title: 'Pinterest Clone',
      debugShowCheckedModeBanner: false,

      // ✓ THEME: Pinterest dark theme configuration
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,

        // Pinterest color scheme
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFE60023), // Pinterest red
          secondary: Colors.white,
          surface: Colors.black,
          background: Colors.black,
        ),

        // Material 3 design system
        useMaterial3: true,

        // AppBar theme for consistent headers
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        // Bottom navigation bar theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[600],
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),

        // Text theme
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),

        // Icon theme
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      // ✓ GO_ROUTER: Router configuration from provider
      routerConfig: router,
    );
  }
}