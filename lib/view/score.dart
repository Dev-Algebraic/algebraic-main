import 'package:algebraic/utils/constants.dart';
import 'package:algebraic/view/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScoreCard extends StatefulWidget {
  final int? moduleId;
  final int? userId;
  final String? moduleName;
  final String? moduleDescription;
  final int? quizAttempt;
  final int? score;
  final int? noQ;

  const ScoreCard({
    Key? key,
    this.moduleId,
    this.userId,
    this.moduleName,
    this.moduleDescription,
    this.quizAttempt,
    this.score,
    this.noQ,
  }) : super(key: key);

  @override
  State<ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  @override
  void initState() {
    super.initState();
  }

//Press back again to exit app funcion
  Future<bool> onWillPop() async {
    return false;
  }
  @override
  void dispose() {
    //...
    super.dispose();
    //...
  }

  //Progress indicator selection
  Widget getPogressGraph() {
    var percentage = (widget.score! / widget.noQ!) * 100;
    if (percentage == 0) {
      return SvgPicture.asset(
        CustomIcons.per0,
      );
    } else if (percentage <= 10) {
      return SvgPicture.asset(
        CustomIcons.per10,
      );
    } else if (percentage <= 20) {
      return SvgPicture.asset(
        CustomIcons.per20,
      );
    } else if (percentage <= 30) {
      return SvgPicture.asset(
        CustomIcons.per30,
      );
    } else if (percentage <= 40) {
      return SvgPicture.asset(
        CustomIcons.per40,
      );
    } else if (percentage <= 50) {
      return SvgPicture.asset(
        CustomIcons.per50,
      );
    } else if (percentage <= 60) {
      return SvgPicture.asset(
        CustomIcons.per60,
      );
    } else if (percentage <= 70) {
      return SvgPicture.asset(
        CustomIcons.per70,
      );
    } else if (percentage <= 80) {
      return SvgPicture.asset(
        CustomIcons.per80,
      );
    } else if (percentage <= 99.9) {
      return SvgPicture.asset(
        CustomIcons.per90,
      );
    } else {
      return SvgPicture.asset(
        CustomIcons.per100,
      );
    }
  }

  //Rating text selection
  Widget getRatingText() {
    var percentage = (widget.score! / widget.noQ!) * 100;
    if (percentage < 25) {
      return const Text(
        "Bad",
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 32.0,
            color: Color.fromRGBO(255, 77, 15, 1)),
      );
    } else if (percentage < 50) {
      return const Text(
        "Poor",
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 32.0,
            color: Color.fromRGBO(255, 162, 31, 1)),
      );
    } else if (percentage < 75) {
      return const Text(
        "Fair",
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 32.0,
            color: Color.fromRGBO(237, 233, 110, 1)),
      );
    } else if (percentage < 100) {
      return const Text(
        "Good",
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 32.0,
            color: Color.fromRGBO(148, 179, 17, 1)),
      );
    } else if (percentage == 100) {
      return const Text(
        "Awesome",
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 32.0,
            color: Color.fromRGBO(148, 179, 17, 1)),
      );
    } else {
      return const Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Your score is",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 19.0,
                      color: Color.fromRGBO(67, 77, 94, 1)),
                ),
                getRatingText(),
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    Align(
                        alignment: Alignment.center, child: getPogressGraph()),
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Text(
                                widget.score.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 54.0,
                                    color: Colors.black),
                              ),
                              Text(
                                "out of ${widget.noQ}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  " Your score is based on the number of\n correct answers",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                      color: Color.fromRGBO(150, 161, 178, 1)),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color.fromRGBO(161, 195, 21, 1)),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ))),
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Dashboard()),
                          ),
                      child: Text("Finish".toUpperCase(),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500))
                      // postQuizScore(),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> getColor(rating) {
    List<Color> colors = [];
    switch (rating) {
      case 0:
        colors = [Colors.red[800]!];
        break;
      case 1:
        colors = [
          Colors.red[800]!,
          // Colors.red[400]!,
        ];
        break;
      case 2:
        colors = [
          Colors.red[800]!,
          // Colors.red[400]!,
          // Colors.orange[800]!,
        ];
        break;
      case 3:
        colors = [
          Colors.red[800]!,
          Colors.red[400]!,
          Colors.orange[800]!,
          // Colors.orange[400]!
        ];
        break;
      case 4:
        colors = [
          Colors.red[800]!,
          Colors.red[400]!,
          Colors.orange[800]!,
          Colors.orange[400]!,
          // Colors.yellow[800]!,
          // Colors.yellow[400]!
        ];
        break;
      case 5:
        colors = [
          Colors.red[800]!,
          Colors.red[400]!,
          Colors.orange[800]!,
          Colors.orange[400]!,
          Colors.yellow[800]!,
          // Colors.yellow[400]!,
          // Colors.lightGreen[800]!,
          // Colors.lightGreen[400]!
        ];
        break;
      case 6:
        colors = [
          Colors.orange[800]!,
          Colors.yellow[800]!,
          Colors.green[400]!,
          Colors.green[400]!,
          Colors.green[800]!,
        ];
        break;
      case 7:
        colors = [
          Colors.green,
          Colors.lightGreen,
          Colors.yellow,
          Colors.orange,
        ];
        break;
      case 8:
        colors = [
          Colors.green,
          Colors.lightGreen,
          Colors.yellow,
          Colors.orange,
        ];
        break;
      case 9:
        colors = [
          Colors.green,
          Colors.lightGreen,
          Colors.yellow,
          Colors.orange,
          Colors.red
        ];
        break;
      case 10:
        colors = [
          Colors.green,
          Colors.lightGreen,
          Colors.yellow,
          Colors.orange,
          Colors.red
        ];
        break;
    }
    return colors;
  }
}
