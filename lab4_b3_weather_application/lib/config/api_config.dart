class ApiConfig {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Các endpoint (điểm cuối API)
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';

  // Hàm hỗ trợ build URL chuẩn
  static String buildUrl(String endpoint, Map<String, dynamic> params, String apiKey) {
    final uri = Uri.parse('$baseUrl$endpoint');
    params['appid'] = apiKey;
    params['units'] = 'metric'; // Sử dụng hệ mét (độ C)
    params['lang'] = 'vi'; // Lấy dữ liệu tiếng Việt từ API
    return uri.replace(queryParameters: params).toString();
  }
}