import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/provider/auth_provider.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  // Check if it's the first launch
  final bool isFirstLaunch = prefs.getBool('isFirstTime') == null;

  // If first time, set the flag
  if (isFirstLaunch) {
    await prefs.setBool('isFirstTime', false);
  }

  // Check login status
  final token = prefs.getString('token');
  final loginTime = prefs.getInt('loginTime');
  bool isLoggedIn = false;

  if (token != null && loginTime != null) {
    final now = DateTime.now().millisecondsSinceEpoch;
    isLoggedIn = now - loginTime < 12 * 60 * 60 * 1000;
  }

  // Decide initial route
  String initialRoute;

  if (isFirstLaunch) {
    initialRoute = Routes.onboarding; // Splash → Login
  } else if (isLoggedIn) {
    initialRoute = Routes.homeScreen; // Direct to home
  } else {
    initialRoute = Routes.splash; // Onboarding
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Doctor App',
        theme: ThemeData(useMaterial3: true, fontFamily: 'Outfit'),
        initialRoute: initialRoute,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
