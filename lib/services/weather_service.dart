import 'dart:convert';
import 'package:geocoding/geocoding.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import 'package:geolocator/geolocator.dart';

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  late final String apiKey;

  WeatherService({required this.apiKey});

  Future<Weather> getWeather(String cityName) async {
    final res = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (res.statusCode == 200){
      //print(res.body);
      return Weather.fromJson(jsonDecode(res.body));
    }
    else{
      throw Exception('failure');
    }
  }

  Future<String> getCurrentCity() async{
    LocationPermission perm = await Geolocator.checkPermission();

    if (perm == LocationPermission.denied){
      perm = await Geolocator.requestPermission();
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    List<Placemark> placemark = await placemarkFromCoordinates(pos.latitude,pos.longitude);

    //print(placemark[0].country);

    //print(placemark[0].locality);

    //String? city =  placemark[0].locality;

    String? city =  "New York City";

    //print("current city $city");
    //return 'London' ?? "";
    return city ?? "";
  }
}