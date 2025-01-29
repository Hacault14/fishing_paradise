import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/fishing_spot.dart';

class FishingSpotsScreen extends StatelessWidget {
  const FishingSpotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // List of fishing spots will go here
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddFishingSpotScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddFishingSpotScreen extends StatefulWidget {
  const AddFishingSpotScreen({super.key});

  @override
  State<AddFishingSpotScreen> createState() => _AddFishingSpotScreenState();
}

class _AddFishingSpotScreenState extends State<AddFishingSpotScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _depthController = TextEditingController();
  String _selectedWaterType = 'lake';
  final List<String> _selectedFishTypes = [];
  Position? _currentPosition;

  final List<String> _waterTypes = ['lake', 'river', 'sea', 'pond'];
  final List<String> _fishTypes = [
    'Bass',
    'Trout',
    'Salmon',
    'Pike',
    'Catfish',
    'Carp',
    'Perch',
    'Walleye'
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: ${e.toString()}')),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _currentPosition != null) {
      // TODO: Save to Firebase
      final spot = FishingSpot(
        id: DateTime.now().toString(), // Replace with Firebase generated ID
        userId: 'user_id', // Replace with actual user ID
        title: _titleController.text,
        description: _descriptionController.text,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        timestamp: DateTime.now(),
        fishTypes: _selectedFishTypes,
        waterType: _selectedWaterType,
        depth: double.tryParse(_depthController.text),
      );

      // TODO: Add Firebase storage logic here

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Fishing Spot'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a description' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedWaterType,
              decoration: const InputDecoration(labelText: 'Water Type'),
              items: _waterTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedWaterType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _depthController,
              decoration: const InputDecoration(
                labelText: 'Depth (meters)',
                hintText: 'Optional',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text('Fish Types:'),
            Wrap(
              spacing: 8,
              children: _fishTypes.map((type) {
                final isSelected = _selectedFishTypes.contains(type);
                return FilterChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedFishTypes.add(type);
                      } else {
                        _selectedFishTypes.remove(type);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Save Fishing Spot'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _depthController.dispose();
    super.dispose();
  }
}
