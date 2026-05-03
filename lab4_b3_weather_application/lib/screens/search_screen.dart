import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _performSearch() {
    final city = _searchController.text.trim();
    if (city.isNotEmpty) {
      context.read<WeatherProvider>().fetchWeatherByCity(city);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm Thành phố')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Nhập tên thành phố (VD: Hanoi, London)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Lưu ý: Bạn có thể nhập tên thành phố không dấu (ví dụ: "Ho Chi Minh") để API tìm kiếm chính xác nhất.',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}