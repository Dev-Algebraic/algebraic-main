import 'package:algebraic/view/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:algebraic/navbar_controller.dart';
import '../utils/constants.dart';

class Introduction extends StatefulWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  State<Introduction> createState() => _IntroductionState();
}

const htmlData = r"""
  <h1 style="font-family: 'Inter'; font-style: normal; font-weight: 400; font-size: 36px; color: #000000;">
    Welcome to <br>Algebraic!
  </h1>
  <p style="font-family: 'Inter'; font-style: normal; font-weight: 400; color: #000000;">
    This app goes over all of the major topics in Algebra 1 and can be used as study material to understand topics in Algebra 1 and test your knowledge to help prepare for class tests and the EOC at the end of the year.
    Click on the various buttons to go to content, practice tests, and a main information page that includes the most important facts to know for the EOC.
    <br><br>
  </p>
""";


class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (BuildContext context) => SignUp()));
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leadingWidth: 70,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Row(
              children: const [
                // InkWell(
                //   onTap: () {
                //     Navigator.pushReplacement(
                //         context,
                //         MaterialPageRoute(
                //             builder: (BuildContext context) => SignUp()));
                //   },
                //   child: Icon(
                //     Icons.arrow_back_ios,
                //     color: themeColor,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        body: Stack(children: [
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                child: SvgPicture.asset(
                  CustomIcons.background,
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 120.0, left: 25, right: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Html(
                    data: htmlData,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 25.0),
                  //   child: Align(
                  //     alignment: Alignment.bottomRight,
                  //     child: InkWell(
                  //       onTap: () {
                  //         Navigator.pushReplacement(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (BuildContext context) =>
                  //                     Dashboard()));
                  //       },
                  //       child: Icon(
                  //         Icons.arrow_circle_right,
                  //         size: 70,
                  //         color: activeColorGreen,
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ]),
        floatingActionButton: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const NavigationBarApp()));
                        },
                        child: Icon(
                          Icons.arrow_circle_right,
                          size: 70,
                          color: activeColorGreen,
                        ),
                      ),
      ),
    );
  }
}
