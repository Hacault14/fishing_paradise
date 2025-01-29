class FishingSpot {
  final String id;
  final String userId;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final List<String> fishTypes;
  final String waterType; // lake, river, sea, etc.
  final double? depth;
  final List<String>? images;

  FishingSpot({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.fishTypes,
    required this.waterType,
    this.depth,
    this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'fishTypes': fishTypes,
      'waterType': waterType,
      'depth': depth,
      'images': images,
    };
  }

  factory FishingSpot.fromMap(Map<String, dynamic> map) {
    return FishingSpot(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      timestamp: DateTime.parse(map['timestamp']),
      fishTypes: List<String>.from(map['fishTypes']),
      waterType: map['waterType'],
      depth: map['depth'],
      images: map['images'] != null ? List<String>.from(map['images']) : null,
    );
  }
}
