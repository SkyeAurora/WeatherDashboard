import 'package:flutter/material.dart';
import 'package:weatherdashboard/ui//screens/dashboard_screen.dart'; // 导入 DashboardScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 去掉调试标志
      title: 'Weather Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardScreen(), // 设置主页面为 DashboardScreen
    );
  }
}
