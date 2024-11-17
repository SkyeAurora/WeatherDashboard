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
          Text('City: ${weather.name}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('Latitude: ${weather.coord.lat}', style: TextStyle(fontSize: 20)), // 显示纬度
          Text('Longitude: ${weather.coord.lon}', style: TextStyle(fontSize: 20)), // 显示经度
          Text('Temperature: ${weather.main.temp} °K', style: TextStyle(fontSize: 20)),
          Text('Feels Like: ${weather.main.feelsLike} °K', style: TextStyle(fontSize: 20)),
          Text('Weather: ${weather.weather.first.description}', style: TextStyle(fontSize: 20)),
          Text('Humidity: ${weather.main.humidity}%', style: TextStyle(fontSize: 20)),
          Text('Wind Speed: ${weather.wind.speed} m/s', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
