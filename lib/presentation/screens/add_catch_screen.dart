import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/catch_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddCatchScreen extends StatefulWidget {
  const AddCatchScreen({super.key});

  @override
  State<AddCatchScreen> createState() => _AddCatchScreenState();
}

class _AddCatchScreenState extends State<AddCatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _catchService = CatchService();
  final _lengthController = TextEditingController();
  final _weightController = TextEditingController();
  String _selectedFishType = 'Bass';
  Position? _currentPosition;
  File? _imageFile;
  bool _isLoading = false;
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  bool _useCurrentLocation = true;

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
        _latitudeController.text = position.latitude.toString();
        _longitudeController.text = position.longitude.toString();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: ${e.toString()}')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _submitCatch() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _catchService.addCatch(
          fishType: _selectedFishType,
          length: double.parse(_lengthController.text),
          weight: _weightController.text.isNotEmpty
              ? double.parse(_weightController.text)
              : null,
          latitude: double.parse(_latitudeController.text),
          longitude: double.parse(_longitudeController.text),
          photoUrl: null,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Catch recorded successfully!')),
          );
          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error recording catch: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_imageFile != null) ...[
              Image.file(
                _imageFile!,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
            ],
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedFishType,
              decoration: const InputDecoration(
                labelText: 'Fish Type',
                border: OutlineInputBorder(),
              ),
              items: _fishTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFishType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lengthController,
              decoration: const InputDecoration(
                labelText: 'Length (cm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the length';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Weight (kg) - Optional',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Use Current Location'),
              value: _useCurrentLocation,
              onChanged: (bool value) {
                setState(() {
                  _useCurrentLocation = value;
                });
              },
            ),
            if (!_useCurrentLocation) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _latitudeController,
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter latitude';
                  }
                  final lat = double.tryParse(value);
                  if (lat == null || lat < -90 || lat > 90) {
                    return 'Invalid latitude (-90 to 90)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _longitudeController,
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter longitude';
                  }
                  final lng = double.tryParse(value);
                  if (lng == null || lng < -180 || lng > 180) {
                    return 'Invalid longitude (-180 to 180)';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitCatch,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Record Catch'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _lengthController.dispose();
    _weightController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }
}
