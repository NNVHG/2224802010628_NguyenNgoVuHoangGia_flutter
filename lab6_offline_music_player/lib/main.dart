import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/audio_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AudioProvider(),
      child: MaterialApp(
        title:                    'Music Player',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness:  Brightness.dark,
          primaryColor: const Color(0xFF1DB954),
          scaffoldBackgroundColor: const Color(0xFF191414),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF1DB954),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}