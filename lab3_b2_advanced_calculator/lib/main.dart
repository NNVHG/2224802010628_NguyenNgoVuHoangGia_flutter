// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/calculator_provider.dart';
import 'providers/theme_provider.dart';
import 'models/calculator_settings.dart';
import 'screens/calculator_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const AdvancedCalculatorApp(),
    ),
  );
}

class AdvancedCalculatorApp extends StatelessWidget {
  const AdvancedCalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {

        // Xác định ThemeMode của Flutter dựa theo AppThemeMode của mình
        ThemeMode flutterThemeMode;
        switch (themeProvider.settings.themeMode) {
          case AppThemeMode.light:
            flutterThemeMode = ThemeMode.light;
            break;
          case AppThemeMode.dark:
            flutterThemeMode = ThemeMode.dark;
            break;
          case AppThemeMode.system:
            flutterThemeMode = ThemeMode.system;
            break;
        }

        return MaterialApp(
          title: 'Advanced Calculator',
          debugShowCheckedModeBanner: false,
          themeMode: flutterThemeMode,

          // --- Chủ đề tối (Dark Theme) ---
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF1C1C1C),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF4ECDC4),
              surface: Color(0xFF2C2C2C),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1C1C1C),
              foregroundColor: Colors.white,
            ),
            switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                    ? const Color(0xFF4ECDC4)
                    : Colors.grey,
              ),
            ),
          ),

          // --- Chủ đề sáng (Light Theme) ---
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF0F0F0),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF076544),
              surface: Color(0xFFE0E0E0),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFE0E0E0),
              foregroundColor: Colors.black,
            ),
            switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                    ? const Color(0xFF076544)
                    : Colors.grey,
              ),
            ),
          ),

          home: const CalculatorScreen(),
        );
      },
    );
  }
}