// 数据仓库层，封装数据获取逻辑
// lib/repository/weather_repository.dart

import 'package:weatherdashboard/network/services/current_weather_service.dart';
import 'package:weatherdashboard/network/models/weather_model.dart';

class WeatherRepository {
  final CurrentWeatherService currentWeatherService;
  // TODO 未来可添加多种service

  WeatherRepository({
    required this.currentWeatherService,
  });

  Future<CurrentWeatherModel> getCurrentWeather(double latitude, double longitude) {
    return currentWeatherService.fetchWeatherData(latitude, longitude);
  }

  // Future<WeatherForecastModel> getForecastWeather(double latitude, double longitude) {
  //   return forecastWeatherService.fetchForecastWeather(latitude, longitude);
  // }
}
