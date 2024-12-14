import 'package:flutter/material.dart';
import 'package:weatherdashboard/ui/screens/weather_screen.dart';
import 'constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weatherdashboard/Controller/menu_app_controller.dart';

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
        appBarTheme: const AppBarTheme(
          backgroundColor: bgColor, // 应用栏背景色
          elevation: 0, // 移除阴影
        ),
      ),

      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
        ],
        child: const WeatherScreen(),
      ),
    );
  }
}
