import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  WeatherHomePageState createState() => WeatherHomePageState();
}

class WeatherHomePageState extends State<WeatherHomePage> {
  String _weatherData = '';
  bool _isLoading = false;
  String _location = 'London';

  Future<void> fetchWeatherData(String location) async {
    setState(() {
      _isLoading = true;
    });

    const apiKey = '78a898d5ee6c4fb394075331242103';
    final apiUrl =
        'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$location&days=1&aqi=no&alerts=no';

    final response = await http.get(Uri.parse(apiUrl));

    setState(() {
      _weatherData = jsonDecode(response.body)['current']['temp_c'];
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Weather App'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _weatherData.isNotEmpty
                ? Text(
                    'Weather: $_weatherData',
                    style: const TextStyle(fontSize: 20),
                  )
                : const Text('No weather data available'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newLocation = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LocationSelectionPage()),
          );
          if (newLocation != null) {
            setState(() {
              _location = newLocation;
            });
            fetchWeatherData(newLocation);
          }
        },
        child: const Icon(Icons.add_location),
      ),
    );
  }
}

class LocationSelectionPage extends StatelessWidget {
  final TextEditingController _locationController = TextEditingController();

  LocationSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Enter location',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _locationController.text);
              },
              child: const Text('Select'),
            ),
          ],
        ),
      ),
    );
  }
}
