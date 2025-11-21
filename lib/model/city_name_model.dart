class CityNameModel {
  final double lat;
  final double lon;
  CityNameModel({required this.lat, required this.lon});
  factory CityNameModel.fromJson(Map<String, dynamic> json) {
    return CityNameModel(lat: json['lat'], lon: json['lon']);
  }
}
