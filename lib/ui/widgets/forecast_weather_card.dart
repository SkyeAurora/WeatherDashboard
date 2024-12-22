import 'package:flutter/material.dart';
import 'package:weatherdashboard/network/models/forecast_weather_model.dart';

class ForecastWeatherCard extends StatelessWidget {
  final ForecastWeather forecast;

  const ForecastWeatherCard({Key? key, required this. forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('时间: ${forecast.dtTxt}', style: const TextStyle(fontSize: 18)),
            Text('天气: ${forecast.weather.first.description}'),
            Text('温度: ${kelvinToCelsius(forecast.main.temp)}°C'),
            Text('最高温: ${kelvinToCelsius(forecast.main.tempMax)}°C'),
            Text('最低温: ${kelvinToCelsius(forecast.main.tempMin)}°C'),
          ],
        ),
      ),
    );
  }

  int kelvinToCelsius(double kelvin) {
    double celsius = kelvin - 273.15;
    return celsius.toInt(); // 转换为 int，去掉小数部分
  }
}
