import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String location = '';
  String temperature = '';
  String weatherDescription = '';
  bool isLoading = true;
  String errorMessage = '';
  String lastUpdated = '';


  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future fetchWeatherData() async {
    final String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=Dhaka&appid=8b5ccf4725ba84043b991cfcc8ed93b9&units=metric';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final mainData = data['main'];
        final weatherData = data['weather'][0];
        final dt = data['dt'];

        final dateTime = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
        final formattedDateTime = DateFormat.yMMMMd().add_jms().format(dateTime);

        setState(() {
          location = data['name'];
          temperature = mainData['temp'].toString();
          weatherDescription = weatherData['description'];
          lastUpdated = 'Last Updated: $formattedDateTime';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to fetch weather data.';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred: $e';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [
          IconButton(onPressed: fetchWeatherData, icon: const Icon(Icons.refresh))
        ],
      ),
      body: Container(

        decoration: BoxDecoration(color: Colors.deepPurple),
        child: Center(

          child: isLoading
              ? CircularProgressIndicator()
              : errorMessage.isNotEmpty
              ? Text(errorMessage)
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Location: $location',
                style:  TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 16),
              Image.asset(
                getWeatherImage(weatherDescription),
                width: 120,
                height: 100,
              ),
              SizedBox(height: 16),
              Text(
                '$temperature°C',
                style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CustomFont',
                    color: Colors.white
                ),
              ),
              SizedBox(height: 16),
              Text(
                weatherDescription,
                style: TextStyle(fontSize: 24, color: Colors.white
                ),
              ),
              SizedBox(height: 16),

              Text(
                lastUpdated,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getWeatherImage(String description) {
    String imagePath = 'images/default_weather.png';

    if (description.toLowerCase().contains('clear')) {
      imagePath = 'images/sunny.png';
    } else if (description.toLowerCase().contains('cloud')) {
      imagePath = 'images/cloudy.png';
    } else if (description.toLowerCase().contains('rain')) {
      imagePath = 'images/rainy.png';
    } else if (description.toLowerCase().contains('drizzle')) {
      imagePath = 'images/drizzle.png';
    } else if (description.toLowerCase().contains('thunderstorm')) {
      imagePath = 'images/thunderstorm.png';
    } else if (description.toLowerCase().contains('snow')) {
      imagePath = 'images/snow.png';
    }

    return imagePath;
  }

}