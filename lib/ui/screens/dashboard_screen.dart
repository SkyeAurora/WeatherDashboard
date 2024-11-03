// lib/screens/dashboard_screen.dart
// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherdashboard/repository/weather_repository.dart';
import '../../bloc/weather_bloc.dart';
import '../widgets/weather_card.dart';
import 'package:weatherdashboard/network/services/current_weather_service.dart';

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
