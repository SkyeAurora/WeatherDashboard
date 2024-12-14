// lib/widgets/weather_card.dart
import 'package:flutter/material.dart';
import 'package:weatherdashboard/constants.dart';
import 'package:weatherdashboard/network/models/weather_model.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: _buildHeaderTitleView(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: _buildHeaderTitleView(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: _buildHeaderTitleView(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTitleView() {
    return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              cardGradientStart,
              cardGradientEnd
            ],
          ), // 背景颜色
          borderRadius: BorderRadius.circular(16.0), // 圆角半径
        ),
        width: double.infinity,
        // margin: ,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            DefaultTextStyle(
                style: const TextStyle(
                    color: titleFontColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                ),
                child: Column(
                  children: [
                    Text('City: ${weather.name}'),
                    Text('Location: ${weather.coord.formattedLocation}', style: TextStyle(fontSize: 20)), // 显示纬度
                    Text('Temperature: ${weather.main.temp} °K', style: TextStyle(fontSize: 20)),
                    Text('Weather: ${weather.weather.first.description}', style: TextStyle(fontSize: 20)),
                    Text('Humidity: ${weather.main.humidity}%', style: TextStyle(fontSize: 20)),
                    Text('Wind Speed: ${weather.wind.speed} m/s', style: TextStyle(fontSize: 20)),
                  ]
                )
            )
          ],
        ),
    );
  }
}
