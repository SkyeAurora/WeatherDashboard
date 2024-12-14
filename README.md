# WeatherDashboard

A new Flutter project.

WeatherDashBoard based on Flutter.

## 环境搭建

文档: https://docs.flutter.cn/get-started/install

## 项目环境

```
PS C:\Users\m1529\Desktop\flutter-project\openweather-flutter-dashboard\weatherdashboard> flutter doctor -v
[√] Flutter (Channel stable, 3.24.4, on Microsoft Windows [版本 10.0.22000.2538], locale zh-CN)
    • Flutter version 3.24.4 on channel stable at C:\flutter
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision 603104015d (10 days ago), 2024-10-24 08:01:25 -0700
    • Engine revision db49896cf2
    • Dart version 3.5.4
    • DevTools version 2.37.3

[√] Windows Version (Installed version of Windows is version 10 or higher)

[√] Android toolchain - develop for Android devices (Android SDK version 35.0.0)
    • Android SDK at D:\SDK
    • Platform android-35, build-tools 35.0.0
    • ANDROID_HOME = D:\SDK
    • Java binary at: D:\Android Studio\jbr\bin\java
    • Java version OpenJDK Runtime Environment (build 17.0.11+0--11852314)
    • All Android licenses accepted.

[√] Chrome - develop for the web
    • Chrome at C:\Users\m1529\AppData\Local\Google\Chrome\Application\chrome.exe

[√] Visual Studio - develop Windows apps (Visual Studio Community 2022 17.3.3)
    • Visual Studio at C:\Program Files\Microsoft Visual Studio\2022\Community
    • Visual Studio Community 2022 version 17.3.32825.248
    • Windows 10 SDK version 10.0.19041.0

[√] Android Studio (version 2024.1)
    • Android Studio at D:\Android Studio
    • Flutter plugin can be installed from:
       https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
       https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 17.0.11+0--11852314)

[√] IntelliJ IDEA Ultimate Edition (version 2021.3)
    • IntelliJ at C:\Program Files\JetBrains\IntelliJ IDEA 2021.3.3
    • Flutter plugin can be installed from:
       https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
       https://plugins.jetbrains.com/plugin/6351-dart

[√] Connected device (3 available)
    • Windows (desktop) • windows • windows-x64    • Microsoft Windows [版本 10.0.22000.2538]
    • Chrome (web)      • chrome  • web-javascript • Google Chrome 130.0.6723.92
    • Edge (web)        • edge    • web-javascript • Microsoft Edge 123.0.2420.81

[!] Network resources
    X A network error occurred while checking "https://maven.google.com/": 信号灯超时时间已到


! Doctor found issues in 1 category.
```

## 项目结构

**common**: 通用模块

**network**: 网络模块
    **models**: 数据模型
    **services**: API服务类
    **api_services.dart**: 总服务类 

**repository**: 数据仓库层 

**bloc**: Bloc或Provider逻辑控制

**ui**: ui界面展示

## 跑通API调用

1. 在`current_weather_service`中调用API得到JSON数据并解析得到`CurrentWeatherModel`

```dart
class CurrentWeatherService {
  final String _baseUrl = '${ApiConfig.baseWeatherUrl}weather';

  Future<CurrentWeatherModel> fetchWeatherData(
      double latitude, double longitude) async {
    final url = Uri.parse('$_baseUrl?lat=$latitude&lon=$longitude&appid=${ApiConfig.apiKey}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return CurrentWeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load current weather');
    }
  }
}
```

