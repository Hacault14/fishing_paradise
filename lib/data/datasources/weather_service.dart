import 'package:weather/weather.dart';
import '../../config/env_config.dart';

class WeatherService {
  final WeatherFactory _weatherFactory;

  WeatherService()
      : _weatherFactory = WeatherFactory(EnvConfig.openWeatherApiKey);

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
