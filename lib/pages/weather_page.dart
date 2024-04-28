import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final wS = WeatherService(apiKey: '614cdd8859ea7f6f0cb482103f430c55');
  Weather? w;
  late Color backgroundColor;
  late String anime;

  _fetchWeather() async {
    String city = await wS.getCurrentCity();
    print(city);
    try {
      final weather = await wS.getWeather(city);
      setState(() {
        w = weather;
        setWeatherBackgroundColor();
        anime = getWeatherAnimation(w?.mainCondition);
      });
    } catch (e) {
      print("error in getWeather [$e]");
    }
  }

  String getWeatherAnimation(String? cond) {
    if (cond == null) {
      return 'assets/sunny.json';
    }

    switch (cond.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      default:
        return 'assets/sunny.json';
    }
  }

  void setWeatherBackgroundColor() {
    if (w != null) {
      switch (w!.mainCondition.toLowerCase()) {
        case 'clouds':
        case 'mist':
        case 'smoke':
        case 'haze':
        case 'dust':
        case 'fog':
          backgroundColor = Colors.grey[300]!;
          break;
        case 'rain':
        case 'drizzle':
        case 'shower rain':
          backgroundColor = Colors.blue[200]!;
          break;
        case 'thunderstorm':
          backgroundColor = Colors.black87;
          break;
        default:
          backgroundColor = Colors.white;
      }
    } else {
      backgroundColor = Colors.white;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    setWeatherBackgroundColor();
    anime = getWeatherAnimation(w?.mainCondition);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Weather'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchWeather,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Text(w?.cityName ?? "loading city"),
            Lottie.asset(anime),
            const SizedBox(height: 30),
            Text('${w?.temperature}C'),
            const SizedBox(height: 30),
            Text('${w?.mainCondition}'),
          ],
        ),
      ),
    );
  }
}
