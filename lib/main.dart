import 'package:algebraic/utils/sharedpref.dart';
import 'package:algebraic/view/dashboard.dart';
import 'package:algebraic/view/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'routes/route.dart' as router;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SharedPreferences.setMockInitialValues({});
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  //UserDetails? user;
  bool loader = true;
  dynamic sessionUser;

  @override
  void initState() {
    getInitial();
    super.initState();
  }

  Future<void> getInitial() async {
    SharedPref sharedPref = SharedPref();

    sessionUser = await sharedPref.read("user");

    setState(() {
      loader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Algebraic',
      theme: ThemeData(fontFamily:"Poppins"),
      onGenerateRoute: router.generateRoute,
      home: !loader
          ? sessionUser == null
              ? const Login()
              : const Dashboard()
          :Container(),
    );
  }
}
