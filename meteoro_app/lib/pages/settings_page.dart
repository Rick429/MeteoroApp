import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meteoro_app/models/weather_earth_response.dart';
import 'package:meteoro_app/styles.dart';
import 'package:meteoro_app/utils/constants.dart';
import 'package:meteoro_app/utils/preferences.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<SettingsPage> {
  late GoogleMapController _mapController;
  LatLng target = const LatLng(37.37535, -6.0252696);
  late final _formKey = GlobalKey<FormState>();
  late Future<WeatherEarthResponse> weatherOneEarth;
  late double lat = 37.37535;
  late double lon = -6.0252696;
  late LatLng posicion = LatLng(PreferenceUtils.getDouble(PREF_LAT) ?? lat,
      PreferenceUtils.getDouble(PREF_LON) ?? lon);
  Set<Marker> _createMarker() {
  return {
    Marker(
        markerId: const MarkerId('Marker'),
        position: target,
        draggable: true,)
  };
}

  late String city;

  TextEditingController cityController = TextEditingController();
  @override
  void initState() {
    weatherOneEarth = fetchOneWeatherEarth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: <Color>[
                  MeteoroStyle.blueLightColor,
                  MeteoroStyle.blueColor
                ]),
          ),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text('Introduzca el nombre una ciudad', style: MeteoroStyle.textDefault(24),),
                      ),
                        TextFormField(
                          controller: cityController,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Buscar ciudad...',
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(color: Colors.red))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Introduzca el nombre de una ciudad';
                            }
                            return null;
                          },
                        ),
                    ],
                  ),
                ),
              ButtonTheme(
                minWidth: 250,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        city = cityController.text;
                      PreferenceUtils.setString(PREF_CITY, city).then((value) => weatherOneEarth = fetchOneWeatherEarth());

                      });
                      /* ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(city)),
                      ); */
                    }
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: const Text('Guardar'),
                ),
              ),
              SizedBox(
                width: 400,
                height: 400,
                child: GoogleMap(
                  markers: _createMarker(),
                  mapType: MapType.hybrid,
                  initialCameraPosition:
                      const CameraPosition(target: LatLng(37.37535, -6.0252696), zoom: 16),
                  onMapCreated: (controller) => _mapController = controller,
                ),
              ),
            ],
          )),
    ));
  }

  Future<WeatherEarthResponse> fetchOneWeatherEarth() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=${PreferenceUtils.getString(PREF_CITY) ?? "Sevilla"}&units=metric&cnt=1&lang=es&appid=4df3c643539bff3cbff2a3ef9f57504b'));
    if (response.statusCode == 200) {
      WeatherEarthResponse resp =
          WeatherEarthResponse.fromJson(jsonDecode(response.body));
          lat = resp.city.coord.lat;
          lon = resp.city.coord.lon;
        PreferenceUtils.setDouble(PREF_LAT, lat);
        PreferenceUtils.setDouble(PREF_LON, lon);
        target = LatLng(PreferenceUtils.getDouble(PREF_LAT) ?? 37.37535,
            PreferenceUtils.getDouble(PREF_LON) ?? -6.0252696);
        _mapController.animateCamera(CameraUpdate.newLatLng(
          target,
         
        ));
        setState(() {
          _createMarker();
        });
      return resp;
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
