import 'package:flutter/material.dart';
import 'package:weatherdashboard/network/services/air_pollution_service.dart';
import 'package:weatherdashboard/network/services/current_weather_service.dart';
import 'package:weatherdashboard/network/services/forecast_weather_service.dart';
import 'package:weatherdashboard/ui/widgets/air_pollution_card.dart';
import 'package:weatherdashboard/ui/widgets/weather_card.dart';
import 'package:weatherdashboard/ui/widgets/forecast_weather_card.dart';

class WeatherDashboardApp extends StatelessWidget {
  const WeatherDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final double latitude = 32.1299; // 这里可以设置为当前的纬度
  final double longitude = 108.8278; // 这里可以设置为当前的经度

  late Future<dynamic> _currentWeatherFuture;
  late Future<dynamic> _forecastWeatherFuture;
  late Future<dynamic> _airPollutionFuture;

  @override
  void initState() {
    super.initState();
    _currentWeatherFuture =
        CurrentWeatherService().fetchWeatherData(latitude, longitude);
    _forecastWeatherFuture =
        ForecastWeatherService().fetchForecastWeatherData(latitude, longitude);
    _airPollutionFuture =
        AirPollutionService().fetchAirPollutionData(latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            const Text(
              '当前天气预报',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            // 📍 当前天气的展示卡片
            FutureBuilder(
              future: _currentWeatherFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('加载当前天气数据失败: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return WeatherCard(weather: snapshot.data);
                } else {
                  return const Center(child: Text('未能加载当前天气数据'));
                }
              },
            ),

            const SizedBox(height: 24),

            const Text(
              '天气污染数据',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            FutureBuilder(
              future: _airPollutionFuture, 
              builder: (context,snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('加载天气污染数据失败: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return AirPollutionCard(airPollutionModel: snapshot.data);
                } else {
                  return const Center(child: Text('未能加载天气污染数据'));
                }
              },
            ),

            const SizedBox(height: 24),

            // 📍 天气预报的标题
            const Text(
              '未来天气预报',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // 📍 未来天气的展示卡片（每3小时一条）
            FutureBuilder(
              future: _forecastWeatherFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('加载天气预报数据失败: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final forecastList = snapshot.data.list;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // 禁止内部滚动
                    itemCount: forecastList.length,
                    itemBuilder: (context, index) {
                      return ForecastWeatherCard(forecast: forecastList[index]);
                    },
                  );
                } else {
                  return const Center(child: Text('未能加载天气预报数据'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
