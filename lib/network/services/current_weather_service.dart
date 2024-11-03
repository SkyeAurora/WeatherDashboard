import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherdashboard/common/api_config.dart';
import 'package:weatherdashboard/network/models/weather_model.dart';

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

// debug test
void main() async {
  try {
    final currentWeatherModel = await CurrentWeatherService().fetchWeatherData(34, 108);
    print("test");
  } catch (e) {
    print(e);
  }
}
