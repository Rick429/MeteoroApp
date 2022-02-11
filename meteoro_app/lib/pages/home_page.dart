import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:meteoro_app/pages/settings_page.dart';
import 'package:meteoro_app/pages/weather_earth_page.dart';
import 'package:meteoro_app/pages/weather_mars_page.dart';
import 'package:meteoro_app/styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    WeatherEarthPage(),
    WeatherMarsPage(),
    SettingsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Image.asset('assets/images/tierra.png', width: 50,),
      Image.asset('assets/images/marte.png', width: 50,),
      Image.asset('assets/images/settings.png', width: 50,),
    ];
    return Scaffold(
      extendBody: true,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: MeteoroStyle.blueLightColor,
        backgroundColor: Colors.transparent,
        items: items,
        index: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}