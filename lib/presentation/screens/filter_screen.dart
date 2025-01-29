import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final String? selectedFishType;

  const FilterScreen({super.key, this.selectedFishType});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? _selectedFishType;
  final List<String> _fishTypes = [
    'All',
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
    _selectedFishType = widget.selectedFishType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedFishType = null;
              });
            },
            child: const Text('Reset'),
          ),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Fish Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...List<Widget>.generate(
            _fishTypes.length,
            (index) => RadioListTile<String?>(
              title: Text(_fishTypes[index]),
              value: _fishTypes[index] == 'All' ? null : _fishTypes[index],
              groupValue: _selectedFishType,
              onChanged: (String? value) {
                setState(() {
                  _selectedFishType = value;
                });
              },
            ),
          ),
          // Space for future filters
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'More filters coming soon...',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, _selectedFishType);
          },
          child: const Text('Apply Filters'),
        ),
      ),
    );
  }
}
