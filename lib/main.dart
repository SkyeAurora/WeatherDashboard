import 'package:flutter/material.dart';
import 'package:weatherdashboard/ui//screens/dashboard_screen.dart'; // 导入 DashboardScreen
import 'package:weatherdashboard/constants.dart';
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
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
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
