class CurrentCityDataModel {
  final String cityname;
  final double lon;
  final double lat;
  final String main;
  final String description;
  final double temp;
  final double temp_min;
  final double temp_max;
  final int pressure;
  final int humidity;
  final double wind_speed;
  final int data_time;
  final String country;
  final int sunrise; // ✅ must be int
  final int sunset; // ✅ must be int
  final int timezone; // <--- add this

  CurrentCityDataModel({
    required this.cityname,
    required this.lon,
    required this.lat,
    required this.main,
    required this.description,
    required this.temp,
    required this.temp_min,
    required this.temp_max,
    required this.pressure,
    required this.humidity,
    required this.wind_speed,
    required this.data_time,
    required this.country,
    required this.sunrise,
    required this.sunset,
    required this.timezone,
  });

  factory CurrentCityDataModel.fromJson(Map<String, dynamic> json) {
    return CurrentCityDataModel(
      cityname: json['name'],
      lon: (json['coord']['lon'] as num).toDouble(),
      lat: (json['coord']['lat'] as num).toDouble(),
      main: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      temp: (json['main']['temp'] as num).toDouble(),
      temp_min: (json['main']['temp_min'] as num).toDouble(),
      temp_max: (json['main']['temp_max'] as num).toDouble(),
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      wind_speed: (json['wind']['speed'] as num).toDouble(),
      data_time: json['dt'],
      country: json['sys']['country'],
      sunrise: json['sys']['sunrise'], // ✅ int type
      sunset: json['sys']['sunset'], // ✅ int type
      timezone: json['timezone'], // <--- add this line
    );
  }
}
