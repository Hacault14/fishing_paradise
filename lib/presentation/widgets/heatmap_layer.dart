import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FishingSpotWeight {
  final LatLng location;
  final double weight;

  const FishingSpotWeight({
    required this.location,
    required this.weight,
  });
}

class HeatmapLayer {
  final List<FishingSpotWeight> points;
  final double radius;
  final Color startColor;
  final Color endColor;
  final Function(LatLng)? onTap;

  HeatmapLayer({
    required this.points,
    required this.radius,
    required this.startColor,
    required this.endColor,
    this.onTap,
  });

  Set<Circle> createHeatmap() {
    return points.map((point) {
      final color = Color.lerp(startColor, endColor, point.weight)!;
      return Circle(
        circleId: CircleId(point.location.toString()),
        center: point.location,
        radius: radius,
        fillColor: color.withOpacity(0.7),
        strokeWidth: 1,
        strokeColor: Colors.transparent,
        consumeTapEvents: true,
        onTap: () => onTap?.call(point.location),
      );
    }).toSet();
  }
}
