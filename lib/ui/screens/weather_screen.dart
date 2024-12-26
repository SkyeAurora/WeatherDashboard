import 'dart:async';
import 'dart:math';
import 'dart:ui';
import '../../network/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:weatherdashboard/constants.dart';
import 'package:weatherdashboard/network/models/location_model.dart';
import 'package:weatherdashboard/network/services/air_pollution_service.dart';
import 'package:weatherdashboard/network/services/current_weather_service.dart';
import 'package:weatherdashboard/network/services/forecast_weather_service.dart';
import 'package:weatherdashboard/network/services/geocoding_service.dart';
import 'package:weatherdashboard/ui/widgetSections/body_leftpart_linechart.dart';
import 'package:weatherdashboard/ui/widgetSections/body_rightpart.dart';
import 'package:weatherdashboard/ui/widgets/air_pollution_card.dart';
import 'package:weatherdashboard/ui/widgets/top_bar.dart';
import 'package:weatherdashboard/ui/widgets/weather_card.dart';
import 'package:weatherdashboard/ui/widgets/forecast_weather_card.dart';
import './video_background_page.dart';
import 'package:video_player/video_player.dart';

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
  LocationModel locationModel = LocationModel(lat: 32.1299, lng: 108.8278);
  late Future<dynamic> _currentWeatherFuture;
  late Future<dynamic> _forecastWeatherFuture;
  late Future<dynamic> _airPollutionFuture;
  String _currentWeatherCondition = 'clouds';
  bool _isLoading = false;  // 添加加载状态标志

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 将初始化逻辑抽取到单独的方法
  Future<void> _initializeData() async {
    try {
      _currentWeatherFuture = CurrentWeatherService()
          .fetchWeatherData(locationModel.lat, locationModel.lng);
      
      final weatherData = await _currentWeatherFuture;
      if (mounted) {
        setState(() {
          _currentWeatherCondition = weatherData.weather[0].main.toLowerCase();
        });
      }

      _forecastWeatherFuture = ForecastWeatherService()
          .fetchForecastWeatherData(locationModel.lat, locationModel.lng);
      _airPollutionFuture = AirPollutionService()
          .fetchAirPollutionData(locationModel.lat, locationModel.lng);
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> _handleCitySearch(String cityName) async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final locationFuture = GeocodingService().fetchFGeocodingData(cityName);
      locationModel = await locationFuture;

      // 并行获取所有数据
      final currentWeatherFuture = CurrentWeatherService()
          .fetchWeatherData(locationModel.lat, locationModel.lng);
      final forecastFuture = ForecastWeatherService()
          .fetchForecastWeatherData(locationModel.lat, locationModel.lng);
      final pollutionFuture = AirPollutionService()
          .fetchAirPollutionData(locationModel.lat, locationModel.lng);

      final currentWeather = await currentWeatherFuture;
      currentWeather.name = cityName;

      setState(() {
        _currentWeatherCondition = currentWeather.weather[0].main.toLowerCase();
        _currentWeatherFuture = Future.value(currentWeather);
        _forecastWeatherFuture = forecastFuture;
        _airPollutionFuture = pollutionFuture;
      });
    } catch (e) {
      print('Error searching city: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return VideoBackgroundPage(
      weatherCondition: _currentWeatherCondition,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TopBar(
          onCitySearch: _handleCitySearch,
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildContent(),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildLeftBody(),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  color: Colors.transparent,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                        child: _buildBottomInfoView(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 
 
  // 📍 当前天气的展示卡片
  Widget _buildContent() {
    return SizedBox(
      height: 300,  // 调整整体高度
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FutureBuilder(
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
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FutureBuilder(
                future: _airPollutionFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('加载空气质量数据失败: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return AirPollutionCard(pollution: snapshot.data);
                  } else {
                    return const Center(child: Text('未能加载空气质量数据'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  
  // 📍 未来天气的展示卡片（每3小时一条）
  Widget _buildLeftBody() {
    return  FutureBuilder(
      future: _forecastWeatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('加载天气预报数据失败: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final forecastList = snapshot.data.list;
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: BodyLeftpartLinechart(weather: forecastList),
            );
        } else {
          return const Center(child: Text('未能加载天气预报数据'));
        }
      },
    );
  }
  Widget _buildBottomInfoView() {
    return Container(
      color: Colors.black.withOpacity(0.3), // 半透明黑色背景
      height: 60,
      child: const Center(
        child: Text(
          "开发者：张家和 & 张佳伟 & 张志伟 | Api调用：https://api.openweathermap.org",
          style: TextStyle(
            color: Colors.white70, // 降低文字不透明度
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
