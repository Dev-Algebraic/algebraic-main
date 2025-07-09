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
      theme: ThemeData(
        fontFamily:"Poppins",
        colorScheme: ColorScheme.light(
          primaryContainer: Color.fromRGBO(219, 224, 239, 1),
          secondaryContainer: Color.fromRGBO(237, 240, 247, 1),
          tertiary: Color.fromRGBO(11, 38, 243, 1),

          surfaceTint: Color.fromRGBO(242, 242, 242, 1),
          primary: Color.fromRGBO(17, 17, 17, 1),
          secondary: Color.fromRGBO(32, 32, 32, 1),
        ),
      ),
      onGenerateRoute: router.generateRoute,
      home: !loader
          ? sessionUser == null
              ? const Login()
              : const Dashboard()
          :Container(),
    );
  }
}
