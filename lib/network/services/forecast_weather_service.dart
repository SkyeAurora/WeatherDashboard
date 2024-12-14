import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weatherdashboard/common/api_config.dart';
import 'package:weatherdashboard/network/models/forecast_weather_model.dart';

class ForecastWeatherService {
  final String _baseUrl = '${ApiConfig.baseWeatherUrl}forecast';

  Future<ForecastWeatherModel> fetchForecastWeatherData(double latitude, double longitude) async {
    final url = Uri.parse('$_baseUrl?lat=$latitude&lon=$longitude&appid=${ApiConfig.apiKey}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return ForecastWeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load forecast weather data');
    }
  }
}

// debug test
// void main() async {
//   try {
//     final ForecastWeatherModel = await ForecastWeatherService().fetchForecastWeatherData(34, 108);
//     print("test");
//   } catch (e) {
//     print(e);
//   }
// }

