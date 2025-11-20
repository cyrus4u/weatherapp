import 'dart:ui';

import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: AppTextThemes.textTheme16),

      home: Scaffold(
        appBar: AppBar(title: Text('Weather App'), centerTitle: true),

        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('images/images.png'),
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Text(
                        'Mountain View',
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Clear Sky',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Icon(
                        Icons.wb_sunny_outlined,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        '14°',
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
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '16°',
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '10°',
                              style: Theme.of(context).textTheme.titleMedium!
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
                          behavior: ScrollConfiguration.of(context).copyWith(
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
                                      Icon(Icons.cloud, color: Colors.white),
                                      Text(
                                        '14°',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              color: Colors.grey,
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
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '73 m/s',

                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '6:20 AM',
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '6:30 PM',
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '73%',
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: Colors.white, fontSize: 14),
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
        ),
      ),
    );
  }
}
