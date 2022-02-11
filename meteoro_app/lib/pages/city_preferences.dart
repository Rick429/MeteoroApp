import 'package:shared_preferences/shared_preferences.dart';

class CityPreferences {
  final String city = "city";
  final String lat = "lat";
  final String lon = "lon";
//set data into shared preferences like this
  Future<void> setCity(String ciudad) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.city, ciudad);
  }

//get value from shared preferences
  Future<String> getCity(String ciudad) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? city;
    city = pref.getString(this.city) ?? null;
    return city!;
  }


  Future<void> setLat(String lat) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.lat, lat);
  }

//get value from shared preferences
  Future<String> getLat(String lat) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? lat;
    lat = pref.getString(this.lat) ?? null;
    return lat!;
  }
  Future<void> setLon(String lon) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.lon, lon);
  }

//get value from shared preferences
  Future<String> getLon(String lon) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? lon;
    lon = pref.getString(this.lon) ?? null;
    return lon!;
  }
}