import 'package:flutter/material.dart';
import 'package:meteoro_app/pages/home_page.dart';
import 'package:meteoro_app/pages/settings_page.dart';
import 'package:meteoro_app/pages/weather_earth_page.dart';
import 'package:meteoro_app/pages/weather_mars_page.dart';
import 'package:meteoro_app/utils/preferences.dart';

void main() {
  
  runApp(const MyApp());
  PreferenceUtils.init();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); 

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute:'/settings',
      routes: {
        '/': (context) => const HomePage(),
        '/earth': (context) => const WeatherEarthPage(),
        '/mars': (context) => const WeatherMarsPage(),
        '/settings': (context) => const SettingsPage(),
      },

    );
  }
}
