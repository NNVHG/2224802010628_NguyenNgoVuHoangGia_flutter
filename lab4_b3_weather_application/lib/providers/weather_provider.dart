import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final StorageService _storageService;

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';

  WeatherProvider(this._weatherService, this._locationService, this._storageService);

  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  WeatherState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> fetchWeatherByCity(String cityName) async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName);
      _forecast = await _weatherService.getForecast(cityName);
      await _storageService.saveWeatherData(_currentWeather!);

      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }

  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      _currentWeather = await _weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      final cityName = await _locationService.getCityName(
        position.latitude,
        position.longitude,
      );

      _forecast = await _weatherService.getForecast(cityName);
      await _storageService.saveWeatherData(_currentWeather!);

      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      await loadCachedWeather();
    }
    notifyListeners();
  }

  Future<void> loadCachedWeather() async {
    final cachedWeather = await _storageService.getCachedWeather();
    if (cachedWeather != null) {
      _currentWeather = cachedWeather;
      _state = WeatherState.loaded;
      _errorMessage = 'Đang hiển thị dữ liệu ngoại tuyến (Offline)';
      notifyListeners();
    }
  }

  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }
}