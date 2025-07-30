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
import 'package:doctor_app/provider/auth_provider.dart';
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

  final token = prefs.getString('token');
  final loginTime = prefs.getInt('loginTime');
  bool isLoggedIn = false;

  if (token != null && loginTime != null) {
    final now = DateTime.now().millisecondsSinceEpoch;
    isLoggedIn = now - loginTime < 12 * 60 * 60 * 1000;
  }

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

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String? _userId;
  // String? _userName;

  // final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  // ✅ ZegoCloud AppID aur AppSign
  // Inhe apne ZegoCloud console se confirm kar len
  // static const int appId = 10560672;
  // static const String appSign =
  //     "cd989de409cca06a3f06af0cd61efad746db9d1a5b1b9099f13b99684821ccc0";

  // @override
  // void initState() {
  //   super.initState();
  //   _initZego();
  // }

  // Future<void> _initZego() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userString = prefs.getString('user');
  //   if (userString == null) {
  //     debugPrint("❌ User data not found in SharedPreferences.");
  //     return;
  //   }

  //   final user = jsonDecode(userString);
  //   _userId = user['id']?.toString();
  //   _userName = user['name'];

  //   if (_userId == null || _userName == null) {
  //     debugPrint("❌ User ID or UserName is null after parsing.");
  //     return;
  //   }

  //   // ✅ NOTE: setNavigatorKey ko init se pehle call karein
  //   ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(_navigatorKey);

  //   // ✅ init invitation service
  //   ZegoUIKitPrebuiltCallInvitationService().init(
  //     appID: appId,
  //     appSign: appSign,
  //     userID: _userId!,
  //     userName: _userName!,
  //     plugins: [ZegoUIKitSignalingPlugin()],
  //   );

  //   debugPrint("✅ Zego initialized with $_userId / $_userName");
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SocketService>(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        // CallProvider ko bhi yahan provide karein agar ye app-wide use hota hai
        // Agar AllVoiceCallScreen mein Provider.of<CallProvider> use ho raha hai
        // aur CallProviderMyApp ke scope mein initialize nahi hai, to yahan add karein:
        // ChangeNotifierProviPr(create: (_) => CallProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Doctor App',
        theme: ThemeData(useMaterial3: true, fontFamily: 'Outfit'),
        initialRoute: widget.initialRoute,
        onGenerateRoute: Routes.generateRoute,
        // navigatorKey: _navigatorKey, // ✅ NavigatorKey ko set karna zaroori hai
      ),
    );
  }
}
