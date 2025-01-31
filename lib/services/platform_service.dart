import 'package:flutter/services.dart';
import '../config/env_config.dart';

class PlatformService {
  static const platform = MethodChannel('com.example.fishing_paradise/config');

  static Future<void> initializeGoogleMaps() async {
    try {
      print('PlatformService: Starting Google Maps initialization');
      print(
          'PlatformService: API Key length: ${EnvConfig.googleMapsApiKey.length}');

      await platform.invokeMethod(
          'getGoogleMapsApiKey', EnvConfig.googleMapsApiKey);
      print(
          'PlatformService: Google Maps API key sent to platform successfully');
    } on PlatformException catch (e) {
      print(
          'PlatformService ERROR: Failed to initialize Google Maps: ${e.message}');
      print('PlatformService ERROR details: ${e.details}');
      throw e;
    } catch (e) {
      print(
          'PlatformService ERROR: Unexpected error during Google Maps initialization: $e');
      throw e;
    }
  }
}
