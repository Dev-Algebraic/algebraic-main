import 'package:algebraic/routes/route_constants.dart';
import 'package:algebraic/view/about_module.dart';
import 'package:algebraic/view/about_sub_module.dart';
import 'package:algebraic/view/dashboard.dart';
import 'package:algebraic/view/formulasheet.dart';
import 'package:algebraic/view/introduction.dart';
import 'package:algebraic/view/login.dart';
import 'package:algebraic/view/profile.dart';
import 'package:algebraic/view/signup.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    //INITIAL ROUTE
    case aboutModuleRoute:
      return MaterialPageRoute(
        builder: (context) => AboutModule(),
      );

    case aboutSubModuleRoute:
      return MaterialPageRoute(
        builder: (context) => AboutSubmodule(),
      );
    case dashboardRoute:
      return MaterialPageRoute(
        builder: (context) => const Dashboard(),
      );
    case formulaSheetRoute:
      return MaterialPageRoute(
        builder: (context) => const FormulaSheet(),
      );
    case introductionRoute:
      return MaterialPageRoute(
        builder: (context) => const Introduction(),
      );
    case loginRoute:
      return MaterialPageRoute(
        builder: (context) => const Login(),
      );
    case profileRoute:
      return MaterialPageRoute(
        builder: (context) => const Profile(),
      );
    // case quizRoute:
    //   return MaterialPageRoute(
    //     builder: (context) =>  Quiz(),
    //   );
    case signUpRoute:
      return MaterialPageRoute(
        builder: (context) => const SignUp(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Dashboard(),
      );
  }
}
