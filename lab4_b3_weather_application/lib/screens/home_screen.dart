import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Thời Tiết Hôm Nay', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.blue),
            onPressed: () => context.read<WeatherProvider>().fetchWeatherByLocation(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<WeatherProvider>().refreshWeather(),
        child: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            if (provider.state == WeatherState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.state == WeatherState.error && provider.currentWeather == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(provider.errorMessage, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchWeatherByLocation(),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            if (provider.currentWeather == null) {
              return const Center(child: Text('Không có dữ liệu thời tiết. Vui lòng tìm kiếm thành phố.'));
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (provider.errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 16),
                      color: Colors.orange.shade100,
                      child: Row(
                        children: [
                          const Icon(Icons.offline_bolt, color: Colors.orange),
                          const SizedBox(width: 8),
                          Expanded(child: Text(provider.errorMessage)),
                        ],
                      ),
                    ),
                  CurrentWeatherCard(weather: provider.currentWeather!),
                  const SizedBox(height: 20),
                  const Text('Dự báo sắp tới', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // Render danh sách dự báo đơn giản
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.forecast.length,
                      itemBuilder: (context, index) {
                        final forecast = provider.forecast[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${forecast.dateTime.hour}:00\n${forecast.dateTime.day}/${forecast.dateTime.month}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Image.network('https://openweathermap.org/img/wn/${forecast.icon}.png', height: 50),
                              Text('${forecast.temperature.round()}°C', style: const TextStyle(fontSize: 18)),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}