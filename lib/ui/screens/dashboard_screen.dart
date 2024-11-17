import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart'; // 导入定位插件
import 'package:weatherdashboard/repository/weather_repository.dart';
import 'package:weatherdashboard/bloc/weather_bloc.dart';
import '../widgets/weather_card.dart';
import 'package:weatherdashboard/network/services/current_weather_service.dart'; // 导入天气服务

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double? _latitude;
  double? _longitude;
  bool _isLoadingLocation = true; // 定位加载状态

  @override
  void initState() {
    super.initState();
    _getLocation(); // 初始化时获取位置
  }

  // 获取位置
  Future<void> _getLocation() async {
    try {
      // 检查定位服务是否启用
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      // 检查并请求权限
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied.");
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            "Location permissions are permanently denied, we cannot request permissions.");
      }

      // 获取当前位置
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _isLoadingLocation = false; // 定位加载完成
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false; // 定位失败
      });
      // 显示错误信息
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather Dashboard")),
      body: _isLoadingLocation
          ? Center(child: CircularProgressIndicator()) // 显示定位加载动画
          : _latitude != null && _longitude != null
              ? BlocProvider(
                  create: (context) => WeatherBloc(
                      repository: WeatherRepository(
                          currentWeatherService: CurrentWeatherService()))
                    ..add(FetchWeather(
                        latitude: _latitude!, longitude: _longitude!)),
                  child: BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (context, state) {
                      if (state is WeatherLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is WeatherLoaded) {
                        return WeatherCard(weather: state.weather);
                      } else if (state is WeatherError) {
                        return Center(child: Text(state.message));
                      }
                      return Container();
                    },
                  ),
                )
              : Center(
                  child: Text(
                    "Unable to fetch location data. Please enable location services.",
                    textAlign: TextAlign.center,
                  ),
                ),
    );
  }
}
