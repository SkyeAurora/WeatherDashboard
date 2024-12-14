import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart'; // 导入定位插件
import 'package:weatherdashboard/constants.dart';
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
        throw Exception("位置服务不可用！");
      }

      // 检查并请求权限
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("位置请求被拒绝，请点击Retry按钮重试！");
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception("位置请求被永久拒绝，请手动开启并点击Retry按钮重试！");
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
      appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 200.0),
            child: Row (
              children: <Widget>[
                const Expanded(
                    flex: 1,
                    child: Column (
                      crossAxisAlignment: CrossAxisAlignment.center, // 对齐方式
                      children: [
                        Text("天气预报仪表盘", style: TextStyle(color: titleFontColor),),
                        Text("Weather DashBoard", style: TextStyle(color: titleFontColor),),
                      ],
                    )
                ),

                const Expanded(flex: 1, child: Text("")),

                // 顶部Bar
                Expanded(
                  flex: 1,
                  child: TextField(
                    cursorColor: Colors.white, // 设置光标颜色为白色
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.white), // 设置图标颜色为白色
                      hintText: "输入城市名称查询天气",
                      hintStyle: const TextStyle(color: Colors.white), // 设置提示文本颜色为白色
                      filled: false, // 启用填充背景
                      fillColor: Colors.white, // 设置背景颜色为白色
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white), // 设置边框颜色为白色
                        borderRadius: BorderRadius.circular(8.0), // 圆角边框
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0), // 未聚焦时的边框颜色
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 1.0), // 聚焦时的边框颜色
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildContent(), // 主要内容
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                color: bgColor, // 设置矩形的颜色
                child: _buildBottomInfoView()
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildContent() {
    if(_isLoadingLocation) {
      return const Center(child: CircularProgressIndicator()); // 显示定位加载动画
    } else if(_latitude != null && _longitude != null) {
      return BlocProvider(
          create: (context) => WeatherBloc(
              repository: WeatherRepository(
                  currentWeatherService: CurrentWeatherService()
              )
          )..add(
              FetchWeather(latitude: _latitude!, longitude: _longitude!)
          ),
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is WeatherLoaded) {
                return WeatherCard(weather: state.weather);
              } else if (state is WeatherError) {
                return _buildErrorView();
              }
              return Container();
            },
          ),
      );
    } else {
      return _buildErrorView();
    }
  }

  Widget _buildErrorView() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            const Text(
              "Unable to fetch location data. Please enable location services.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // 添加一些间隔
            ElevatedButton(
              onPressed: () async {
                _getLocation();
              },
              child: const Text('Retry'),
            ),
          ],
        )
    );
  }
}
