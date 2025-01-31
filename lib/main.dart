import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'presentation/screens/home_page.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'services/auth_service.dart';
import 'services/platform_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  try {
    print('Starting app initialization...');

    print('Initializing Flutter bindings...');
    WidgetsFlutterBinding.ensureInitialized();
    print('Flutter bindings initialized');

    print('Loading environment variables...');
    await dotenv.load(fileName: ".env");
    print('Environment variables loaded successfully');
    print(
        'GOOGLE_MAPS_API_KEY present: ${dotenv.env['GOOGLE_MAPS_API_KEY']?.isNotEmpty == true}');
    print(
        'FIREBASE_API_KEY present: ${dotenv.env['FIREBASE_API_KEY']?.isNotEmpty == true}');

    print('Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');

    print('Initializing Google Maps...');
    await PlatformService.initializeGoogleMaps();
    print('Google Maps initialized successfully');

    print('Starting app...');
    runApp(const MyApp());
    print('App started successfully');
  } catch (e, stackTrace) {
    print('ERROR during initialization: $e');
    print('Stack trace: $stackTrace');
    // You might want to show an error screen instead of crashing
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error initializing app: $e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fishing Paradise',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      routes: {
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          return const HomePage();
        }

        return const LoginScreen();
      },
    );
  }
}
