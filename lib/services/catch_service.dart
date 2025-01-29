import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather/weather.dart';
import '../models/catch.dart';
import '../config/env_config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CatchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final WeatherFactory _weatherFactory =
      WeatherFactory(EnvConfig.openWeatherApiKey);

  // Add a new catch
  Future<void> addCatch({
    required String fishType,
    required double length,
    double? weight,
    required double latitude,
    required double longitude,
    String? photoUrl,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    print('Current user: ${user?.uid}'); // Debug print
    if (user == null) throw Exception('User not authenticated');

    // Get weather data
    Weather weather = await _weatherFactory.currentWeatherByLocation(
      latitude,
      longitude,
    );

    final WeatherData weatherData = WeatherData(
      temperature: weather.temperature?.celsius ?? 0,
      windSpeed: weather.windSpeed ?? 0,
      humidity: weather.humidity ?? 0,
      conditions: weather.weatherMain ?? 'unknown',
      pressure: weather.pressure ?? 0,
    );

    final fishCatch = Catch(
      id: _firestore.collection('catches').doc().id,
      userId: user.uid,
      fishType: fishType,
      length: length,
      weight: weight,
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      photoUrl: photoUrl,
      weatherData: weatherData,
      conditions: {
        'moon_phase': 0, // You can add moon phase calculation here
        'water_temperature': 0, // If you have access to water temperature data
        'tide': 'unknown', // If relevant for your location
      },
    );

    await _firestore
        .collection('catches')
        .doc(fishCatch.id)
        .set(fishCatch.toMap());

    // Debug print
    print('Added catch at location: $latitude, $longitude');
  }

  // Get catches for a specific user
  Stream<List<Catch>> getUserCatches(String userId) {
    return _firestore
        .collection('catches')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Catch.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get catches near a location (within radius in km)
  Future<List<Catch>> getCatchesNearLocation(
    double latitude,
    double longitude,
    double radiusInKm,
  ) async {
    // Convert radius to degrees (approximate)
    final double radiusInDegrees = radiusInKm / 111.32;

    final snapshot = await _firestore
        .collection('catches')
        .where('location',
            isGreaterThan: GeoPoint(
                latitude - radiusInDegrees, longitude - radiusInDegrees))
        .where('location',
            isLessThan: GeoPoint(
                latitude + radiusInDegrees, longitude + radiusInDegrees))
        .get();

    return snapshot.docs
        .map((doc) => Catch.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Get catch statistics for heatmap
  Future<Map<String, int>> getCatchStatistics(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final snapshot = await _firestore
        .collection('catches')
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    Map<String, int> locationCounts = {};
    for (var doc in snapshot.docs) {
      final fishCatch = Catch.fromMap(doc.data() as Map<String, dynamic>);
      final locationKey = '${fishCatch.latitude},${fishCatch.longitude}';
      locationCounts[locationKey] = (locationCounts[locationKey] ?? 0) + 1;
    }

    return locationCounts;
  }

  Future<List<Catch>> getCatchesInDateRange(
    DateTime startDate,
    DateTime endDate, {
    String? fishType,
  }) async {
    Query query = _firestore
        .collection('catches')
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate));

    if (fishType != null) {
      query = query.where('fishType', isEqualTo: fishType);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Catch.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> migrateCatchLocations() async {
    final snapshot = await _firestore.collection('catches').get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      if (data['location'] == null &&
          (data['latitude'] != null || data['longitude'] != null)) {
        await doc.reference.update({
          'location': GeoPoint(
            (data['latitude'] ?? 0.0).toDouble(),
            (data['longitude'] ?? 0.0).toDouble(),
          ),
        });
      }
    }
  }
}
