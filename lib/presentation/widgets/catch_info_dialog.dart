import 'package:flutter/material.dart';
import '../../models/catch.dart';
import 'package:intl/intl.dart';

class CatchInfoDialog extends StatelessWidget {
  final Catch fishCatch;

  const CatchInfoDialog({super.key, required this.fishCatch});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy - h:mm a');

    return AlertDialog(
      title: Text(fishCatch.fishType),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date: ${dateFormat.format(fishCatch.timestamp)}'),
          const SizedBox(height: 8),
          Text('Length: ${fishCatch.length.toStringAsFixed(1)} cm'),
          if (fishCatch.weight != null) ...[
            const SizedBox(height: 8),
            Text('Weight: ${fishCatch.weight!.toStringAsFixed(1)} kg'),
          ],
          const SizedBox(height: 16),
          Text('Weather: ${fishCatch.weatherData.conditions}'),
          Text(
              'Temperature: ${fishCatch.weatherData.temperature.toStringAsFixed(1)}°C'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
