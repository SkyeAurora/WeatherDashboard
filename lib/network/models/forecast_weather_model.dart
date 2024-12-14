class ForecastWeatherModel {
  final List<ForecastWeather> list;

  ForecastWeatherModel({required this.list});

  factory ForecastWeatherModel.fromJson(Map<String, dynamic> json) {
    List<ForecastWeather> forecasts = (json['list'] as List)
        .map((forecastJson) => ForecastWeather.fromJson(forecastJson))
        .toList();
    return ForecastWeatherModel(list: forecasts);
  }
}

class ForecastWeather {
  final String dtTxt; // 预测的时间
  final MainWeatherData main; // 温度、最高温、最低温
  final List<WeatherDescription> weather; // 天气描述

  ForecastWeather({required this.dtTxt, required this.main, required this.weather});

  factory ForecastWeather.fromJson(Map<String, dynamic> json) {
    return ForecastWeather(
      dtTxt: json['dt_txt'],
      main: MainWeatherData.fromJson(json['main']),
      weather: (json['weather'] as List)
          .map((weatherJson) => WeatherDescription.fromJson(weatherJson))
          .toList(),
    );
  }
}

class MainWeatherData {
  final double temp; // 当前温度
  final double tempMin; // 最低温度
  final double tempMax; // 最高温度

  MainWeatherData({required this.temp, required this.tempMin, required this.tempMax});

  factory MainWeatherData.fromJson(Map<String, dynamic> json) {
    return MainWeatherData(
      temp: json['temp'].toDouble(),
      tempMin: json['temp_min'].toDouble(),
      tempMax: json['temp_max'].toDouble(),
    );
  }
}

class WeatherDescription {
  final String main; // "Rain", "Clouds" 等主要的天气名称
  final String description; // "light rain", "scattered clouds" 等详细的描述

  WeatherDescription({required this.main, required this.description});

  factory WeatherDescription.fromJson(Map<String, dynamic> json) {
    return WeatherDescription(
      main: json['main'],
      description: json['description'],
    );
  }
}
