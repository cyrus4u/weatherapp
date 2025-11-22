import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:weatherapp/extension/unix_time_intl.dart';
import 'package:weatherapp/model/city_name_model.dart';
import 'package:weatherapp/model/current_city_data_model.dart';
import 'package:weatherapp/model/forcast_day_model.dart';
import 'package:weatherapp/theme/text_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController textEditingController = TextEditingController();
  late Future<CurrentCityDataModel> weatherFuture;

  late StreamController<List<ForecastDaysModel>> streamForecastDays;
  // late StreamController<CurrentCityDataModel> streamCurrentWeather;

  var apikey = 'd7d97df61b04b338395566181c25c0f7';

  var cityName = 'NEW YORK';
  late double lat;
  late double lon;
  @override
  void initState() {
    super.initState();
    weatherFuture = loadWeather(cityName);
    streamForecastDays = StreamController<List<ForecastDaysModel>>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: AppTextThemes.textTheme16),

      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 47, 33, 243),
          title: Text('Weather App', style: TextStyle(color: Colors.white)),
          elevation: 0,
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<String>(
              itemBuilder: (context) {
                return {'Setting', 'Profile', 'Logout', 'Login'}.map((e) {
                  return PopupMenuItem(value: e, child: Text(e));
                }).toList();
              },
            ),
          ],
        ),

        body: FutureBuilder<CurrentCityDataModel>(
          future: weatherFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CurrentCityDataModel? cityDataModel = snapshot.data;
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('images/images.png'),
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text('find'),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: textEditingController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white.withAlpha(70),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: 'Enter city name',
                                      hintStyle: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Text(
                              cityDataModel!.cityname,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              cityDataModel.description,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: setIconForMain(cityDataModel),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              '${cityDataModel.temp.round()}°',
                              style: TextStyle(
                                fontSize: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Max',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '${cityDataModel.temp_max.round()}°',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.white,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'min',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '${cityDataModel.temp_min.round()}°',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Container(
                              color: Colors.grey,
                              height: 1,
                              width: double.infinity,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 80,
                            child: Center(
                              child: ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context)
                                    .copyWith(
                                      dragDevices: {
                                        PointerDeviceKind.mouse,
                                        PointerDeviceKind.touch,
                                        PointerDeviceKind.trackpad,
                                      },
                                    ),
                                child: ListView.builder(
                                  itemCount: 6,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: 50,
                                      width: 70,
                                      child: Card(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: Column(
                                          children: [
                                            Text(
                                              'Fri, 8pm',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                  ),
                                            ),
                                            Icon(
                                              Icons.cloud,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              '14°',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Container(
                              color: Colors.grey,
                              height: 1,
                              width: double.infinity,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Wind Speed',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '${cityDataModel.wind_speed} m/s',

                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.white,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Sunrise',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    cityDataModel.sunrise.toFormattedTime(
                                      cityDataModel.timezone,
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.white,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Sunset',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    cityDataModel.sunset.toFormattedTime(
                                      cityDataModel.timezone,
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.white,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Humidity',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '${cityDataModel.humidity} %',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: JumpingDotsProgressIndicator(
                  color: Colors.black,
                  fontSize: 60,
                  dotSpacing: 2,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Image setIconForMain(model) {
    String description = model.description;
    if (description.contains('few clouds') ||
        (description.contains('partly sunny'))) {
      return Image.asset('images/partly-cloudy.png');
    } else if (description.contains('cloudy')) {
      return Image.asset('images/cloud.png');
    } else if (description.contains('fog')) {
      return Image.asset('images/fog.png');
    } else if (description.contains('thunderstorm')) {
      return Image.asset('images/thunderstorm.png');
    } else if (description.contains('light rain')) {
      return Image.asset('images/light_rain.png');
    } else if (description.contains('rain')) {
      return Image.asset('images/rain.png');
    } else if (description.contains('sunny') ||
        description.contains('clear sky')) {
      return Image.asset('images/sunny.png');
    } else if (description.contains('snow')) {
      return Image.asset('images/snow.png');
    } else {
      return Image.asset('images/windy.png');
    }
  }

  Future<CurrentCityDataModel> loadWeather(String cityName) async {
    var city = await sendRequestCityName(cityName);
    return await sendRequestCurrentWeather(city.lat, city.lon);
  }

  Future<CityNameModel> sendRequestCityName(String cityName) async {
    try {
      var response = await Dio().get(
        'http://api.openweathermap.org/geo/1.0/direct',
        queryParameters: {'q': cityName, 'appid': apikey, 'limit': 1},
      );
      if (response.data.isEmpty) {
        throw Exception('City not found');
      }
      var dataModel = CityNameModel.fromJson(response.data[0]);
      print('City: $cityName => Lat: ${dataModel.lat}, Lon: ${dataModel.lon}');
      return dataModel;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('City not found')));
      throw Exception('City not found');
    }
  }

  Future<CurrentCityDataModel> sendRequestCurrentWeather(
    double lat,
    double lon,
  ) async {
    try {
      var response = await Dio().get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apikey,
          'units': 'metric',
          'lang': 'en',
        },
      );
      print('Weather Data: ${response.data}');
      var dataModel = CurrentCityDataModel.fromJson(response.data);
      // streamCurrentWeather.add(dataModel);
      return dataModel;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching current forecast: $e')),
      );
      throw Exception('City not found');
    }
  }

  void sendRequest7DaysForecast(double lat, double lon) async {
    try {
      var response = await Dio().get(
        'https://api.openweathermap.org/data/2.5/forecast',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apikey,
          'units': 'metric',
          'lang': 'en',
          'cnt': 6,
        },
      );
      final cityTimezone =
          response.data['city']['timezone']; // <--- Add this line

      List<ForecastDaysModel> forecastDays = [];
      for (var item in response.data['list']) {
        var model = ForecastDaysModel.fromJson(item);
        model.timezoneOffset =
            cityTimezone; // <--- Save timezone for formatting
        forecastDays.add(model);
      }
      streamForecastDays.add(forecastDays);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching 3-hour forecast: $e')),
      );
    }
  }
}
