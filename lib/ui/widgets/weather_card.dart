// lib/widgets/weather_card.dart
import 'package:flutter/material.dart';
import 'package:weatherdashboard/network/models/weather_model.dart';
import 'package:weatherdashboard/ui/widgetSections/body_rightpart.dart';

import '../widgetSections/header_title.dart';

class WeatherCard extends StatelessWidget {
  final CurrentWeatherModel weather;

  const WeatherCard({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: HeaderTitle(weather: weather),
          ),
        ],
      ),
    );
    
  }

}
