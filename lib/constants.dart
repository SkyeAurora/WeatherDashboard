import 'package:flutter/material.dart';


const Color bgColor = Color(0xff3d73a5); // 背景色
const Color secondaryColor = Color(0xFFE6F7FF); // 次级颜色
const Color cardGradientStart = Color(0xFF1E638D); // 卡片渐变开始颜色
const Color cardGradientEnd = Color(0xFF4C9DCC); // 卡片渐变结束颜色
const Color titleFontColor = Colors.white; // 卡片渐变结束颜色
const Color fontColor = Colors.black87; // 卡片渐变结束颜色

const defaultPadding = 16.0;

// 天气对应的卡片颜色
const Map<String, Color> weatherCardColors = {
  'thunderstorm': Color.fromRGBO(47, 47, 69, 0.7),  // 深紫色半透明
  'rain': Color.fromRGBO(73, 89, 123, 0.7),         // 深蓝灰色半透明
  'snow': Color.fromRGBO(200, 200, 220, 0.7),       // 浅灰白色半透明
  'clear': Color.fromRGBO(64, 156, 255, 0.7),       // 天蓝色半透明
  'clouds': Color.fromRGBO(134, 134, 134, 0.7),     // 灰色半透明
};

// 天气对应的文字颜色
const Map<String, Color> weatherTextColors = {
  'thunderstorm': Colors.white,
  'rain': Colors.white,
  'snow': Colors.black87,
  'clear': Colors.white,
  'clouds': Colors.white,
};

// 默认颜色
const defaultCardColor = Color.fromRGBO(64, 156, 255, 0.7);
const defaultTextColor = Colors.white;
