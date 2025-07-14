import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:algebraic/utils/sharedpref.dart';

// Import screens
import 'package:algebraic/main.dart';
import 'package:algebraic/view/formulasheet.dart';
import 'package:algebraic/view/profile.dart';
import 'package:algebraic/view/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NavigationBarApp());
}

// Root application
class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins",
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          surfaceTint: Color.fromRGBO(242, 242, 242, 1),
          primary: Color.fromRGBO(17, 17, 17, 1),
          secondary: Color.fromRGBO(32, 32, 32, 1),
          primaryContainer: Color.fromRGBO(219, 244, 239, 1),
          secondaryContainer: Color.fromRGBO(237, 240, 247, 1),
        ),
      ),

      home: NavigationController()
    );
  }
}

// Navigation Controller
class NavigationController extends StatefulWidget {
  const NavigationController({super.key});

  @override
  State<NavigationController> createState() => _NavigationControllerState();
}

// Navigation bar
class _NavigationControllerState extends State<NavigationController> {
  int currentPageIndex = 0;
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
    return _buildNavbar(context);
  }

  Widget _buildNavbar(context) {
    bool isiOS = Theme.of(context).platform == TargetPlatform.iOS;
    final ThemeData theme = Theme.of(context);

    return !loader
      ? (sessionUser == null
          ? const Login()
          : (isiOS
              ? iosNavbar(theme)
              : andoirdNavbar(theme)))
      : const CircularProgressIndicator();
  }

  // iOS navbar
  Widget iosNavbar(theme) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: theme.colorScheme.surfaceTint,
        activeColor: Color.fromRGBO(36, 87, 197, 1),
        height: 60.0,
        
        items: const <BottomNavigationBarItem>[
          // Icons (bottom)

          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house), 
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_text),
            activeIcon: Icon(CupertinoIcons.doc_text_fill, size: 35),
            
            label: 'Formula Sheet'
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.person_fill), 
            icon: Icon(CupertinoIcons.person), 
            label: 'Profile'
          ),
        ],
      ),

      tabBuilder: (BuildContext context, int index) {
        // Views (top)

        switch(index){
          case 0:
            // Home screen
            return MyApp();
          case 1:
            // Formula sheet screen
            return FormulaSheet(isSubview: false);
          case 2:
          default:
            // Profile screen
            return Profile();
        }
      }
    );
  }

  Widget andoirdNavbar(theme) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: theme.colorScheme.surfaceTint,
        indicatorColor: Color.fromRGBO(36, 87, 197, 1),
        height: 60.0,

        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },

        selectedIndex: currentPageIndex,

        destinations: const <Widget>[
          // Icons (bottom)

          NavigationDestination(
            selectedIcon: Icon(Icons.home_filled),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.feed_rounded),
            icon: Icon(Icons.feed_outlined),
            label: 'Formula Sheet',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),

      body: 
        // Views (top)
        
        <Widget>[
          MyApp(),
          FormulaSheet(isSubview: false),
          Profile(),
        ][currentPageIndex],
    );
  }
}