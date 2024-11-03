import 'package:flutter/material.dart';
import 'package:weatherdashboard/ui/screens/dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardScreen(latitude: 34.0, longitude: 108.0), // 传入经纬度
    );
  }
}