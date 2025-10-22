// lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

const String _kDarkModeKey = 'isDarkMode';

void main() {
  // Pastikan binding sudah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Helper untuk mengakses State dari luar (untuk toggle theme)
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // State untuk mengelola tema
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_kDarkModeKey) ?? false;
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final bool setToDark = _themeMode == ThemeMode.light;
      _themeMode = setToDark ? ThemeMode.dark : ThemeMode.light;
      prefs.setBool(_kDarkModeKey, setToDark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Campus Feedback',
      // Tema Light (Material 3)
      theme: ThemeData(
        useMaterial3: true,
        // WARNA SERAGAM: Biru
        colorScheme:
        ColorScheme.fromSeed(seedColor: Colors.blue.shade700, brightness: Brightness.light),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      // Tema Dark (Material 3)
      darkTheme: ThemeData(
        useMaterial3: true,
        // WARNA SERAGAM: Varian biru untuk dark mode
        colorScheme:
        ColorScheme.fromSeed(seedColor: Colors.blue.shade900, brightness: Brightness.dark),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      themeMode: _themeMode,
      home: const HomePage(),
    );
  }
}