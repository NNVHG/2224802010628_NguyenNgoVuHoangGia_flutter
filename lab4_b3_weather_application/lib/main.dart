import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/weather_provider.dart';
import 'services/weather_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  // Đảm bảo Flutter binding đã khởi tạo trước khi load .env
  WidgetsFlutterBinding.ensureInitialized();

  // Tải file .env chứa API Key
  await dotenv.load(fileName: ".env");

  runApp(
    // Thiết lập Provider để quản lý trạng thái toàn cục
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
            WeatherService(apiKey: dotenv.env['OPENWEATHER_API_KEY'] ?? ''),
            LocationService(),
            StorageService(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng Thời tiết Lab 4',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Gọi HomeScreen làm màn hình chính
      home: HomeScreen(),
    );
  }
}