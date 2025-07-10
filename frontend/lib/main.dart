// import 'package:doctor_app/core/constants/approutes/approutes.dart';
// import 'package:doctor_app/data/services/socket_service.dart';
// import 'package:doctor_app/provider/auth_provider.dart';
// import 'package:doctor_app/provider/call_provider.dart';
// import 'package:doctor_app/provider/chat_provider.dart';
// import 'package:doctor_app/provider/doctor_provider.dart';
// import 'package:doctor_app/provider/patient_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final prefs = await SharedPreferences.getInstance();
//   final bool isFirstLaunch = prefs.getBool('isFirstTime') == null;

//   if (isFirstLaunch) {
//     await prefs.setBool('isFirstTime', false);
//   }

//   // Check login status
//   final token = prefs.getString('token');
//   final loginTime = prefs.getInt('loginTime');
//   bool isLoggedIn = false;

//   if (token != null && loginTime != null) {
//     final now = DateTime.now().millisecondsSinceEpoch;
//     isLoggedIn = now - loginTime < 12 * 60 * 60 * 1000;
//   }

//   // Decide initial route
//   String initialRoute;

//   if (isFirstLaunch) {
//     initialRoute = Routes.onboarding;
//   } else if (isLoggedIn) {
//     initialRoute = Routes.homeScreen;
//   } else {
//     initialRoute = Routes.splash;
//   }

//   runApp(MyApp(initialRoute: initialRoute));
// }

// class MyApp extends StatelessWidget {
//   final String initialRoute;

//   const MyApp({super.key, required this.initialRoute});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<SocketService>(create: (_) => SocketService()),
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => DoctorProvider()),
//         ChangeNotifierProvider(create: (_) => PatientProvider()),
//         ChangeNotifierProvider(create: (_) => ChatProvider()),
//         ChangeNotifierProvider(
//           create: (context) {
//             final callProvider = CallProvider();
//             // CallProvider ka init() method yahan call kiya jayega
//             callProvider.init();
//             return callProvider;
//           },
//         ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Doctor App',
//         theme: ThemeData(useMaterial3: true, fontFamily: 'Outfit'),
//         initialRoute: initialRoute,
//         onGenerateRoute: Routes.generateRoute,
//       ),
//     );
//   }
// }
// main.dart

import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/data/services/socket_service.dart';
import 'package:doctor_app/presentation/screens/voice/incoming_call_screen.dart';
import 'package:doctor_app/provider/auth_provider.dart';
import 'package:doctor_app/provider/call_provider.dart';
import 'package:doctor_app/provider/chat_provider.dart';
import 'package:doctor_app/provider/doctor_provider.dart';
import 'package:doctor_app/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isFirstLaunch = prefs.getBool('isFirstTime') == null;

  if (isFirstLaunch) {
    await prefs.setBool('isFirstTime', false);
  }

  // Login status check karein
  final token = prefs.getString('token');
  final loginTime = prefs.getInt('loginTime');
  bool isLoggedIn = false;

  if (token != null && loginTime != null) {
    final now = DateTime.now().millisecondsSinceEpoch;
    // Token ki validity 12 ghante (12 * 60 * 60 * 1000 milliseconds)
    isLoggedIn = now - loginTime < 12 * 60 * 60 * 1000;
  }

  // Initial route decide karein
  String initialRoute;
  if (isFirstLaunch) {
    initialRoute = Routes.onboarding;
  } else if (isLoggedIn) {
    initialRoute = Routes.homeScreen;
  } else {
    initialRoute = Routes.splash;
  }

  runApp(MyApp(initialRoute: initialRoute));
}

// MyApp ab StatefulWidget hai takay NavigatorState aur CallProvider Listener ko manage kar sake
class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // GlobalKey for NavigatorState takay kisi bhi context se routes push kar sakein
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool _isNavigatingToCallScreen = false;
  late VoidCallback _callProviderListener; // Listener function ko store karein

  @override
  void initState() {
    super.initState();
    // Listener function ko define karein
    _callProviderListener = () {
      // Pehle check karein ke NavigatorState aur widget mounted hain
      if (_navigatorKey.currentState == null || !mounted) {
        print(
          "💡 NavigatorState ya MyApp unmounted hai. Call event process nahi ho sakta.",
        );
        return;
      }

      // CallProvider ko Navigator's context se access karein
      final callProvider = Provider.of<CallProvider>(
        _navigatorKey.currentContext!,
        listen: false,
      );

      if (callProvider.incomingCallData != null && !_isNavigatingToCallScreen) {
        print(
          "💡 Incoming call detected in _MyAppState: ${callProvider.incomingCallData}",
        );
        _isNavigatingToCallScreen = true;

        // IncomingCallScreen par navigate karein using GlobalKey
        _navigatorKey.currentState!
            .push(
              MaterialPageRoute(
                builder:
                    (context) => IncomingCallScreen(
                      callData:
                          callProvider.incomingCallData!, // Incoming call data
                    ),
              ),
            )
            .then((_) {
              // Jab IncomingCallScreen pop ho jaye, toh flag reset kar dein
              if (mounted) {
                // Ensure widget is still mounted before updating state
                _isNavigatingToCallScreen = false;
              }
            });
      }
    };

    // Providers initialize hone ke baad listener set up karein
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _navigatorKey.currentContext != null) {
        _setupCallListener();
      }
    });
  }

  void _setupCallListener() {
    // listen: false ka istemal karein takay listener CallProvider ki state changes par dubara run na ho
    final callProvider = Provider.of<CallProvider>(
      _navigatorKey.currentContext!,
      listen: false,
    );
    callProvider.addListener(_callProviderListener);
  }

  @override
  void dispose() {
    // Listener ko remove karein jab widget dispose ho jaye
    if (_navigatorKey.currentContext != null) {
      final callProvider = Provider.of<CallProvider>(
        _navigatorKey.currentContext!,
        listen: false,
      );
      callProvider.removeListener(_callProviderListener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SocketService>(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(
          create: (context) {
            final callProvider = CallProvider();
            callProvider
                .init(); // CallProvider ka init() method yahan call kiya jayega
            return callProvider;
          },
        ),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey, // Navigator key ko set karein
        debugShowCheckedModeBanner: false,
        title: 'Doctor App',
        theme: ThemeData(useMaterial3: true, fontFamily: 'Outfit'),
        initialRoute: widget.initialRoute, // Initial route yahan set karein
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
