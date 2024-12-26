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

  @override
  Widget build(BuildContext context) {
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
            // ... 其他现有内容，记得更新文字颜色
          ],
        ),
      ),
    );
  }
}
