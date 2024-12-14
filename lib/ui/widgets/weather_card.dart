// lib/widgets/weather_card.dart
import 'package:flutter/material.dart';
import 'package:weatherdashboard/network/models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final CurrentWeatherModel weather;

  const WeatherCard({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('城市: ${weather.name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('纬度: ${weather.coord.lat}',
              style: TextStyle(fontSize: 20)), // 显示纬度
          Text('经度: ${weather.coord.lon}',
              style: TextStyle(fontSize: 20)), // 显示经度
          Text('温度: ${kelvinToCelsius(weather.main.temp)} °C',
              style: TextStyle(fontSize: 20)),
          Text('体感温度: ${kelvinToCelsius(weather.main.feelsLike)} °C',
              style: TextStyle(fontSize: 20)),
          Text('天气: ${weather.weather.first.description}',
              style: TextStyle(fontSize: 20)),
          Text('湿度: ${weather.main.humidity}%', style: TextStyle(fontSize: 20)),
          Text('风速: ${weather.wind.speed} m/s', style: TextStyle(fontSize: 20)),
          Text('最高温度: ${kelvinToCelsius(weather.main.tempMax)} °C',
              style: TextStyle(fontSize: 20)),
          Text('最低温度: ${kelvinToCelsius(weather.main.tempMin)} °C',
              style: TextStyle(fontSize: 20)),
          // Text('空气质量指数(AQI): ${airPollutionModel.aqi}',
          //     style: TextStyle(fontSize: 20)),
          // Text('空气质量描述: ${getAQIDescription(airPollutionModel.aqi)}',
          //     style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  int kelvinToCelsius(double kelvin) {
    double celsius = kelvin - 273.15;
    return celsius.toInt(); // 转换为 int，去掉小数部分
  }
}
