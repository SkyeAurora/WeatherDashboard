class LocationModel {
  final double lat;
  final double lng;

  LocationModel({required this.lat, required this.lng});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    // 解析 location 字符串并分割成经纬度
    final location = json['geocodes'][0]['location'].split(',');
    return LocationModel(
      lng: double.parse(location[0]),
      lat: double.parse(location[1]),
    );
  }
}