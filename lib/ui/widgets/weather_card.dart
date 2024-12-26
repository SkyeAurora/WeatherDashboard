// lib/widgets/weather_card.dart
import 'package:flutter/material.dart';
import 'package:weatherdashboard/constants.dart';
import '../../network/models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final CurrentWeatherModel weather;

  const WeatherCard({Key? key, required this.weather}) : super(key: key);

  Color _getCardColor() {
    String condition = weather.weather[0].main.toLowerCase();
    return weatherCardColors[condition] ?? defaultCardColor;
  }

  Color _getTextColor() {
    String condition = weather.weather[0].main.toLowerCase();
    return weatherTextColors[condition] ?? defaultTextColor;
  }

  String _getWeatherDescription() {
    return weather.weather[0].description;
  }

  @override
  Widget build(BuildContext context) {
    final temp = (weather.main.temp - 273.15).toStringAsFixed(1); // 转换为摄氏度
    final feelsLike = (weather.main.feelsLike - 273.15).toStringAsFixed(1);
    
    return Card(
      color: _getCardColor(),
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              weather.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _getTextColor(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getWeatherDescription(),
              style: TextStyle(
                fontSize: 18,
                color: _getTextColor(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '$temp°C',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: _getTextColor(),
                      ),
                    ),
                    Text(
                      '体感温度: $feelsLike°C',
                      style: TextStyle(
                        fontSize: 16,
                        color: _getTextColor(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
