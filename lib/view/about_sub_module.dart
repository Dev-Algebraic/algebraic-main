import 'package:algebraic/routes/route_constants.dart';
import 'package:algebraic/view/quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_math/flutter_html_math.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user.dart';
import '../services/api_provider.dart';
import '../utils/constants.dart';
import '../utils/sharedpref.dart';

class AboutSubmodule extends StatefulWidget {
  final int? topicId;
  final List? readTopicList;
  final String? htmlContent;
  final ValueChanged? onchanged;
  final int? moduleId;
  final String? moduleName;
  final String? topicName;
  final String? moduleDescription;
  final int? quizattempt;
  const AboutSubmodule({
    super.key,
    this.topicId,
    this.readTopicList,
    this.onchanged,
    this.htmlContent,
    this.moduleId,
    this.moduleName,
    this.moduleDescription,
    this.topicName,
    this.quizattempt,
  });

  @override
  State<AboutSubmodule> createState() => _AboutSubmoduleState();
}

class _AboutSubmoduleState extends State<AboutSubmodule> {
  bool isLoading = false;

  Future<void> postRead() async {
    setState(() => isLoading = true);
    PostReadApiProvider read = PostReadApiProvider();

    Map payLoad = {
      "topicId": widget.topicId.toString(),
      "userId": userDetails.id.toString(),
      "createdBy": null
    };
    SharedPref sharedPref = SharedPref();
    try {
      await read.postReadAPI(payLoad).then(
        (op) async {
          if (op["error"] == null && op["data"] != null) {
            // final List resItems = op["data"];
            widget.readTopicList!.add(op["data"][0]);
            await sharedPref.save("readList", widget.readTopicList!);
            widget.onchanged!(widget.readTopicList);
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => Introduction()));
            setState(() => isLoading = false);
          } else {
            Fluttertoast.showToast(msg: op["error"]);
          }
        },
      );
    } catch (err) {
      Fluttertoast.showToast(msg: 'An error occurred.Please try again.');
    }
  }

  // getContentList() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   GetTopicContentApiProvider topicContent = GetTopicContentApiProvider();
  //   try {
  //     await topicContent.getTopicContentAPI(widget.topicId).then((op) => {
  //           setState(() {
  //             if (op["data"] != null) {
  //               // htmlData = op["data"][0]["content"];

  //             } else {
  //               Fluttertoast.showToast(msg: op["error"]);
  //             }
  //           }),
  //           setState(() {
  //             isLoading = false;
  //           })
  //         });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     Fluttertoast.showToast(msg: 'An error occurred.Please try again.');
  //   }
  // }

  UserDetails? user;
  UserDetails userDetails = UserDetails();
  bool alreadyRead = false;
  Future<void> getInitialValue() async {
    setState(() {
      isLoading = true;
    });
    SharedPref sharedPref = SharedPref();
    user = UserDetails.fromJson(await sharedPref.read("user"));
    setState(() {
      userDetails = user!;
      isLoading = false;
    });
    // getContentList();
    for (var read in widget.readTopicList!) {
      if (read["topic_fk"] == widget.topicId) {
        alreadyRead = true;
      }
    }
    alreadyRead ? null : postRead();
  }

  @override
  void initState() {
    getInitialValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBar() {
      return AppBar(
        backgroundColor: themeColor,
        // toolbarHeight: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: const [Icon(Icons.arrow_back_ios)],
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.topicName!,
                maxLines: 2,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(243, 244, 248, 1)),
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: SvgPicture.asset(
                CustomIcons.bookmark,
                // color: Color.fromRGBO(206, 210, 228, 1),
              ))
        ],
      );
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          Navigator.pop(context);
        }
      },

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: themeColor,
                  strokeWidth: 2,
                ),
              )
            : Stack(children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                        child:  Html(
                          data: widget.htmlContent,
                          extensions: [
                            TagExtension(
                              tagsToExtend: {'tex'},
                              builder: (context) {
                                final texString = context.element?.innerHtml ?? '';
                                final textStyle = context.style?.generateTextStyle() ?? const TextStyle();

                                return Math.tex(
                                  texString,
                                  mathStyle: MathStyle.display,
                                  textStyle: textStyle,
                                  onErrorFallback: (FlutterMathException e) => Text(e.message),
                                );
                              },
                            ),
                          ],
                          style: {
                            "table": Style(
                              textAlign: TextAlign.center,
                              border: const Border(
                                left: BorderSide(color: Colors.grey),
                                right: BorderSide(color: Colors.grey),
                                bottom: BorderSide(color: Colors.grey),
                                top: BorderSide(color: Colors.grey),
                              ),
                            ),
                            "tr": Style(
                              border: const Border(
                                bottom: BorderSide(color: Colors.grey),
                              ),
                            ),
                            "th": Style(
                              padding: HtmlPaddings.all(6),
                            ),
                            "td": Style(
                              padding: HtmlPaddings.all(6),
                              alignment: Alignment.topLeft,
                            ),
                          },
                        )

                      )
                    ],
                  ),
                ),
              ]),
        bottomNavigationBar: BottomAppBar(
            child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, dashboardRoute);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(CustomIcons.home),
                          const SizedBox(
                            height: 2,
                          ),
                          const Text(
                            'Home',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(34, 34, 34, 1)),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, formulaSheetRoute);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(CustomIcons.formula),
                          const SizedBox(
                            height: 2,
                          ),
                          const Text(
                            'Formula',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(34, 34, 34, 1)),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        quizIntro();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(CustomIcons.quiz),
                          const SizedBox(
                            height: 2,
                          ),
                          const Text(
                            'Quiz',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(34, 34, 34, 1)),
                          )
                        ],
                      ),
                    )
                  ],
                ))),
      ),
    );
  }

  Future<void> quizIntro() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                      radius: 13,
                      backgroundColor: themeColor,
                      child: CircleAvatar(
                          radius: 11,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.close,
                            size: 17,
                            color: themeColor,
                          ))),
                )
              ],
            ),
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return PopScope(
                  canPop: true,
                  onPopInvokedWithResult: (bool didPop, Object? result) async {
                    if (!didPop) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: SizedBox(
                    width: 450,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Welcome to the ${widget.moduleName} Quiz!',
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 22,
                                color: Color.fromRGBO(34, 34, 34, 1)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              '''This quiz has 10 questions and will test your knowledge on all of the lessons in this chapter. As you go through the quiz, at each question after question 1, your score will be displayed at the bottom right-hand side of the screen. Read the solutions after each question if you did not understand the question and keep track of the questions/topics you are not understanding. If you get less than 10 questions correct and/or you get all of the questions wrong in a particular topic at the end of the quiz, | would advise you to go through the lessons again. When you are ready, click the Start Quiz button. Good Luck!''',
                              style: TextStyle(
                                  height: 2,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: paragraphFont),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              children: [Expanded(child: startQuizButton())],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
  @override
  void dispose() {
    //...
    super.dispose();
    //...
  }

  SizedBox startQuizButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(9))),
            backgroundColor: activeColorGreen,
            elevation: 0),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Quiz(
                      currentQNo: 0,
                      score: 0,
                      quizAnswers: [],
                      quizList: [],
                      quizAttempt: widget.quizattempt,
                      moduleId: widget.moduleId,
                      userId: userDetails.id,
                      moduleName: widget.moduleName,
                      moduleDescription: widget.moduleDescription)));
        },
        child: const Text(
          'Start Quiz',
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}
