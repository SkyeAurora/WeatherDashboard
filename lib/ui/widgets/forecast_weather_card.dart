import 'package:flutter/material.dart';
import 'package:weatherdashboard/network/models/forecast_weather_model.dart';

class ForecastWeatherCard extends StatelessWidget {
  final ForecastWeather forecast;

  const ForecastWeatherCard({Key? key, required this. forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '时间: ${forecast.dtTxt}',
              style: const TextStyle(fontSize: 10)
            ),
            Text(
              '天气: ${forecast.weather.first.description}',
              style: const TextStyle(fontSize: 8)
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${kelvinToCelsius(forecast.main.temp)}°C ',
                  style: const TextStyle(fontSize: 10)
                ),
                Text(
                  '↑${kelvinToCelsius(forecast.main.tempMax)}°C ',
                  style: const TextStyle(fontSize: 8, color: Colors.red)
                ),
                Text(
                  '↓${kelvinToCelsius(forecast.main.tempMin)}°C',
                  style: const TextStyle(fontSize: 8, color: Colors.blue)
                ),
              ],
            ),
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
