import '../../domain/entities/catch.dart';

class CatchModel extends Catch {
  CatchModel({
    required String id,
    required String userId,
    required String species,
    required double weight,
    required double length,
    required String bait,
    required String method,
    required DateTime timestamp,
    required double latitude,
    required double longitude,
    required Map<String, dynamic> weatherData,
    String? imageUrl,
  }) : super(
          id: id,
          userId: userId,
          species: species,
          weight: weight,
          length: length,
          bait: bait,
          method: method,
          timestamp: timestamp,
          latitude: latitude,
          longitude: longitude,
          weatherData: weatherData,
          imageUrl: imageUrl,
        );

  factory CatchModel.fromJson(Map<String, dynamic> json) {
    return CatchModel(
      id: json['id'],
      userId: json['userId'],
      species: json['species'],
      weight: json['weight'].toDouble(),
      length: json['length'].toDouble(),
      bait: json['bait'],
      method: json['method'],
      timestamp: DateTime.parse(json['timestamp']),
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      weatherData: json['weatherData'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'species': species,
      'weight': weight,
      'length': length,
      'bait': bait,
      'method': method,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'weatherData': weatherData,
      'imageUrl': imageUrl,
    };
  }
}
