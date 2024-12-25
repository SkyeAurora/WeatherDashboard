import 'dart:math';
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
  LocationModel locationModel=LocationModel(lat: 32.1299,lng: 108.8278);
  late Future<dynamic> _currentWeatherFuture;
  late Future<dynamic> _forecastWeatherFuture;
  late Future<dynamic> _airPollutionFuture;
  @override
  void initState() {
    super.initState();
    _currentWeatherFuture =
        CurrentWeatherService().fetchWeatherData(locationModel.lat, locationModel.lng);
    _forecastWeatherFuture =
        ForecastWeatherService().fetchForecastWeatherData(locationModel.lat, locationModel.lng);
    _airPollutionFuture =
        AirPollutionService().fetchAirPollutionData(locationModel.lat, locationModel.lng);

  }

  void _handleCitySearch(String cityName) async{
    Future<LocationModel>_locationFuture = GeocodingService().fetchFGeocodingData(cityName);
    locationModel =await _locationFuture;
    _currentWeatherFuture =
        CurrentWeatherService().fetchWeatherData(locationModel.lat, locationModel.lng);
    CurrentWeatherModel currentWeatherModel1=await _currentWeatherFuture;
    currentWeatherModel1.name=cityName;
    setState(() {
    _currentWeatherFuture=Future.value(currentWeatherModel1);
    _forecastWeatherFuture =
        ForecastWeatherService().fetchForecastWeatherData(locationModel.lat, locationModel.lng);
    _airPollutionFuture =
        AirPollutionService().fetchAirPollutionData(locationModel.lat, locationModel.lng);  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ), // 主要内容
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 60,
                  color: const Color.fromARGB(255, 106, 61, 165), // 设置矩形的颜色
                  child: _buildBottomInfoView()
              ),
            ),
          ),
        ],
      ),
    );
  }
 
 
  // 📍 当前天气的展示卡片
  Widget _buildContent() {
    return FutureBuilder(
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
    return const Center(//0xFFA5A3A3
      child: Text(
        "开发者：张家和 & 张佳伟 & 张志伟 | Api调用：https://api.openweathermap.org",
        style: TextStyle(color: titleFontColor),
      ),
    );
  }
}
