import 'dart:convert';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/material.dart';
import 'package:meteoro_app/models/weather_earth_response.dart';
import 'package:meteoro_app/models/weather_seven_days_response.dart';
import 'package:meteoro_app/styles.dart';
import 'package:http/http.dart' as http;
import 'package:meteoro_app/utils/constants.dart';
import 'package:meteoro_app/utils/preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:shimmer/shimmer.dart';

class WeatherEarthPage extends StatelessWidget {
  const WeatherEarthPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meteoro App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<WeatherEarth>> weatherEarth;
  late Future<WeatherEarthResponse> weatherOneEarth;
  late Future<List<Daily>> weatherSevenDaysEarth;
  late String city;

  @override
  void initState() {
    weatherEarth = fetchWeatherEarth();
    weatherOneEarth = fetchOneWeatherEarth();
    weatherSevenDaysEarth = fetchSevenDaysWeatherEarth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: <Color>[
                MeteoroStyle.blueLightColor,
                MeteoroStyle.blueColor
              ])),
          child: Center(
            child: ListView(
              children: [
                Center(
                  child: FutureBuilder<WeatherEarthResponse>(
                    future: weatherOneEarth,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _weatherItem(snapshot.data!);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return SizedBox(
                        width: 400,
                        height: 450,
                        child: Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: Colors.white.withOpacity(0.2),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            color: MeteoroStyle.whiteColor.withOpacity(0.3),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(MeteoroStyle.bodyPadding),
                  child: Text(
                    'Previsión por horas',
                    style: MeteoroStyle.textDefault(MeteoroStyle.textSizeSmall),
                  ),
                ),
                Center(
                  child: FutureBuilder<List<WeatherEarth>>(
                    future: weatherEarth,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _weatherList(snapshot.data!);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _shimmerCard(),
                            _shimmerCard(),
                            _shimmerCard(),
                            _shimmerCard(),
                            _shimmerCard(),
                          ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(MeteoroStyle.bodyPadding),
                  child: Text(
                    'Previsión para los proximos dias',
                    style: MeteoroStyle.textDefault(MeteoroStyle.textSizeSmall),
                  ),
                ),
                Center(
                  child: FutureBuilder<List<Daily>>(
                    future: weatherSevenDaysEarth,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _weatherDaysList(snapshot.data!);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _shimmerMedCard(),
                            _shimmerMedCard()
                          ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<WeatherEarth>> fetchWeatherEarth() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=${PreferenceUtils.getString(PREF_CITY) ?? "Sevilla"}&units=metric&lang=es&appid=4df3c643539bff3cbff2a3ef9f57504b'));

    if (response.statusCode == 200) {
      WeatherEarthResponse resp =
          WeatherEarthResponse.fromJson(jsonDecode(response.body));
      return resp.list;
    } else {
      throw Exception('Failed to load weather');
    }
  }

  Future<WeatherEarthResponse> fetchOneWeatherEarth() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=${PreferenceUtils.getString(PREF_CITY) ?? "Sevilla"}&units=metric&cnt=1&lang=es&appid=4df3c643539bff3cbff2a3ef9f57504b'));
    if (response.statusCode == 200) {
      return WeatherEarthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  Future<List<Daily>> fetchSevenDaysWeatherEarth() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=${PreferenceUtils.getDouble(PREF_LAT).toString()}&lon=${PreferenceUtils.getDouble(PREF_LON).toString()}&lang=es&exclude=hourly,current,minutely,alerts&units=metric&appid=4df3c643539bff3cbff2a3ef9f57504b'));
    if (response.statusCode == 200) {
      return WeatherSevenDaysResponse.fromJson(jsonDecode(response.body)).daily;
    } else {
      throw Exception('Failed to load weather');
    }
  }

  Widget _weatherList(List<WeatherEarth> weatherList) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: weatherList.length,
        itemBuilder: (context, index) {
          return _weatherItems(weatherList.elementAt(index), index);
        },
      ),
    );
  }
}

Widget _weatherDaysList(List<Daily> weatherList) {
  return Container(
    margin: const EdgeInsets.only(bottom: 110),
    height: 300,
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: weatherList.length,
      itemBuilder: (context, index) {
        return _weatherDay(weatherList.elementAt(index), index);
      },
    ),
  );
}

Widget _weatherDay(Daily daily, int index) {
  return SizedBox(
    width: 200,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      color: MeteoroStyle.whiteColor.withOpacity(0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              Jiffy(DateTime.fromMillisecondsSinceEpoch(daily.dt * 1000)).MMMMd,
              style: MeteoroStyle.textDefault(14.0)),
          Container(
            padding: const EdgeInsets.all(MeteoroStyle.bodyPadding),
            width: 150,
            child: Image.asset(
              'assets/images/${daily.weather[0].icon}.png',
              width: 150,
              height: 100,
            ),
          ),
          Text(daily.weather[0].description,
              style: MeteoroStyle.textDefault(14.0)),
          Text('Max: ${daily.temp.max.round()}º',
              style: MeteoroStyle.textDefault(14.0)),
          Text('Min: ${daily.temp.min.round()}º',
              style: MeteoroStyle.textDefault(14.0)),
          Text('Humedad: ${daily.humidity}%',
              style: MeteoroStyle.textDefault(14.0)),
          Text('Viento: ${daily.windSpeed}m/s',
              style: MeteoroStyle.textDefault(14.0)),
        ],
      ),
    ),
  );
}

