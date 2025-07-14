import 'package:algebraic/routes/route_constants.dart';
import 'package:algebraic/utils/constants.dart';
import 'package:algebraic/view/about_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/modules_list_model.dart';
import '../models/user.dart';
import '../services/api_provider.dart';
import '../utils/sharedpref.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ModulesList> modulesList = [];

  // List algebra = [
  //   'Polynomials',
  //   'Functions',
  //   'Quadratics',
  //   'Equations and Inequalities',
  //   'Exponential Functions and Financial Literacy',
  //   'Linear Functions',
  //   'Probability and Statistics'
  // ];

  Future<void> getModulesList() async {
    setState(() {
      isloading = true;
    });
    GetModulesApiProvider modulesListApi = GetModulesApiProvider();
    try {
      await modulesListApi.getModulesAPI(userDetails.id).then((op) => {
            setState(() {
              if (op["data"] != null) {
                final List resItems = op["data"];
                modulesList = resItems
                    .map((resRaw) => ModulesList.fromJson(resRaw))
                    .toList();
              } else {
                Fluttertoast.showToast(msg: op["error"]);
              }
            }),
            setState(() {
              isloading = false;
            })
          });
    } catch (e) {
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(msg: 'An error occurred.Please try again.');
    }
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: themeColor,
      
      // toolbarHeight: 64,
      title: Row(
        children: [
          SvgPicture.asset(
            CustomIcons.logo,
            height: 28,
            width: 28,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              ' Algebraic!',
              style: TextStyle(
                  fontSize: 15.75,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: CircleAvatar(
            radius: 14,
            backgroundColor: activeColorGreen,
            child: Text(
              userDetails.firstName![0].toUpperCase(),
              style: TextStyle(
                  fontSize: 13.85,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  Padding formulaSheet() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, formulaSheetRoute);
        },
        child: Container(
          height: 65,
          decoration: BoxDecoration(
              color: activeColorGreen, borderRadius: BorderRadius.circular(9)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: SvgPicture.asset(CustomIcons.formulaSheet),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      'Formula Sheet',
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Icon(
                  Icons.keyboard_arrow_right_sharp,
                  color: Colors.white,
                  size: 35,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding markList() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: modulesList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.0),

              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AboutModule(quizattempt:modulesList[index].quizAttempt,
                              moduleId: modulesList[index].order_no,
                              moduleName: modulesList[index].name,
                              moduleDescription: modulesList[index].description,
                              module: modulesList[index],
                      )));
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Container(
                      //  height: 74,
                      decoration: BoxDecoration(
                        color: modulesList[index].scorePercentage == null
                            ? Color.fromRGBO(217, 217, 217, 1)
                            : modulesList[index].scorePercentage == 100
                                ? activeColorGreen
                                : modulesList[index].scorePercentage >= 66
                                    ? Color.fromRGBO(26, 190, 242, 1)
                                    : modulesList[index].scorePercentage >= 33
                                        ? Color.fromRGBO(242, 195, 26, 1)
                                        : Color.fromRGBO(255, 124, 124, 1),
                        borderRadius: BorderRadius.all(Radius.circular(7.6)),
                        // border: Border(
                        //     left: BorderSide(color: activeColorGreen, width: 4)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                              //height: 74,
                              ),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.25),
                                      spreadRadius: 0.5,
                                      blurRadius: 1,
                                      offset: Offset(2, 1),
                                      blurStyle: BlurStyle.normal),
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(children: [
                                    Padding(
                                        padding: EdgeInsets.only(left: 11),
                                        child: CircularPercentIndicator(
                                          radius: 25.0,
                                          lineWidth: 4.0,
                                          animation: true,
                                          percent: (modulesList[index]
                                                          .scorePercentage ==
                                                      "" ||
                                                  modulesList[index]
                                                          .scorePercentage ==
                                                      null)
                                              ? 0
                                              : (modulesList[index]
                                                      .scorePercentage! /
                                                  100),
                                          progressColor: modulesList[index]
                                                      .scorePercentage ==
                                                  null
                                              ? Color.fromRGBO(217, 217, 217, 1)
                                              : modulesList[index]
                                                          .scorePercentage ==
                                                      100
                                                  ? activeColorGreen
                                                  : modulesList[index]
                                                              .scorePercentage >=
                                                          66
                                                      ? Color.fromRGBO(
                                                          26, 190, 242, 1)
                                                      : modulesList[index]
                                                                  .scorePercentage >=
                                                              33
                                                          ? Color.fromRGBO(
                                                              242, 195, 26, 1)
                                                          : Color.fromRGBO(
                                                              255, 124, 124, 1),
                                          center: Text(
                                            (modulesList[index].scorePercentage ==
                                                    null)
                                                ? "0%"
                                                : modulesList[index]
                                                        .scorePercentage!
                                                        .toStringAsFixed(0) +
                                                    "%",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                                color: Color.fromRGBO(
                                                    67, 77, 94, 1)),
                                          ),
                                        )),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 11),
                                        child: Text(
                                          modulesList[index].name!,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: paragraphFont),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18.0, bottom: 18, right: 14),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(235, 238, 248, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Attempt',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    62, 81, 141, 1)),
                                          ),
                                          Text(
                                            (modulesList[index].quizAttempt ?? 0)
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    62, 81, 141, 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            );
          }),
    );
  }

  bool isloading = true;
  UserDetails? user;
  UserDetails userDetails = UserDetails();

  Future<void> getInitialValue() async {
    setState(() {
      isloading = true;
    });
    SharedPref sharedPref = SharedPref();
    user = UserDetails.fromJson(await sharedPref.read("user"));

    setState(() {
      userDetails = user!;
      isloading = false;
    });
    getModulesList();
  }

  @override
  void initState() {
    DefaultCacheManager().emptyCache();
    //   DefaultCacheManager().dispose();
    getInitialValue();

    super.initState();
  }
  @override
  void dispose() {
    //...
    super.dispose();
    //...
  }

  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;
    final theme = Theme.of(context);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if(!didPop) {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
            currentBackPressTime = now;
            Fluttertoast.showToast(msg: "Press back again to exit app");

            return;
          }

          Navigator.pop(context);
        }
      },
      child: isloading
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: themeColor,
                  strokeWidth: 2,
                ),
              ),
            )
          : Scaffold(
              key: _scaffoldKey,
              appBar: appBar(),
              body: isloading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: themeColor,
                        strokeWidth: 2,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 17.0, right: 17),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: Text(
                                'Welcome ${userDetails.firstName!}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: theme.colorScheme.secondary),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: RichText(
                                text: TextSpan(
                                    text: 'Have fun ',
                                    style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(34, 34, 34, 1)),
                                    children: [
                                      TextSpan(
                                        text: 'learning!',
                                        style: TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                            color: activeColorGreen),
                                      )
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                '''Click on the various buttons to go to content, practice tests and a main information page that includes the most important facts to know for the EOC.''',
                                style: TextStyle(
                                    height: 1.5,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: paragraphFont),
                              ),
                            ),
                            formulaSheet(),
                            Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: Text(
                                'Algebra Modules',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(34, 34, 34, 1)),
                              ),
                            ),
                            markList()
                          ],
                        ),
                      ),
                    ),
            ),
    );
  }
}
