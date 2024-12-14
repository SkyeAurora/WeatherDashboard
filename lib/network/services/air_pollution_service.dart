import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weatherdashboard/common/api_config.dart';
import 'package:weatherdashboard/network/models/air_polluction_model.dart';

class AirPollutionService {
  final String _baseUrl = '${ApiConfig.baseWeatherUrl}air_pollution';

  Future<AirPollutionModel> fetchAirPollutionData(double latitude, double longitude) async {
    final url = Uri.parse('$_baseUrl?lat=$latitude&lon=$longitude&appid=${ApiConfig.apiKey}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return AirPollutionModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load forecast weather data');
    }
  }
}

// debug test
// void main() async {
//   try {
//     final AirPollutionModelModel = await AirPollutionService().fetchAirPollutionData(34, 108);
//     print("test");
//   } catch (e) {
//     print(e);
//   }
// }

