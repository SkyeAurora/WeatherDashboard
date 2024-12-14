import 'package:flutter/material.dart';
import 'package:weatherdashboard/ui/screens/weather_screen.dart';
import '';

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
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: secondaryColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black87), // 使用更深的颜色以提高对比度
        canvasColor: secondaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: bgColor, // 应用栏背景色
          elevation: 0, // 移除阴影
        ),
      ),
      // home: const DashboardScreen(), // 设置主页面为 DashboardScreen
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
        ],
        child: DashboardScreen(),
      ),
    );
  }
}
