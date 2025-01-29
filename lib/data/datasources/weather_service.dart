import 'package:weather/weather.dart';

class WeatherService {
  final WeatherFactory _weatherFactory;
  static const String _apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';

  WeatherService() : _weatherFactory = WeatherFactory(_apiKey);

  Future<Map<String, dynamic>> getWeatherData(double lat, double lon) async {
    try {
      final weather = await _weatherFactory.currentWeatherByLocation(lat, lon);
      return {
        'temperature': weather.temperature?.celsius,
        'conditions': weather.weatherMain,
        'windSpeed': weather.windSpeed,
        'humidity': weather.humidity,
        'pressure': weather.pressure,
      };
    } catch (e) {
      throw Exception('Failed to fetch weather data: $e');
    }
  }
}
