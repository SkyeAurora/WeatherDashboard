// lib/widgets/weather_card.dart
import 'package:flutter/material.dart';
import 'package:weatherdashboard/network/models/air_polluction_model.dart';

class AirPollutionCard extends StatelessWidget {
  final AirPollutionModel airPollutionModel;

  const AirPollutionCard(
      {Key? key, required this.airPollutionModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('空气质量指数(AQI): ${airPollutionModel.aqi}',
              style: TextStyle(fontSize: 20)),
          Text('空气质量描述: ${getAQIDescription(airPollutionModel.aqi)}',
              style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  /// 根据AQI数值返回空气质量描述
  String getAQIDescription(int aqi) {
    switch (aqi) {
      case 1:
        return "(优)";
      case 2:
        return "(良好)";
      case 3:
        return "(轻度污染)";
      case 4:
        return "(中度污染)";
      case 5:
        return "(重度污染)";
      default:
        return "(未知)";
    }
  }
}
