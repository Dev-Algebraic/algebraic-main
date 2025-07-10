import 'package:algebraic/models/topics_list_model.dart';
import 'package:algebraic/routes/route_constants.dart';
import 'package:algebraic/utils/constants.dart';
import 'package:algebraic/view/about_sub_module.dart';
import 'package:algebraic/view/about_sub_module_pdf.dart';
import 'package:algebraic/view/components/drawer.dart';
import 'package:algebraic/view/dashboard.dart';
import 'package:algebraic/view/quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user.dart';
import '../services/api_provider.dart';
import '../utils/sharedpref.dart';

class AboutModule extends StatefulWidget {
  final int? moduleId;
  final String? moduleName;
  final String? moduleDescription;
  final int? quizattempt;
  const AboutModule(
      {Key? key,
      this.moduleId,
      this.moduleName,
      this.moduleDescription,
      this.quizattempt})
      : super(key: key);

  @override
  State<AboutModule> createState() => _AboutModuleState();
}

class _AboutModuleState extends State<AboutModule> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // List algebra = [
  //   'Basics of Polynomials',
  //   'Adding & Substractions of polynomials',
  //   'Multiplying polynomial using distributive property',
  //   'Multiplying polynomial using Foil',
  //   'Dividing polynomial using Monomial'
  // ];

  bool isloading = true;
  UserDetails? user;
  UserDetails userDetails = UserDetails();
  List<TopicsList> topicsList = [];
  List readTopicsList = [];
  Future<void> getInitialValue() async {
    setState(() {
      isloading = true;
    });
    SharedPref sharedPref = SharedPref();
    user = UserDetails.fromJson(await sharedPref.read("user"));
    readTopicsList = await sharedPref.read("readList") ?? [];
    setState(() {
      userDetails = user!;
    });
  }

  Future<void> getTopicsList() async {
    setState(() {
      isloading = true;
    });
    GetTopicsApiProvider topicsListApi = GetTopicsApiProvider();
    try {
      await topicsListApi.getTopicsAPI(widget.moduleId).then((op) => {
            setState(() {
              if (op["data"] != null) {
                final List resItems = op["data"];
                topicsList = resItems
                    .map((resRaw) => TopicsList.fromJson(resRaw))
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

  AppBar appBar(String moduleName) {
    return AppBar(
      elevation: 0,
      backgroundColor: themeColor,
      // toolbarHeight: 64,
      leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Row(
              children: [Icon(Icons.arrow_back_ios, color: Colors.white,)],
            ),
          ),

      ),
      title: Padding(
        padding: EdgeInsets.only(left: 4.0),
        child: Text(
          moduleName,
          style: TextStyle(
              fontSize: 15.75,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
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
              style: const TextStyle(
                  fontSize: 13.85,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  // Module description
  bool _isExpanded = false;

  ClipRRect topHeader(theme) {
    return ClipRRect(
      borderRadius: _isExpanded ? BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40)
      ) : BorderRadius.all(Radius.zero),

      child: Container(
        color: theme.colorScheme.secondaryContainer,

        child: ExpansionTile(
          shape: Border(),
          backgroundColor: theme.colorScheme.secondaryContainer,

          onExpansionChanged: (bool expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          
          title: Container(
            color: theme.colorScheme.secondaryContainer,

            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 8, left: 16),

              child: Text(
                widget.moduleName!,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(34, 34, 34, 1)),
              ),
            ),
          ),

          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
              ),

              child: Padding(
                padding: EdgeInsets.only(top: 0.0, left: 32, right: 32, bottom: 24),
                child: Column(
                  children: [
                    Text(
                      widget.moduleDescription ?? "",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.secondary),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  @override
  void initState() {
    getInitialValue();
    getTopicsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
        return true;
      },
      child: isloading
          ? Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(
                  color: themeColor,
                  strokeWidth: 2,
                ),
              ),
            )
          : Scaffold(
              backgroundColor: Colors.white,
              key: _scaffoldKey,
              appBar: appBar(widget.moduleName!),
              body: DefaultTabController(
                initialIndex: 0,
                length: 2,

                child: Scaffold(
                  
                  // Tab bar
                  appBar: AppBar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    title: null,
                    automaticallyImplyLeading: false,
                    toolbarHeight: 0,

                    bottom: TabBar(
                      dividerColor: Colors.transparent,
                      
                      labelStyle: TextStyle(
                        fontSize: 15.75,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.secondary,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 15.75,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.secondary,
                      ),

                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 1.2, color: theme.colorScheme.tertiary),
                        insets: EdgeInsets.symmetric(horizontal: 90)
                      ),

                      tabs: <Widget>[
                        Tab(text: 'Learn'),
                        Tab(text: 'Unit Quiz')
                      ],
                    ),
                  ),

                  // Page body
                  body: TabBarView(
                    children: <Widget>[
                      learn(theme),
                      unitQuiz(theme),
                    ]
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> quizIntro(String? moduleName) async {
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
                return WillPopScope(
                  onWillPop: () async {
                    Navigator.of(context).pop();
                    return true;
                  },
                  child: SizedBox(
                    width: 450,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Welcome to the $moduleName Quiz!',
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
                              children: [Expanded(child: startQuizButton(context))],
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

  SizedBox startQuizButton(BuildContext dialogContext) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(9))),
            backgroundColor: activeColorGreen,
            elevation: 0),
        onPressed: () {
          Navigator.of(dialogContext).pop();
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

  // Module sections
  getRead(readtopics) async {
    readTopicsList = readtopics;
    setState(() {});
  }

  SingleChildScrollView learn(theme) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: topHeader(theme)),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 27.5, 4),
            
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Lessons',
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(34, 34, 34, 1)),
              ),
            )
          ),

          Padding(
            padding: const EdgeInsets.only(right: 32, left: 32, bottom: 16),
            
            child: Align(
              alignment: Alignment.centerLeft,
              child:Text(
                '''Once you have finished reviewing all of the lessons, try the ${widget.moduleName!} quiz to see how much you know!''',
                textAlign: TextAlign.left,
                style: TextStyle(
                    height: 1.5,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: paragraphFont),
              ),
            )
          ),

          topicsList.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(
                      right: 27.5, left: 20.5, top: 30, bottom: 8),
                  child: Container(
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 1))
                        ],
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.all(Radius.circular(9))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 22.67,
                          bottom: 22.67,
                          left: 19,
                          right: 33),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 19.0),
                              child: Text(
                                'No topics are available in this Module',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: paragraphFont),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )

              // Padding(
              //     padding: const EdgeInsets.only(top: 50.0),
              //     child: Text(
              //       'No topics are available in this Module',
              //       style: TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.w400,
              //           color: themeColor),
              //     ),
              //   )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: topicsList.length,
                  itemBuilder: (context, index) {
                    bool read = false;
                    if (readTopicsList.isNotEmpty) {
                      for (var topics in readTopicsList) {
                        if (topics["topic_fk"] ==
                            topicsList[index].orderNo) {
                          read = true;
                        }
                      }
                    }
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 27.5,
                            left: 20.5,
                            top: 8,
                            bottom: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => topicsList[index]
                                                    .templateUrl ==
                                                null ||
                                            topicsList[index].templateUrl ==
                                                ""
                                        ? AboutSubmodule(
                                            quizattempt:
                                                widget.quizattempt,
                                            moduleId: widget.moduleId,
                                            moduleName:
                                                widget.moduleName,
                                            moduleDescription: widget
                                                .moduleDescription,
                                            htmlContent: topicsList[index]
                                                .content,
                                            onchanged: (readtopics) =>
                                                getRead(readtopics),
                                            topicId: topicsList[index]
                                                .orderNo,
                                            topicName: topicsList[index]
                                                .name,
                                            readTopicList:
                                                readTopicsList)
                                        : AboutSubmodulePdf(
                                            quizattempt: widget.quizattempt,
                                            moduleId: widget.moduleId,
                                            moduleName: widget.moduleName,
                                            moduleDescription: widget.moduleDescription,
                                            htmlContent: topicsList[index].content,
                                            onchanged: (readtopics) => getRead(readtopics),
                                            topicId: topicsList[index].orderNo,
                                            topicName: topicsList[index].name,
                                            pdfFile: topicsList[index].templateUrl,
                                            readTopicList: readTopicsList)));
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(
                                          0, 0, 0, 0.25),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(0, 1))
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(9))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 22.67,
                                  bottom: 22.67,
                                  left: 19,
                                  right: 33),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset(
                                      CustomIcons.fileIcon),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 19.0),
                                      child: Text(
                                        topicsList[index].name!,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight.w400,
                                            color: paragraphFont),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0),
                                    child: SvgPicture.asset(
                                        CustomIcons.bookmark,
                                        color: !read
                                            ? const Color.fromRGBO(
                                                206, 210, 228, 1)
                                            : null),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
        ],
      )
    );
  }

  SingleChildScrollView unitQuiz(theme) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          // Title
          Align(
            alignment: Alignment.centerLeft,

            child: Padding(
              padding: EdgeInsetsGeometry.only(left: 32, top: 16),

              child: Text(
                "Best Score",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,

            child: Padding(
              padding: EdgeInsetsGeometry.only(left: 32, top: 0),

              child: Text(
                "3 attempts",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
          ),

          // Percentage indicator

          // Quiz button
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsetsGeometry.only(left: 32, right: 32),

                  child: InkWell(
                    onTap: () => {
                      quizIntro(widget.moduleName)
                    },
                    
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,

                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Text(
                        "Take Quiz",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}
/*
InkWell(
            onTap: () => {
              quizIntro(widget.moduleName)
            },

            child: Hero(
              tag: 'thumbnail',
              child: Ink.image(
                image: AssetImage('assets/Gospel E-Booklet Thumbnail.png'),
                fit: BoxFit.contain
              ),
            ),
          ),*/