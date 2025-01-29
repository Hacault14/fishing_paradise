import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/heatmap_layer.dart';
import '../../services/catch_service.dart';
import '../../models/catch.dart';
import './filter_screen.dart';
import '../widgets/catch_info_dialog.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Set<Circle> _heatmapCircles = {};
  final _catchService = CatchService();
  bool _isLoading = true;
  String? _selectedFishType;
  Map<String, Catch> _catchesMap = {};

  @override
  void initState() {
    super.initState();
    _loadCatchData();
  }

  Future<void> _loadCatchData() async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 30));

      final catches = await _catchService.getCatchesInDateRange(
        startDate,
        endDate,
        fishType: _selectedFishType,
      );

      final heatmapPoints = <FishingSpotWeight>[];
      final locationCounts = <String, int>{};
      _catchesMap.clear();

      // Count catches at each location
      for (var fishCatch in catches) {
        // Round coordinates to 6 decimal places for consistent keys
        final lat = fishCatch.latitude.toStringAsFixed(6);
        final lng = fishCatch.longitude.toStringAsFixed(6);
        final locationKey = '$lat,$lng';
        locationCounts[locationKey] = (locationCounts[locationKey] ?? 0) + 1;
        _catchesMap[locationKey] = fishCatch;
      }

      // Create heatmap points
      locationCounts.forEach((key, count) {
        final coordinates = key.split(',');
        if (coordinates.length == 2) {
          final lat = double.parse(coordinates[0]);
          final lng = double.parse(coordinates[1]);
          final maxCount =
              locationCounts.values.reduce((a, b) => a > b ? a : b);
          final weight = count / maxCount;

          heatmapPoints.add(FishingSpotWeight(
            location: LatLng(lat, lng),
            weight: weight,
          ));
        }
      });

      final heatmap = HeatmapLayer(
        points: heatmapPoints,
        radius: 30, // Reduced radius for better visibility
        startColor: Colors.blue,
        endColor: Colors.red,
        onTap: _onCircleTap,
      );

      setState(() {
        _heatmapCircles = heatmap.createHeatmap();
        _isLoading = false;
      });

      // Debug print to verify data
      print('Loaded ${heatmapPoints.length} points on the map');
      print('First point: ${heatmapPoints.firstOrNull?.location}');
    } catch (e) {
      print('Error loading catch data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onCircleTap(LatLng location) {
    // Round coordinates for consistent lookup
    final lat = location.latitude.toStringAsFixed(6);
    final lng = location.longitude.toStringAsFixed(6);
    final locationKey = '$lat,$lng';
    final fishCatch = _catchesMap[locationKey];

    if (fishCatch != null) {
      showDialog(
        context: context,
        builder: (context) => CatchInfoDialog(fishCatch: fishCatch),
      );
    }
  }

  Future<void> _showFilters() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => FilterScreen(selectedFishType: _selectedFishType),
      ),
    );

    if (result != _selectedFishType) {
      setState(() {
        _selectedFishType = result;
        _isLoading = true;
      });
      _loadCatchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(44.2312, -76.4860), // Kingston
            zoom: 12,
          ),
          circles: _heatmapCircles,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: _showFilters,
                child: const Icon(Icons.filter_list),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                onPressed: _loadCatchData,
                child: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        if (_selectedFishType != null)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedFishType!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 18),
                    onPressed: () {
                      setState(() {
                        _selectedFishType = null;
                        _isLoading = true;
                      });
                      _loadCatchData();
                    },
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
