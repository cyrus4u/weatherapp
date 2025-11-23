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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: AppTextThemes.textTheme16),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController searchController = TextEditingController();

  // Streams
  final StreamController<CurrentCityDataModel> _streamCurrentWeather =
      StreamController.broadcast();
  StreamController<List<ForecastDaysModel>> _streamForecast5Days3Hours =
      StreamController.broadcast();
  var apikey = 'd7d97df61b04b338395566181c25c0f7';

  var cityName = 'tehran';
  late double lat;
  late double lon;

  @override
  void initState() {
    super.initState();
    loadWeather("tehran");
  }

  @override
  void dispose() {
    _streamCurrentWeather.close();
    _streamForecast5Days3Hours.close();
    super.dispose();
  }

  Future<void> loadWeather(String cityName) async {
    try {
      // 1. Fetch city coordinates
      final CityNameModel city = await sendRequestCityName(cityName);

      // 2. Fetch current weather
      final CurrentCityDataModel current = await sendRequestCurrentWeather(
        city.lat,
        city.lon,
      );
      _streamCurrentWeather.add(current);

      // 3. Fetch 5 day / 3 hour forecast data
      final List<ForecastDaysModel> forecast =
          await sendRequest5Days3HoursForecast(city.lat, city.lon);
      _streamForecast5Days3Hours.add(forecast);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('City not found or network error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

      body: StreamBuilder<CurrentCityDataModel>(
        stream: _streamCurrentWeather.stream,
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
                              SizedBox(
                                height: 55, // Set the height for BOTH widgets
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final messenger = ScaffoldMessenger.of(
                                      context,
                                    );
                                    final cityName = searchController.text
                                        .trim();

                                    if (cityName.isEmpty) {
                                      messenger.showSnackBar(
                                        const SnackBar(
                                          content: Text('Enter a city name'),
                                        ),
                                      );
                                      return;
                                    }

                                    try {
                                      await loadWeather(cityName);
                                    } catch (e) {
                                      messenger.showSnackBar(
                                        const SnackBar(
                                          content: Text('City not found'),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withAlpha(
                                      70,
                                    ), // MATCH TEXTFIELD
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ), // MATCH TEXTFIELD
                                    ),
                                    minimumSize: const Size(
                                      80,
                                      55,
                                    ), // MATCH HEIGHT
                                  ),
                                  child: const Text(
                                    'Find',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: SizedBox(
                                  height: 55, // SAME HEIGHT
                                  child: TextField(
                                    controller: searchController,
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
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Text(
                            cityDataModel!.cityname,
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            cityDataModel.description,
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
                            style: TextStyle(fontSize: 60, color: Colors.white),
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
                                      .copyWith(color: Colors.white),
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
                                      .copyWith(color: Colors.white),
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
                        SizedBox(
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
                              child: StreamBuilder<List<ForecastDaysModel>>(
                                stream: _streamForecast5Days3Hours.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<ForecastDaysModel>? forcastDays =
                                        snapshot.data;
                                    return ListView.builder(
                                      itemCount: 6,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return listViewItems(
                                          forcastDays![index],
                                        );
                                      },
                                    );
                                  } else {
                                    return Center(
                                      child: JumpingDotsProgressIndicator(
                                        color: Colors.white,
                                        fontSize: 60,
                                        dotSpacing: 2,
                                      ),
                                    );
                                  }
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
                                      .copyWith(color: Colors.white),
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
                                      .copyWith(color: Colors.white),
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
                                      .copyWith(color: Colors.white),
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
                                      .copyWith(color: Colors.white),
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
    );
  }

  Widget listViewItems(ForecastDaysModel forecastday) {
    return SizedBox(
      height: 50,
      width: 70,
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          children: [
            Text(
              forecastday.data_time.toFormattedTime(forecastday.timezoneOffset),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            Expanded(child: setIconForMain(forecastday)),
            Text(
              '${forecastday.temp.round()}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
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

  Future<CityNameModel> sendRequestCityName(String cityName) async {
    var response = await Dio().get(
      'https://api.openweathermap.org/geo/1.0/direct',
      queryParameters: {'q': cityName, 'appid': apikey, 'limit': 1},
    );

    if (response.data.isEmpty) {
      throw Exception('City not found');
    }

    return CityNameModel.fromJson(response.data[0]);
  }

  Future<CurrentCityDataModel> sendRequestCurrentWeather(
    double lat,
    double lon,
  ) async {
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

    final model = CurrentCityDataModel.fromJson(response.data);
    return model;
  }

  // Call 5 day / 3 hour forecast data
  Future<List<ForecastDaysModel>> sendRequest5Days3HoursForecast(
    double lat,
    double lon,
  ) async {
    final response = await Dio().get(
      'https://api.openweathermap.org/data/2.5/forecast',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': apikey,
        'units': 'metric',
        'lang': 'en',
      },
    );

    final cityTimezone = response.data['city']['timezone'];

    final List<ForecastDaysModel> forecastDays = [];

    for (var item in response.data['list']) {
      final model = ForecastDaysModel.fromJson(item);
      model.timezoneOffset = cityTimezone;
      forecastDays.add(model);
    }

    return forecastDays;
  }
}
