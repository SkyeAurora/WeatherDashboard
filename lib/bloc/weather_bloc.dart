// 逻辑控制（使用Bloc或Provider模式管理状态）

// lib/bloc/weather_bloc.dart
// lib/bloc/weather_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherdashboard/repository/weather_repository.dart';
import '../network/models/weather_model.dart';

// 定义事件和状态
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
