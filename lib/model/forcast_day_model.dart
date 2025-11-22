class ForecastDaysModel {
  final int data_time;
  final double temp;
  final String main;
  final String description;
  int? timezoneOffset; // <--- add this
  

  ForecastDaysModel({
    required this.data_time,
    required this.temp,
    required this.main,
    required this.description,
     this.timezoneOffset
  });
  
  factory ForecastDaysModel.fromJson(Map<String, dynamic> json) {
    return ForecastDaysModel(
      data_time: json['dt'],
      temp: (json['main']['temp'] as num).toDouble(),
      main: json['weather'][0]['main'],
      description:  json['weather'][0]['description'],

    );
  }
}