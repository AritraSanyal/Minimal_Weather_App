import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_minimal_app/model/weather_model.dart';
import 'package:weather_minimal_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key

  final _weatherService = WeatherServices('13c35dc2c10929d4504cc7510e87c488');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();
    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    //any errors
    catch (e) {
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; //default

    switch (mainCondition.toLowerCase()) {
      case 'mist':
        return 'assets/mist.json';
      case 'clouds':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainThunder.json';
      case 'thunderstrom':
        return 'assets/rainThunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 211, 211, 211),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //CITY NAME
            Text(
              _weather?.cityName ?? "loading city..",
              style: const TextStyle(
                fontSize: 30,
                color: Colors.black,
                //fontWeight: FontWeight.bold
              ),
            ),

            //ANIMATION
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            //TEMPERATURE
            Text(
              "${_weather?.temperature.round()} °C",
              style: const TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
            ),

            //WEATHER CONDITION
            Text(
              _weather?.mainCondition ?? "",
              style: const TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 1, 1, 1)),
            ),
          ],
        ),
      ),
    );
  }
}
