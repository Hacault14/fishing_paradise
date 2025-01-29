import 'package:cloud_firestore/cloud_firestore.dart';

class Catch {
  final String id;
  final String userId;
  final String fishType;
  final double length; // in centimeters
  final double? weight; // in kilograms (optional)
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String? photoUrl;
  final WeatherData weatherData;

  // Weather data as a nested object
  final Map<String, dynamic> conditions;

  Catch({
    required this.id,
    required this.userId,
    required this.fishType,
    required this.length,
    this.weight,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.photoUrl,
    required this.weatherData,
    required this.conditions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'fishType': fishType,
      'length': length,
      'weight': weight,
      'location': GeoPoint(latitude, longitude),
      'timestamp': Timestamp.fromDate(timestamp),
      'photoUrl': photoUrl,
      'weather': weatherData.toMap(),
      'conditions': conditions,
    };
  }

  factory Catch.fromMap(Map<String, dynamic> map) {
    double latitude;
    double longitude;

    if (map['location'] is GeoPoint) {
      final GeoPoint location = map['location'] as GeoPoint;
      latitude = location.latitude;
      longitude = location.longitude;
    } else {
      // Handle old format or direct lat/lng storage
      latitude = (map['latitude'] ?? 0.0).toDouble();
      longitude = (map['longitude'] ?? 0.0).toDouble();
    }

    return Catch(
      id: map['id'],
      userId: map['userId'],
      fishType: map['fishType'],
      length: map['length'].toDouble(),
      weight: map['weight']?.toDouble(),
      latitude: latitude,
      longitude: longitude,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      photoUrl: map['photoUrl'],
      weatherData: WeatherData.fromMap(map['weather']),
      conditions: map['conditions'],
    );
  }
}

class WeatherData {
  final double temperature; // in Celsius
  final double windSpeed; // in m/s
  final double humidity; // percentage
  final String conditions; // clear, cloudy, etc.
  final double pressure; // hPa

  WeatherData({
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.conditions,
    required this.pressure,
  });

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'windSpeed': windSpeed,
      'humidity': humidity,
      'conditions': conditions,
      'pressure': pressure,
    };
  }

  factory WeatherData.fromMap(Map<String, dynamic> map) {
    return WeatherData(
      temperature: map['temperature'],
      windSpeed: map['windSpeed'],
      humidity: map['humidity'],
      conditions: map['conditions'],
      pressure: map['pressure'],
    );
  }
}