Widget _weatherItems(WeatherEarth weatherEarth, int index) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40.0),
    ),
    color: MeteoroStyle.whiteColor.withOpacity(0.3),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${weatherEarth.main.temp.round()}º',
            style: MeteoroStyle.textDefault(18.0)),
        Container(
          padding: const EdgeInsets.all(MeteoroStyle.bodyPadding),
          width: 80,
          child: Image.asset(
            'assets/images/${weatherEarth.weather[0].icon}.png',
            width: 50,
            height: 50,
          ),
        ),
        Text(
          weatherEarth.weather[0].description,
          style: MeteoroStyle.textDefault(12),
        ),
        Text(Jiffy(weatherEarth.dtTxt).Hm,
            style: MeteoroStyle.textDefault(18.0)),
      ],
    ),
  );
}

Widget _weatherItem(WeatherEarthResponse weatherEarth) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        weatherEarth.city.name,
        style: MeteoroStyle.textDefault(MeteoroStyle.textSizetitle),
      ),
      GradientText(
        '${weatherEarth.list[0].main.temp.round()}º',
        style: MeteoroStyle.textDefault(MeteoroStyle.textSizeLarge),
        gradientType: GradientType.linear,
        gradientDirection: GradientDirection.ttb,
        colors: const [
          Colors.grey,
          Colors.white,
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Image.asset(
              'assets/images/${weatherEarth.list[0].weather[0].icon}.png',
              width: 180,
            ),
          ),
          Column(
            children: [
              Text(
                '${weatherEarth.list[0].main.tempMax.round()}º C',
                style: MeteoroStyle.textDefault(MeteoroStyle.textSizeWeather),
              ),
              Text(
                '${weatherEarth.list[0].main.tempMin.round()}º C',
                style: MeteoroStyle.textDefault(MeteoroStyle.textSizeWeather),
              ),
            ],
          )
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(MeteoroStyle.bodyPadding),
        child: Text(
          weatherEarth.list[0].weather[0].description,
          style: MeteoroStyle.textDefault(MeteoroStyle.textSizeMedium),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(MeteoroStyle.bodyPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Text(
                  'Viento\n ${weatherEarth.list[0].wind.speed}m/s',
                  style: MeteoroStyle.textDefault(MeteoroStyle.textSizeSmall),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(
                    'assets/images/viento.png',
                    width: 30,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  'Humedad\n ${weatherEarth.list[0].main.humidity}%',
                  style: MeteoroStyle.textDefault(MeteoroStyle.textSizeSmall),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(
                    'assets/images/humedad.png',
                    width: 20,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _shimmerCard() {
  return SizedBox(
    width: 75,
    height: 150,
    child: Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.white.withOpacity(0.2),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        color: MeteoroStyle.whiteColor.withOpacity(0.3),
      ),
    ),
  );
}

Widget _shimmerMedCard() {
  return SizedBox(
    width: 190,
    height: 300,
    child: Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.white.withOpacity(0.2),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        color: MeteoroStyle.whiteColor.withOpacity(0.3),
      ),
    ),
  );
}
