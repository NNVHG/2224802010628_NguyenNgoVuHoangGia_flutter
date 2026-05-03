import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  final String apiKey;

  WeatherService({required this.apiKey});
  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    try {
      final url = ApiConfig.buildUrl(ApiConfig.currentWeather, {'q': cityName}, apiKey);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy thành phố này');
      } else {
        throw Exception('Không tải được dữ liệu thời tiết');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  Future<WeatherModel> getCurrentWeatherByCoordinates(double lat, double lon) async {
    try {
      final url = ApiConfig.buildUrl(ApiConfig.currentWeather, {'lat': lat.toString(), 'lon': lon.toString()}, apiKey);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Không tải được dữ liệu vị trí');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  Future<List<ForecastModel>> getForecast(String cityName) async {
    try {
      final url = ApiConfig.buildUrl(ApiConfig.forecast, {'q': cityName}, apiKey);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> forecastList = data['list'];
        return forecastList.map((item) => ForecastModel.fromJson(item)).toList();
      } else {
        throw Exception('Không tải được dự báo 5 ngày');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
}