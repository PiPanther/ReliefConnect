import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Map<String, double>> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Location Services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location Services Denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied");
    }
    Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.best));
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
  }

  final String? _apiKey =
      dotenv.env['wAPI']; // Replace with your OpenWeatherMap API key

  // Method to fetch weather data from the OpenWeather API
  Future<Map<String, dynamic>> fetchWeather() async {
    Map<String, double> loc = await getCurrentLocation();
    final url = Uri.parse(
        "https://api.openweathermap.org/data/3.0/onecall?lat=${loc['latitude']!.toStringAsFixed(2)}&lon=${loc['latitude']!.toStringAsFixed(2)}&appid=${_apiKey}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'temp': data['main']['temp'], // Temperature in Kelvin
          'humidity': data['main']['humidity'], // Humidity in percentage
          'wind_speed': data['wind']['speed'], // Wind speed in meter/sec
          'rain': data['rain'] != null
              ? data['rain']['1h'] ?? 0.0
              : 0.0, // Rainfall in last hour (if available)
        };
      } else {
        throw Exception('Failed to fetch weather data');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

// Create a Provider to expose the WeatherService
final weatherServiceProvider =
    Provider<WeatherService>((ref) => WeatherService());

// Create a FutureProvider to fetch weather data for a specific city
final weatherProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, city) {
  final weatherService = ref.watch(weatherServiceProvider);
  return weatherService.fetchWeather();
});
