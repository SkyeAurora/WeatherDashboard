import 'package:flutter/material.dart';
import 'package:weatherdashboard/constants.dart';
import '../../network/models/forecast_weather_model.dart';
import 'package:weatherdashboard/ui/widgetSections/chart.dart';

class BodyLeftpartLinechart extends StatelessWidget {
  final List<dynamic> weather;

  const BodyLeftpartLinechart({Key? key, required this.weather}) : super(key: key);

  Color _getCardColor() {
    String condition = weather[0].weather[0].main.toLowerCase();
    return weatherCardColors[condition] ?? defaultCardColor;
  }

  Color _getTextColor() {
    String condition = weather[0].weather[0].main.toLowerCase();
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
              '未来天气预报',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getTextColor(),
              ),
            ),
            SizedBox(
              height: 600,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: weather.length * 100.0,
                  child: Chart(weather: weather),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
