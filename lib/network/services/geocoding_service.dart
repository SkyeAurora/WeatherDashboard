import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weatherdashboard/common/api_config.dart';
import 'package:weatherdashboard/network/models/location_model.dart';

class GeocodingService {
  Future<LocationModel> fetchFGeocodingData(String address) async {
    final url = Uri.parse('${ApiConfig.baseGDUrl}?key=${ApiConfig.key}&address=$address');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return LocationModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load forecast weather data');
    }
  }
}

// debug test
// void main() async {
//   try {
//     final LocationModel = await GeocodingService().fetchFGeocodingData("西安市长安区西安电子科技大学");
//     print("test");
//   } catch (e) {
//     print(e);
//   }
// }