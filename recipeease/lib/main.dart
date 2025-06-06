import 'package:flutter/material.dart';

void main() {
  runApp(const RecipeEaseApp());
}

// PUBLIC_INTERFACE
class RecipeEaseApp extends StatefulWidget {
  /// The root of the RecipeEase application. Manages app-level theme state.
  const RecipeEaseApp({super.key});

  @override
  State<RecipeEaseApp> createState() => _RecipeEaseAppState();
}

class _RecipeEaseAppState extends State<RecipeEaseApp> {
  ThemeMode _themeMode = ThemeMode.light; // Default to light

  // Brand colors from provided context
  static const Color _brandPrimary = Color(0xFFFF7043);
  static const Color _brandSecondary = Color(0xFFFFF3E0);
  static const Color _brandAccent = Color(0xFF388E3C);

  // Define both Light and Dark ColorSchemes using brand colors,
  // replacing deprecated background/onBackground fields with surface/onSurface.
  final ThemeData _lightTheme = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: _brandPrimary,
      onPrimary: Colors.white,
      secondary: _brandAccent,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: _brandSecondary,
      onSurface: Colors.black,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: _brandPrimary,
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: _brandSecondary,
  );

  final ThemeData _darkTheme = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: _brandPrimary,
      onPrimary: Colors.black,
      secondary: _brandAccent,
      onSecondary: Colors.black,
      error: Color(0xffcf6679),
      onError: Colors.black,
      surface: Color(0xFF242424),
      onSurface: Colors.white,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: _brandPrimary,
      foregroundColor: Colors.black,
    ),
    scaffoldBackgroundColor: const Color(0xFF212121),
  );

  // PUBLIC_INTERFACE
  void _toggleThemeMode() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecipeEase',
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _themeMode,
      home: HomePage(
        themeMode: _themeMode,
        onThemeToggle: _toggleThemeMode,
      ),
    );
  }
}

// PUBLIC_INTERFACE
class HomePage extends StatelessWidget {
  /// The main home page of RecipeEase.
  /// 
  /// [themeMode] is the current active theme, [onThemeToggle] is callback for theme switching.
  final ThemeMode themeMode;
  final VoidCallback onThemeToggle;

  const HomePage({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecipeEase'),
        actions: [
          // Theme toggle Switch in AppBar
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
            onPressed: onThemeToggle,
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to RecipeEase!'),
      ),
    );
  }
}
