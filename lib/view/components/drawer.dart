import 'package:algebraic/routes/route_constants.dart';
import 'package:algebraic/view/about_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/modules_list_model.dart';
import '../../models/user.dart';
import '../../services/api_provider.dart';
import '../../utils/constants.dart';
import '../../utils/sharedpref.dart';

class DrawerWidget extends StatefulWidget {
  final dynamic selectedItem;
  const DrawerWidget({Key? key, this.selectedItem}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  // List algebra = [
  //   'Polynomials',
  //   'Functions',
  //   'Quadratics',
  //   'Equations and Inequalities',
  //   'Exponential Functions and Financial Literacy',
  //   'Linear Functions',
  //   'Probability and Statistics'
  // ];
  List<ModulesList> modulesList = [];
  bool algebraSelected = false;
  UserDetails? user;
  UserDetails userDetails = UserDetails();
  //bool isLoading = true;

  Future<void> getInitialValue() async {
    setState(() {
      algebraSelected = true;
    });
    SharedPref sharedPref = SharedPref();
    user = UserDetails.fromJson(await sharedPref.read("user"));

    setState(() {
      userDetails = user!;
      algebraSelected = false;
    });
    getModulesList();
  }

  Future<void> getModulesList() async {
    setState(() {
      algebraSelected = true;
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
              algebraSelected = false;
            })
          });
    } catch (e) {
      setState(() {
        algebraSelected = false;
      });
      Fluttertoast.showToast(msg: 'An error occurred.Please try again.');
    }
  }

  @override
  void initState() {
    getInitialValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: themeColor,
      child: ListView(
        padding: const EdgeInsets.only(top: 50, bottom: 30),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color.fromRGBO(0, 0, 0, 0.11),
                    child: CircleAvatar(
                      radius: 12.5,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: themeColor,
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Color.fromRGBO(0, 0, 0, 0.11),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, dashboardRoute);
                },
                child: const Padding(
                  padding:
                      EdgeInsets.only(top: 15.0, bottom: 15, right: 30),
                  child: Text(
                    'Home',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    algebraSelected = !algebraSelected;
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: algebraSelected
                          ? const Color.fromRGBO(0, 0, 0, 0.11)
                          : themeColor,
                      border: algebraSelected
                          ? Border(
                              right:
                                  BorderSide(color: activeColorGreen, width: 4),
                            )
                          : null),
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: algebraSelected ? 26.0 : 30,
                        top: 15,
                        bottom: 15),
                    child: Text(
                      'Algebra Content',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: algebraSelected
                              ? activeColorGreen
                              : Colors.white),
                    ),
                  ),
                ),
              ),
              algebraSelected
                  ? Container(
                      color: const Color.fromRGBO(0, 0, 0, 0.11),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                          for (var i = 0; i < modulesList.length; i++)
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AboutModule(
                                          quizattempt: modulesList[i].quizAttempt,
                                            moduleId: modulesList[i].order_no,
                                            moduleName: modulesList[i].name,
                                            moduleDescription:
                                                modulesList[i].description)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 30.0, top: 30, bottom: 15),
                                child: Text(
                                  modulesList[i].name!,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : Container(),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, formulaSheetRoute);
                },
                child: const Padding(
                  padding: EdgeInsets.only(
                      top: 15.0,
                      //bottom: 30,
                      right: 30),
                  child: Text(
                    'Formula Sheet',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.pushReplacement(context,
              //         MaterialPageRoute(builder: (context) => PdfViewerPage()));
              //   },
              //   child: const Padding(
              //     padding: EdgeInsets.only(
              //         top: 15.0,
              //         //bottom: 30,
              //         right: 30),
              //     child: Text(
              //       'PDF Viewer',
              //       textAlign: TextAlign.end,
              //       style: TextStyle(
              //           fontSize: 24,
              //           fontWeight: FontWeight.w600,
              //           color: Colors.white),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(right: 30, bottom: 15),
              //   child: Text(
              //     'Settings',
              //     textAlign: TextAlign.end,
              //     style: TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w400,
              //         color: Color.fromRGBO(243, 244, 248, 1)),
              //   ),
              // ),
              // InkWell(
              //   onTap: () {
              //     Navigator.pushNamed(context, profileRoute);
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.only(right: 30.0, top: 0),
              //     child: Text(
              //       'My Profile',
              //       textAlign: TextAlign.end,
              //       style: TextStyle(
              //           fontSize: 24,
              //           fontWeight: FontWeight.w600,
              //           color: Colors.white),
              //     ),
              //   ),
              // ),
              InkWell(
                onTap: () {
                  onLogout();
                },
                child: Padding(
                    padding: const EdgeInsets.only(right: 30.0, top: 30),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color.fromRGBO(243, 244, 248, 1),
                      child: SvgPicture.asset(CustomIcons.logout),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> onLogout() async {
    SharedPref sharedPref = SharedPref();

    await sharedPref.remove("user");
    Navigator.pushNamed(context, loginRoute);
  }
}