![test](https://huaperion-blog-pic.oss-cn-beijing.aliyuncs.com/Blog/202411031657976.jpg)

2. 将service封装到repository中

```dart
class WeatherRepository {
  final CurrentWeatherService currentWeatherService;
  // TODO 未来可添加多种service

  WeatherRepository({
    required this.currentWeatherService,
  });

  Future<CurrentWeatherModel> getCurrentWeather(double latitude, double longitude) {
    return currentWeatherService.fetchWeatherData(latitude, longitude);
  }

  // Future<WeatherForecastModel> getForecastWeather(double latitude, double longitude) {
  //   return forecastWeatherService.fetchForecastWeather(latitude, longitude);
  // }
}
```

3. 定义事件和状态

```dart
abstract class WeatherEvent {}

class FetchWeather extends WeatherEvent {
  final double latitude;
  final double longitude;

  FetchWeather({required this.latitude, required this.longitude});
}

abstract class WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final CurrentWeatherModel weather; // 确保这里是您定义的天气模型

  WeatherLoaded({required this.weather});
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}

// Bloc类
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc({required this.repository}) : super(WeatherLoading()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await repository.getCurrentWeather(event.latitude, event.longitude);
        emit(WeatherLoaded(weather: weather));
      } catch (e) {
        emit(WeatherError("Failed to fetch weather: ${e.toString()}"));
      }
    });
  }
}
```

4. 界面

```dart
class DashboardScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const DashboardScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather Dashboard")),
      body: BlocProvider(
        create: (context) => WeatherBloc(
          repository: WeatherRepository(
            currentWeatherService: CurrentWeatherService(),
          ),
        )..add(FetchWeather(latitude: latitude, longitude: longitude)), // 添加事件
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
      ),
    );
  }
}

// WeatherCard
class WeatherCard extends StatelessWidget {
  final CurrentWeatherModel weather;

  const WeatherCard({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('City: ${weather.name}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('Temperature: ${weather.main.temp} °K', style: TextStyle(fontSize: 20)),
          Text('Feels Like: ${weather.main.feelsLike} °K', style: TextStyle(fontSize: 20)),
          Text('Weather: ${weather.weather.first.description}', style: TextStyle(fontSize: 20)),
          Text('Humidity: ${weather.main.humidity}%', style: TextStyle(fontSize: 20)),
          Text('Wind Speed: ${weather.wind.speed} m/s', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
```

5. 跑通main

```dart
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
      home: DashboardScreen(latitude: 34.128, longitude: 108.832), // 传入经纬度
    );
  }
}
```

![跑通](https://huaperion-blog-pic.oss-cn-beijing.aliyuncs.com/Blog/202411031657527.jpg)

## 定位服务实现

1. 安装依赖

在`pubspec.ymal`中添加以下依赖
```ymal
dependencies:
  geolocator: ^10.0.1
  permission_handler: ^11.0.0

```

然后运行`flutter pub get`安装依赖

2. 配置权限

**Android**

- 修改`AndroidManifest.xml`在`android/app/src/main/AndroidManifest.xml`文件中添加以下权限: 
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

- 确保`minSdkVersion`为 21或更高,在`android/app/build.gradle`中:
```gradle
defaultConfig {
    minSdkVersion 21
}
```

**IOS**

- 修改`ios/Runner/Info.plist`: 在`Info.plist`文件中添加以下内容:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to provide weather updates</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to provide weather updates</string>
```

**Chrome**

浏览器访问地理定位API需要HTTPS或者localhost，否则会因为安全限制而失败。

- 本地开发：
使用`flutter run -d chrome`命令运行时，Flutter 默认会通过 localhost 提供服务，无需额外配置。
- 生产环境：
部署时确保使用 HTTPS。

在使用时浏览器会弹出权限提示，确保正常授权即可。

3. 定位服务实现 

编写定位逻辑:
```dart
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    // 检查定位权限
    if (await _handleLocationPermission()) {
      try {
        // 获取当前位置
        return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      } catch (e) {
        print("Error getting location: $e");
        return null;
      }
    }
    return null;
  }

  Future<bool> _handleLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      return true;
    } else {
      print("Location permission denied.");
      return false;
    }
  }
}
```

4. 项目集成

在`lib/ui/screens/dashboard_screen.dart`中直接编写定位服务，后续可以单独拉出来做一个service:

```dart
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
```

5. 结果展示

![](https://huaperion-blog-pic.oss-cn-beijing.aliyuncs.com/Blog/202411171128222.png)