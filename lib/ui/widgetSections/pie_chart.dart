import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../network/models/forecast_weather_model.dart';

class PieChart extends StatelessWidget {
  final List<ForecastWeather> weather;

  const PieChart({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(mainData());
  }

  LineChartData mainData() {
    final List<double> maxTemps = [];
    final List<double> minTemps = [];
    DateTime currentTime = DateTime.now();
    int hoursToAdd = 0;

    // 收集温度数据
    for (var forecast in weather) {
      maxTemps.add(forecast.main.tempMax - 273.15); // 转换为摄氏度
      minTemps.add(forecast.main.tempMin - 273.15);
    }

    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
              weather.length, (index) => FlSpot(index.toDouble(), maxTemps[index])),
          isCurved: false,
          color: Colors.red,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
        LineChartBarData(
          spots: List.generate(
              weather.length, (index) => FlSpot(index.toDouble(), minTemps[index])),
          isCurved: false,
          color: Colors.blue,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
      ],
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index < 0 || index >= weather.length) return const Text('');

              // 根据 index 动态生成时间点
              DateTime forecastTime = currentTime.add(Duration(hours: index * 3));
              String formattedTime = '${forecastTime.month}/${forecastTime.day} ${forecastTime.hour}:00';

              // 返回时间标题
              return Container(
                width: 30,
                child: Text(
                    formattedTime, style: TextStyle(fontSize: 10)
                ),
              );
            },
            reservedSize: 28,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => Text('${value.toInt()}°C', style: const TextStyle(fontSize: 12)),
            reservedSize: 40,
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withOpacity(0.5))),
      minX: 0,
      maxX: weather.length.toDouble() - 1,
      minY: minTemps.reduce((a, b) => a < b ? a : b) - 5,
      maxY: maxTemps.reduce((a, b) => a > b ? a : b) + 5,
      gridData: FlGridData(show: true, drawVerticalLine: false),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              int index = barSpot.x.toInt();
              DateTime forecastTime = currentTime.add(Duration(hours: index * 3));
              String xValue = '${forecastTime.month}/${forecastTime.day} ${forecastTime.hour}:00';
              String yValue = barSpot.y.toStringAsFixed(1) + '°C';
              return LineTooltipItem('$xValue\n$yValue', const TextStyle(color: Colors.white));
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
    );
  }
}
