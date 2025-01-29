class Catch {
  final String id;
  final String userId;
  final String species;
  final double weight;
  final double length;
  final String bait;
  final String method;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final Map<String, dynamic> weatherData;
  final String? imageUrl;

  Catch({
    required this.id,
    required this.userId,
    required this.species,
    required this.weight,
    required this.length,
    required this.bait,
    required this.method,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.weatherData,
    this.imageUrl,
  });
}
