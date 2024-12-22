// lib/network/models/weather_model.dart

class CurrentWeatherModel {
  final Coord coord;
  final List<Weather> weather;
  final String base;
  final Main main;
  final int visibility;
  final Wind wind;
  final Clouds clouds;
  final int dt;
  final Sys sys;
  final int timezone;
  final int id;
  final String name;
  final int cod;

  CurrentWeatherModel({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      coord: Coord.fromJson(json['coord']),
      weather: (json['weather'] as List)
          .map((item) => Weather.fromJson(item))
          .toList(),
      base: json['base'],
      main: Main.fromJson(json['main']),
      visibility: json['visibility'],
      wind: Wind.fromJson(json['wind']),
      clouds: Clouds.fromJson(json['clouds']),
      dt: json['dt'],
      sys: Sys.fromJson(json['sys']),
      timezone: json['timezone'],
      id: json['id'],
      name: json['name'],
      cod: json['cod'],
    );
  }

  @override
  String toString() {
    return
        '  ${coord.formattedLocation},\n'
        '  $weather, \n'
        '  base: $base,\n'
        '  $main,\n'
        '  能见度: $visibility,\n'
        '  wind: $wind,\n'
        '  clouds: $clouds,\n'
        '  dt: $dt,\n'
        '  sys: $sys,\n'
        '  timezone: $timezone,\n'
        '  id: $id,\n'
        '  name: $name,\n'
        '  cod: $cod\n';
  }
}

class Coord {
  final double lon;
  final double lat;

  Coord({required this.lon, required this.lat});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lon: json['lon']?.toDouble() ?? 0.0,
      lat: json['lat']?.toDouble() ?? 0.0,
    );
  }

  // 格式化的经纬度字符串，保留一位小数
  String get formattedLocation => ' (${lat.toStringAsFixed(1)}, ${lon.toStringAsFixed(1)})';
}

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  @override
  String toString() =>
      'weather: id: $id,  main: $main,  description: $description,  icon: $icon';
}

class Main {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double seaLevel;
  final double grndLevel;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.grndLevel,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'],
      feelsLike: json['feels_like'],
      tempMin: json['temp_min'],
      tempMax: json['temp_max'],
      pressure: json['pressure'],
      humidity: json['humidity'],
      seaLevel: json['sea_level'] ?? 0.0,
      grndLevel: json['grnd_level'] ?? 0.0,
    );
  }

  int get formattedTempMax => (tempMax - 273.15).toInt();
  int get formattedTempMin => (tempMin - 273.15).toInt();
  String get formattedFeelTemp => '${(feelsLike - 273.15).toStringAsFixed(1)}°C';

  @override
  String toString() =>
      'main: [temp: $temp,  feelsLike: $feelsLike,  tempMin: $tempMin,  tempMax: $tempMax,  pressure: $pressure,  humidity: $humidity]';
}

class Wind {
  final double speed;
  final int deg;
  final double gust;

  Wind({
    required this.speed,
    required this.deg,
    required this.gust,
  });

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed'],
      deg: json['deg'],
      gust: json['gust'] ?? 0.0,
    );
  }
  @override
  String toString() => '[speed: $speed,  deg: $deg]';
}

class Clouds {
  final int all;

  Clouds({required this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(
      all: json['all'],
    );
  }
  @override
  String toString() => ' all: $all';
}

class Sys {
  final String country;
  final int sunrise;
  final int sunset;

  Sys({
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      country: json['country'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }
  @override
  String toString() =>
      '[country: $country,  sunrise: $sunrise,  sunset: $sunset]';
}
