// API 服务类，处理与OpenWeather API的请求
// lib/network/api_service.dart
import 'services/current_weather_service.dart';


class ApiService {
  final CurrentWeatherService currentWeatherService;

  ApiService({
    required this.currentWeatherService,
  });
}
