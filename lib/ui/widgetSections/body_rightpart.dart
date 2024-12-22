import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weatherdashboard/network/models/forecast_weather_model.dart';
import 'package:weatherdashboard/ui/widgetSections/chart.dart';

import '../../constants.dart';
import '../../network/models/weather_model.dart';

class BodyRightpart extends StatelessWidget {
  final List<ForecastWeather> weather;

  const BodyRightpart({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildContentView();
  }

  Widget _buildContentView() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Color(0x881E638D),
            Color(0x844C9DCC),
          ],
        ),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          DefaultTextStyle(
            style: const TextStyle(
              color: fontColor,
              fontSize: 24,
              fontWeight: FontWeight.normal,
            ),
            child: Column(
              children: [
                Text("天气数据总览表"),
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
        ],
      ),
    );
  }
}
