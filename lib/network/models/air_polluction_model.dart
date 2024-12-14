class AirPollutionModel {
  final int aqi;

  AirPollutionModel({required this.aqi});

  factory AirPollutionModel.fromJson(Map<String, dynamic> json) {
    final list = json['list'][0]; // 取第一个列表中的数据
    final main = list['main'];
    return AirPollutionModel(
      aqi: main['aqi'], // 只提取 aqi
    );
  }
}