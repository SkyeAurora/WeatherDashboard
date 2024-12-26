// lib/widgets/weather_card.dart
import 'package:flutter/material.dart';
import 'package:weatherdashboard/constants.dart';
import '../../network/models/air_polluction_model.dart';

class AirPollutionCard extends StatelessWidget {
  final AirPollutionModel pollution;

  const AirPollutionCard({Key? key, required this.pollution}) : super(key: key);

  String _getAQIDescription(int aqi) {
    switch (aqi) {
      case 1:
        return '优';
      case 2:
        return '良';
      case 3:
        return '轻度污染';
      case 4:
        return '中度污染';
      case 5:
        return '重度污染';
      default:
        return '未知';
    }
  }

  Color _getAQIColor(int aqi) {
    switch (aqi) {
      case 1:
        return Colors.green.withOpacity(0.7);
      case 2:
        return Colors.yellow.withOpacity(0.7);
      case 3:
        return Colors.orange.withOpacity(0.7);
      case 4:
        return Colors.red.withOpacity(0.7);
      case 5:
        return Colors.purple.withOpacity(0.7);
      default:
        return Colors.grey.withOpacity(0.7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getAQIColor(pollution.aqi),
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '空气质量指数',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getAQIDescription(pollution.aqi),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AQI: ${pollution.aqi}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
