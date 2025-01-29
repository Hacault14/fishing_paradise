# Fishing Paradise

A mobile application for anglers to track and share their fishing catches, view catch locations on an interactive map, and get real-time weather information.

## Features

- 🎣 Record fishing catches with details (species, length, weight)
- 📍 Automatic location tracking for each catch
- 🗺️ Interactive map with catch locations and heatmap
- 🌤️ Real-time weather information for each catch
- 🔍 Filter catches by fish species
- 📱 User authentication with email and Google Sign-In
- 📸 Photo capture for catches

## Setup

### Prerequisites

- Flutter SDK (>=3.0.0)
- Firebase account
- OpenWeather API key
- Google Maps API key

### Environment Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/fishing_paradise.git
cd fishing_paradise
```

2. Copy `.env.template` to create your `.env` file:
```bash
cp .env.template .env
```

3. Fill in your API keys and configuration in `.env`:
```
OPENWEATHER_API_KEY=your_openweather_api_key
GOOGLE_MAPS_API_KEY=your_google_maps_key
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_APP_ID=your_firebase_app_id
FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_storage_bucket
FIREBASE_IOS_BUNDLE_ID=your_ios_bundle_id
FIREBASE_ANDROID_APP_ID=your_android_app_id
```

### Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication (Email/Password and Google Sign-In)
3. Create a Firestore database
4. Add Android and iOS apps to your Firebase project
5. Download and place configuration files:
   - Android: Place `google-services.json` in `android/app/`
   - iOS: Place `GoogleService-Info.plist` in `ios/Runner/`

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── config/           # Configuration files
├── models/           # Data models
├── presentation/     # UI components
│   ├── screens/     # App screens
│   └── widgets/     # Reusable widgets
└── services/        # Business logic and services
```

## Dependencies

- firebase_core, firebase_auth - Firebase integration
- google_maps_flutter - Google Maps integration
- weather - OpenWeather API integration
- geolocator - Location services
- image_picker - Camera functionality
- flutter_dotenv - Environment variables
- intl - Date formatting

## Security Notes

- Never commit the `.env` file
- Keep API keys and sensitive data private
- Use environment variables for all sensitive configuration
- Follow Firebase security best practices

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details

## Acknowledgments

- OpenWeather API for weather data
- Google Maps Platform for mapping services
- Firebase for backend services
