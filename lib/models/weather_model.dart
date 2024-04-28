import 'package:flutter/material.dart';

class Weather{
  late final String cityName;
  late final double temperature;
  late final String mainCondition;

  Weather({required this.cityName,required this.temperature, required this.mainCondition});

  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(
        cityName: json['name'],
        temperature: json['main']['temp'].toDouble(),
        mainCondition: json['weather'][0]['main'],);
  }
}


