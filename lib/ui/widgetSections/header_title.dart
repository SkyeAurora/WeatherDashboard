import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../network/models/weather_model.dart';

class HeaderTitle extends StatelessWidget {
  final CurrentWeatherModel weather;

  const HeaderTitle({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildHeaderTitleView();
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
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          DefaultTextStyle(
              style: const TextStyle(
                color: titleFontColor,
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
              child: _buildHeaderTitleContentView()
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTitleContentView() {
    return Column(
        children: [
          Row(
            children: [
              SelectableText('City: ${weather.name}  '),
              SelectableText('Location: ${weather.coord.formattedLocation}'), // 显示纬度
            ],
          ),

          Container(
            height: 200,
            alignment: Alignment.center,
            child: SelectableText(
              weather.main.formattedFeelTemp,
              style: const TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectableText('Pressure: ${weather.main.pressure}hPa   ', style: TextStyle(fontSize: 20)),
              SelectableText('Humidity: ${weather.main.humidity}%   ', style: TextStyle(fontSize: 20)),
              SelectableText('Wind Speed: ${weather.wind.speed} m/s   ', style: TextStyle(fontSize: 20)),
              SelectableText('Weather: ${weather.weather.first.main}', style: TextStyle(fontSize: 20))
            ],
          ),
        ]
    );
  }
}