import 'package:algebraic/services/api_provider.dart';
import 'package:algebraic/view/score.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_math/flutter_html_math.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:algebraic/app_config.dart';
import 'package:skeletons/skeletons.dart';
import '../models/quiz_model.dart';
import '../utils/constants.dart';
import 'components/textformfield_widget.dart';

class Quiz extends StatefulWidget {
  final int? moduleId;
  final int? userId;
  final String? moduleName;
  final String? moduleDescription;
  final int? quizAttempt;
  final int? currentQNo;
  final List<QuizList> quizList;
  final List quizAnswers;
  final int score;

  const Quiz(
      {Key? key,
      this.moduleId,
      this.userId,
      this.moduleName,
      this.moduleDescription,
      this.quizAttempt,
      this.currentQNo,
      required this.quizList,
      required this.quizAnswers,
      required this.score})
      : super(key: key);

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  var selectedValue = -1;
  String? quizAnswerOption;
  String? answerText1;
  String? answerText2;
  String? answerText3;
  String? current;
  TextEditingController answerText1Controller = TextEditingController();
  TextEditingController answerText2Controller = TextEditingController();
  TextEditingController answerText3Controller = TextEditingController();

  int score = 0;
  int currentQuestion = 0;
  bool isLoading = true;
  bool texLoader = true;
  List<QuizList> quizList = [];
  List quizAnswers = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> getQuiz() async {
    setState(() {
      isLoading = true;
    });
    GetQuizApiProvider topicContent = GetQuizApiProvider();
    try {
      await topicContent.getQuizAPI(widget.moduleId).then((op) => {
            setState(() {
              if (op["data"] != null) {
                final List resItems = op["data"];
                quizList = resItems
                    .map((resRaw) => QuizList.fromJson(resRaw))
                    .toList();
                generateOptions();
                quizAnswers = List.filled(quizList.length, 0, growable: false);
                if (quizList.isNotEmpty &&
                    quizList[currentQuestion].description != null) {
                  quizList[currentQuestion].description =
                      quizList[currentQuestion]
                          .description!
                          .replaceAll("<", "\\lt");
                  quizList[currentQuestion].description =
                      quizList[currentQuestion]
                          .description!
                          .replaceAll(">", "\\gt");
                  quizList[currentQuestion].description =
                      quizList[currentQuestion]
                          .description!
                          .replaceAll("\\\\", "</tex></p><p><tex>");
                }
              } else {
                Fluttertoast.showToast(msg: op["error"]);
              }
            }),
            setState(() {
              isLoading = false;
            }),
            if (quizList[currentQuestion].type == "OBJECTIVE")
              {
                Future.delayed(const Duration(milliseconds: 00), () {
                  setState(() {
                    texLoader = false;
                  });
                }),
              }
            else
              {
                Future.delayed(const Duration(milliseconds: 00), () {
                  setState(() {
                    texLoader = false;
                  });
                }),
              }
          });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  void generateOptions() {
    for (var i = 0; i < quizList.length; i++) {
      if (quizList[i].type == "OBJECTIVE") {
        quizList[i].options = [];
        if (quizList[i].option1 != null && quizList[i].option1 != "") {
          quizList[i].options!.add(quizList[i].option1!);
        }
        if (quizList[i].option2 != null && quizList[i].option2 != "") {
          quizList[i].options!.add(quizList[i].option2!);
        }
        if (quizList[i].option3 != null && quizList[i].option3 != "") {
          quizList[i].options!.add(quizList[i].option3!);
        }
        if (quizList[i].option4 != null && quizList[i].option4 != "") {
          quizList[i].options!.add(quizList[i].option4!);
        }
        if (quizList[i].option5 != null && quizList[i].option5 != "") {
          quizList[i].options!.add(quizList[i].option5!);
        }
      }
    }
  }

  Future<void> addScore() async {
    setState(() => isLoading = true);
    PostScoreProvider scoreApi = PostScoreProvider();

    Map payLoad = {
      "userId": widget.userId,
      "moduleId": widget.moduleId,
      "score": score,
      "totalQuestion": quizList.length,
      "createdBy": null
    };
    try {
      await scoreApi.postScoreAPI(payLoad).then(
        (op) async {
          if (op["error"] == null && op["data"].isNotEmpty) {
            setState(() {});
          } else {
            Fluttertoast.showToast(msg: op["error"]);
          }
        },
      );
    } catch (err) {
      Fluttertoast.showToast(msg: "An error occured please try again later");
    }
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: themeColor,

      // toolbarHeight: 64,
      leading: InkWell(
        onTap: () {
          endQuiz();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Row(
            children: [const Icon(Icons.arrow_back_ios, color: Colors.white,)],
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Quiz',
            style: TextStyle(
                fontSize: 15.75,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          Container(
            decoration: BoxDecoration(
                color: const Color.fromRGBO(47, 60, 101, 1),
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Attempt : ${(widget.quizAttempt ?? 0) + 1}',
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  const VerticalDivider(),
                  Text(
                    'Score : ' +
                        score.toString() +
                        " / " +
                        quizList.length.toString(),
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      centerTitle: false,
    );
  }

  @override
  void initState() {
    if (widget.currentQNo == 0) {
      getQuiz();
    } else {
      currentQuestion = widget.currentQNo!;
      quizAnswers = widget.quizAnswers;
      quizList = widget.quizList;
      score = widget.score;
      setState(() {
        isLoading = false;
        texLoader = false;
        if (quizList[currentQuestion].type != "OBJECTIVE") {
          texLoader = false;
        } else {
          if (quizList[currentQuestion].description == null ||
              quizList[currentQuestion].description == "") {
            texLoader = false;
          }
        }
      });
    }
    if (quizList.isNotEmpty && quizList[currentQuestion].description != null) {
      quizList[currentQuestion].description =
          quizList[currentQuestion].description!.replaceAll("<", "\\lt");
      quizList[currentQuestion].description =
          quizList[currentQuestion].description!.replaceAll(">", "\\gt");
      quizList[currentQuestion].description = quizList[currentQuestion]
          .description!
          .replaceAll("\\\\", "</tex></p><p><tex>");
    }

    super.initState();
  }

  void nextQuestion() {
    setState(() {
      isLoading = true;
      texLoader = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
        if (quizList[currentQuestion].type != "OBJECTIVE") {
          texLoader = false;
        } else {
          if (quizList[currentQuestion].description == null ||
              quizList[currentQuestion].description == "") {
            texLoader = false;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    //...
    super.dispose();
    //...
  }

  double? width;

  BuildContext? parentContext;

  @override
  Widget build(BuildContext context) {
    // final longEq = Math.tex(quizList[currentQuestion].description!,textStyle: TextStyle(fontSize: 21),);
    // final breakResult = longEq.texBreak();
    // final widget = Wrap(runSpacing: 10,spacing: 5,crossAxisAlignment: WrapCrossAlignment.center,
    //   children: breakResult.parts,
    // );
    width = MediaQuery.of(context).size.width;
    parentContext = context;
    return WillPopScope(
      onWillPop: () async {
        endQuiz();
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
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
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 68.0, right: 70),
                            child: Row(
                              children: [
                                for (var i = 0; i < quizList.length; i++)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 17.0, right: 6),
                                      child: Container(
                                        height: 4,
                                        decoration: BoxDecoration(
                                            color: currentQuestion >= i
                                                ? (currentQuestion == i
                                                    ? const Color.fromRGBO(
                                                        62, 81, 141, 1)
                                                    : (quizAnswers[i] == true
                                                        ? activeColorGreen
                                                        : const Color.fromRGBO(
                                                            227, 52, 47, 1)))
                                                : const Color.fromRGBO(
                                                    219, 224, 239, 1),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(2))),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 28.0, left: 28.0, right: 21),
                            child: Text(
                              quizList[currentQuestion].questionHeader!,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(34, 34, 34, 1)),
                            ),
                          ),
                          quizList[currentQuestion].question != null &&
                                  quizList[currentQuestion].question != ""
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0,
                                      left: 15.0,
                                      right: 15,
                                      bottom: 15),
                                  child: Html(
                                    data: "<p>${currentQuestion + 1}. ${quizList[currentQuestion].question!}</p>",
                                    // (currentQuestion + 1).toString() +
                                    //     ". " +
                                    //     quizList[currentQuestion].question!,
                                    style: {
                                      "body": Style(
                                          fontSize: FontSize.larger,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromRGBO(
                                              34, 34, 34, 1)),
                                    },
                                    // style: const TextStyle(
                                    //     fontSize: 17,
                                    //     fontWeight: FontWeight.w600,
                                    //     color: Color.fromRGBO(34, 34, 34, 1)),
                                  ),
                                )
                              : Container(),
                          // widget,
                          quizList[currentQuestion].description == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12, bottom: 15),
                                  child:
                                      // Html(
                                      //   data: "<p><tex>" +
                                      //       quizList[currentQuestion].description! +
                                      //       "</tex></p>",
                                      //   customRenders: {
                                      //     texMatcher(): CustomRender.widget(
                                      //         widget: (context, buildChildren) =>
                                      //             Math.tex(
                                      //               context.tree.element?.innerHtml ?? '',
                                      //               mathStyle: MathStyle.display,
                                      //               textStyle:
                                      //                   context.style.generateTextStyle(),
                                      //               onErrorFallback:
                                      //                   (FlutterMathException e) {
                                      //                 //optionally try and correct the Tex string here
                                      //                 return Text(e.message);
                                      //               },
                                      //             )),
                                      //   },
                                      //   tagsList: Html.tags..add('tex'),
                                      // )

                                      Html(
                                        data: "<p><tex>${quizList[currentQuestion].description!}</tex></p>",
                                        style: {
                                          "p": Style(
                                            fontSize: width! > 768 ? FontSize.larger : FontSize.xLarge,
                                          ),
                                        },
                                        extensions: [
                                          TagExtension(
                                            tagsToExtend: {'tex'},
                                            builder: (context) {
                                              final texString = context.element?.innerHtml ?? '';
                                              final textStyle = context.style?.generateTextStyle() ?? const TextStyle();

                                              return Wrap(
                                                runSpacing: 8,
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                children: Math.tex(
                                                  texString,
                                                  mathStyle: MathStyle.display,
                                                  textStyle: textStyle,
                                                  onErrorFallback: (FlutterMathException e) => Text(e.message),
                                                ).texBreak().parts,
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                  //     TeXView(
                                  //   renderingEngine:
                                  //       const TeXViewRenderingEngine.katex(),
                                  //   onRenderFinished: (v) {
                                  //     setState(() {
                                  //       texLoader = false;
                                  //     });
                                  //   },
                                  //   child: TeXViewDocument(
                                  //     "<p>\\(" +
                                  //         quizList[currentQuestion]
                                  //             .description! +
                                  //         "\\)</p>",
                                  //     // r"""<p>"""+ quizList[currentQuestion].description!+"""<\p>""",
                                  //   ),
                                  //   // style: TeXViewStyle(
                                  //   //     // backgroundColor: Colors.white,
                                  //   //     fontStyle: TeXViewFontStyle(
                                  //   //       fontSize: 22,
                                  //   //       fontWeight:
                                  //   //           TeXViewFontWeight.w400,
                                  //   //     ),
                                  //   //     contentColor: paragraphFont)
                                  // )

                                  // Text(
                                  //   quizList[currentQuestion].description!,
                                  //   style: TextStyle(
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.w400,
                                  //       color: Color.fromRGBO(34, 34, 34, 1)),
                                  // ),
                                ),

                          quizList[currentQuestion].questionImg1 == null ||
                                  quizList[currentQuestion].questionImg1 == ""
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 59, left: 28.0, right: 21),
                                  child: Image.network(URLIdentifier.BASE_URL +
                                      quizList[currentQuestion].questionImg1!),
                                ),
                          quizList[currentQuestion].questionImg2 == null ||
                                  quizList[currentQuestion].questionImg2 == ""
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 59, left: 28.0, right: 21),
                                  child: Image.network(URLIdentifier.BASE_URL +
                                      quizList[currentQuestion].questionImg2!),
                                ),
                          quizList[currentQuestion].questionImg3 == null ||
                                  quizList[currentQuestion].questionImg3 == ""
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 59, left: 28.0, right: 21),
                                  child: Image.network(URLIdentifier.BASE_URL +
                                      quizList[currentQuestion].questionImg3!),
                                ),
                          // quizJsonModule["questions"][currentQuestion]["imageURL"] ==
                          //         null
                          //     ? Padding(
                          //         padding: const EdgeInsets.only(
                          //             bottom: 59, left: 28.0, right: 21),
                          //         child: Image.network(
                          //             'https://i.stack.imgur.com/OGTyV.png'),
                          //       )
                          //     : Container(),
                          Container(
                            //height: double.maxFini,
                            alignment: Alignment.bottomCenter,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.25),
                                      offset: Offset(0, -1))
                                ],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25))),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 21.0, left: 15.0, right: 15),
                                child: quizList[currentQuestion].type ==
                                        "OBJECTIVE"
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Answers',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(
                                                    34, 34, 34, 1)),
                                          ),
                                          Text(
                                            'Choose the correct answer given below',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                                color: paragraphFont),
                                          ),
                                          // TeXView(
                                          //   onRenderFinished: (v) {
                                          //     setState(() {
                                          //       texLoader = false;
                                          //     });
                                          //   },
                                          //   renderingEngine:
                                          //       const TeXViewRenderingEngine
                                          //           .katex(),
                                          //   child: TeXViewColumn(children: [
                                          //     TeXViewGroup(
                                          //         children:
                                          //             quizList[currentQuestion]
                                          //                 .options!
                                          //                 .map((String option) {
                                          //           return TeXViewGroupItem(
                                          //               rippleEffect: false,
                                          //               id: option,
                                          //               child: TeXViewDocument(
                                          //                   (quizAnswers[currentQuestion] !=
                                          //                                   0 &&
                                          //                               current ==
                                          //                                   option
                                          //                           ? "<svg width='18' height='23.5' viewBox='0 0 23 30' fill='none' xmlns='http://www.w3.org/2000/svg'> <rect x='1' y='8' width='21' height='21' rx='10.5' fill='white'/> <rect x='1' y='8' width='21' height='21' rx='10.5' stroke='#3E518D' stroke-width='2'/><rect x='5.5' y='12.5' width='12' height='12' rx='6' fill='#3E518D'/> <rect x='5.5' y='12.5' width='12' height='12' rx='6' stroke='#3E518D'/></svg><a>\\(\\ \\ \\ "
                                          //                           : "<svg width='18' height='23.5' viewBox='0 0 23 30' fill='none' xmlns='http://www.w3.org/2000/svg'> <rect x='1' y='8' width='21' height='21' rx='10.5' fill='white'/> <rect x='1' y='8' width='21' height='21' rx='10.5' stroke='#3E518D' stroke-width='2'/></svg><a>\\(\\ \\ \\ ") +
                                          //                       option +
                                          //                       "\\)</a>",
                                          //                   style: const TeXViewStyle(
                                          //                       padding: TeXViewPadding
                                          //                           .only(
                                          //                               top: 10,
                                          //                               bottom:
                                          //                                   10))));
                                          //         }).toList(),
                                          //         selectedItemStyle:
                                          //             const TeXViewStyle(
                                          //                 padding:
                                          //                     TeXViewPadding
                                          //                         .only(
                                          //                             left: 8,
                                          //                             right: 8),
                                          //                 // backgroundColor:
                                          //                 //     Colors.grey[200],
                                          //                 // backgroundColor:
                                          //                 //    const Color.fromRGBO(62, 81, 141, 0.1),
                                          //                 //     contentColor: Colors.white,
                                          //                 // borderRadius:
                                          //                 //     TeXViewBorderRadius.all(
                                          //                 //         6),
                                          //                 // border: TeXViewBorder.all(
                                          //                 //     TeXViewBorderDecoration(
                                          //                 //         borderWidth:
                                          //                 //             3,
                                          //                 //         borderColor:activeColorGreen)),
                                          //                 margin: TeXViewMargin
                                          //                     .only(
                                          //                         top: 3,
                                          //                         bottom: 3)),
                                          //         normalItemStyle:
                                          //             const TeXViewStyle(
                                          //                 padding:
                                          //                     TeXViewPadding
                                          //                         .only(
                                          //                             left: 8,
                                          //                             right: 8),
                                          //                 // borderRadius:
                                          //                 //     TeXViewBorderRadius
                                          //                 //         .all(6),
                                          //                 // border: TeXViewBorder.all(TeXViewBorderDecoration(borderWidth: 1, borderColor: Colors.grey[400])),
                                          //                 // backgroundColor:
                                          //                 //     Colors.grey[100],
                                          //                 margin: TeXViewMargin
                                          //                     .only(
                                          //                         top: 3,
                                          //                         bottom: 3)),
                                          //         onTap: (id) {
                                          //           current = id;
                                          //           id ==
                                          //                   quizList[
                                          //                           currentQuestion]
                                          //                       .objectiveAnswer
                                          //               ? quizAnswers[
                                          //                       currentQuestion] =
                                          //                   true
                                          //               : quizAnswers[
                                          //                       currentQuestion] =
                                          //                   false;
                                          //           setState(() {});
                                          //         })
                                          //   ]),
                                          //   style: const TeXViewStyle(
                                          //     margin:
                                          //         TeXViewMargin.only(top: 5),
                                          //     padding: TeXViewPadding.all(0),
                                          //     backgroundColor: Colors.white,
                                          //   ),
                                          // ),
                                          quizList[currentQuestion].option1 ==
                                                      null ||
                                                  quizList[currentQuestion]
                                                          .option1 ==
                                                      ""
                                              ? Container()
                                              : quizOptions(
                                                  quizList[currentQuestion]
                                                      .option1,
                                                  0),
                                          quizList[currentQuestion].option2 ==
                                                      null ||
                                                  quizList[currentQuestion]
                                                          .option2 ==
                                                      ""
                                              ? Container()
                                              : quizOptions(
                                                  quizList[currentQuestion]
                                                      .option2,
                                                  1),
                                          quizList[currentQuestion].option3 ==
                                                      null ||
                                                  quizList[currentQuestion]
                                                          .option3 ==
                                                      ""
                                              ? Container()
                                              : quizOptions(
                                                  quizList[currentQuestion]
                                                      .option3,
                                                  2),
                                          quizList[currentQuestion].option4 ==
                                                      null ||
                                                  quizList[currentQuestion]
                                                          .option4 ==
                                                      ""
                                              ? Container()
                                              : quizOptions(
                                                  quizList[currentQuestion]
                                                      .option4,
                                                  3),
                                          quizList[currentQuestion].option5 ==
                                                      null ||
                                                  quizList[currentQuestion]
                                                          .option5 ==
                                                      ""
                                              ? Container()
                                              : quizOptions(
                                                  quizList[currentQuestion]
                                                      .option5,
                                                  4)
                                        ],
                                      )
                                    : Form(
                                        key: _formKey,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: Column(children: [
                                            quizList[currentQuestion]
                                                            .textAnswer1 ==
                                                        null ||
                                                    quizList[currentQuestion]
                                                            .textAnswer1 ==
                                                        ""
                                                ? Container()
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      quizList[currentQuestion]
                                                                      .textLabel1 !=
                                                                  null &&
                                                              quizList[currentQuestion]
                                                                      .textLabel1 !=
                                                                  ""
                                                          ? Text(
                                                              quizList[currentQuestion]
                                                                      .textLabel1 ??
                                                                  "",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  color:
                                                                      paragraphFont),
                                                            )
                                                          : Container(),
                                                      Expanded(
                                                        child: TextformWidget(
                                                          maxlines: 1,
                                                          controller:
                                                              answerText1Controller,
                                                          saved: (val) {
                                                            answerText1 = val;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            quizList[currentQuestion]
                                                            .textAnswer2 ==
                                                        null ||
                                                    quizList[currentQuestion]
                                                            .textAnswer2 ==
                                                        ""
                                                ? Container()
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      quizList[currentQuestion]
                                                                      .textLabel2 !=
                                                                  null ||
                                                              quizList[currentQuestion]
                                                                      .textLabel2 !=
                                                                  ""
                                                          ? Text(
                                                              quizList[currentQuestion]
                                                                      .textLabel2 ??
                                                                  "",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  color:
                                                                      paragraphFont),
                                                            )
                                                          : Container(),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 0),
                                                          child: TextformWidget(
                                                            maxlines: 1,
                                                            controller:
                                                                answerText2Controller,
                                                            saved: (val) {
                                                              answerText2 = val;
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            quizList[currentQuestion]
                                                            .textAnswer3 ==
                                                        null ||
                                                    quizList[currentQuestion]
                                                            .textAnswer3 ==
                                                        ""
                                                ? Container()
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      quizList[currentQuestion]
                                                                      .textLabel3 !=
                                                                  null ||
                                                              quizList[currentQuestion]
                                                                      .textLabel3 !=
                                                                  ""
                                                          ? Text(
                                                              quizList[currentQuestion]
                                                                      .textLabel3 ??
                                                                  "",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  color:
                                                                      paragraphFont),
                                                            )
                                                          : Container(),
                                                      Expanded(
                                                        child: TextformWidget(
                                                          maxlines: 1,
                                                          controller:
                                                              answerText3Controller,
                                                          saved: (val) {
                                                            answerText3 = val;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ]),
                                        ),
                                      )),
                          ),
                        ],
                      ),
                    ),
                    texLoader ? skelton() : Container()
                  ],
                ),
          bottomNavigationBar: !texLoader
              ? BottomAppBar(
                  child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: activeColorGreen, elevation: 0),
                    onPressed: () {
                      if (quizList[currentQuestion].type == "TEXT") {
                        _formKey.currentState!.save();
                        if (answerText1 != "" && answerText1 != null) {
                          answerText1 = answerText1!.toLowerCase();
                        }
                        if (answerText2 != "" && answerText2 != null) {
                          answerText2 = answerText2!.toLowerCase();
                        }
                        if (answerText3 != "" && answerText3 != null) {
                          answerText3 = answerText3!.toLowerCase();
                        }
                        if (quizList[currentQuestion].textAnswer1 == "" ||
                            quizList[currentQuestion].textAnswer1 == null) {
                          quizList[currentQuestion].textAnswer1 = null;
                        } else {
                          quizList[currentQuestion].textAnswer1 =
                              quizList[currentQuestion]
                                  .textAnswer1!
                                  .toLowerCase();
                        }
                        if (quizList[currentQuestion].textAnswer2 == "" ||
                            quizList[currentQuestion].textAnswer2 == null) {
                          quizList[currentQuestion].textAnswer2 = null;
                        } else {
                          quizList[currentQuestion].textAnswer2 =
                              quizList[currentQuestion]
                                  .textAnswer2!
                                  .toLowerCase();
                        }
                        if (quizList[currentQuestion].textAnswer3 == "" ||
                            quizList[currentQuestion].textAnswer3 == null) {
                          quizList[currentQuestion].textAnswer3 = null;
                        } else {
                          quizList[currentQuestion].textAnswer3 =
                              quizList[currentQuestion]
                                  .textAnswer3!
                                  .toLowerCase();
                        }

                        (answerText1 == quizList[currentQuestion].textAnswer1 &&
                                answerText2 ==
                                    quizList[currentQuestion].textAnswer2 &&
                                answerText3 ==
                                    quizList[currentQuestion].textAnswer3)
                            ? quizAnswers[currentQuestion] = true
                            : quizAnswers[currentQuestion] = false;
                      }
                      quizAnswers[currentQuestion] == 0
                          ? null
                          : onSubmit(quizAnswers);
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  ),
                ))
              : null,
        ),
      ),
    );
  }

  Widget skelton() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SkeletonParagraph(
              style: SkeletonParagraphStyle(
                  lines: 2,
                  spacing: 6,
                  lineStyle: SkeletonLineStyle(
                    randomLength: true,
                    height: 18,
                    borderRadius: BorderRadius.circular(8),
                    minLength: MediaQuery.of(context).size.width / 2.2,
                    maxLength: MediaQuery.of(context).size.width / 1.5,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SkeletonParagraph(
              style: SkeletonParagraphStyle(
                  lines: 2,
                  spacing: 6,
                  lineStyle: SkeletonLineStyle(
                    randomLength: true,
                    height: 14,
                    borderRadius: BorderRadius.circular(8),
                    minLength: MediaQuery.of(context).size.width / 1.2,
                    maxLength: MediaQuery.of(context).size.width / 1,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 12),
            child: SkeletonAvatar(
              style: SkeletonAvatarStyle(
                  shape: BoxShape.rectangle,
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 45),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28),
            child: SkeletonParagraph(
              style: SkeletonParagraphStyle(
                  lines: 1,
                  spacing: 6,
                  lineStyle: SkeletonLineStyle(
                    randomLength: true,
                    height: 20,
                    borderRadius: BorderRadius.circular(8),
                    minLength: MediaQuery.of(context).size.width / 4.1,
                    maxLength: MediaQuery.of(context).size.width / 4,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: SkeletonParagraph(
              style: SkeletonParagraphStyle(
                  lines: 1,
                  spacing: 0,
                  lineStyle: SkeletonLineStyle(
                    randomLength: true,
                    height: 14,
                    borderRadius: BorderRadius.circular(8),
                    minLength: MediaQuery.of(context).size.width / 1.2,
                    maxLength: MediaQuery.of(context).size.width / 1,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 22),
            child: Row(
              children: [
                const SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      shape: BoxShape.circle, width: 20, height: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 10),
                  child: SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                        lines: 1,
                        spacing: 0,
                        lineStyle: SkeletonLineStyle(
                          randomLength: true,
                          height: 22,
                          borderRadius: BorderRadius.circular(8),
                          minLength: MediaQuery.of(context).size.width / 2,
                          maxLength: MediaQuery.of(context).size.width / 1.6,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 22),
            child: Row(
              children: [
                const SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      shape: BoxShape.circle, width: 20, height: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 10),
                  child: SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                        lines: 1,
                        spacing: 0,
                        lineStyle: SkeletonLineStyle(
                          randomLength: true,
                          height: 22,
                          borderRadius: BorderRadius.circular(8),
                          minLength: MediaQuery.of(context).size.width / 2,
                          maxLength: MediaQuery.of(context).size.width / 1.6,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 22),
            child: Row(
              children: [
                const SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      shape: BoxShape.circle, width: 20, height: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 10),
                  child: SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                        lines: 1,
                        spacing: 0,
                        lineStyle: SkeletonLineStyle(
                          randomLength: true,
                          height: 22,
                          borderRadius: BorderRadius.circular(8),
                          minLength: MediaQuery.of(context).size.width / 2,
                          maxLength: MediaQuery.of(context).size.width / 1.6,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 22),
            child: Row(
              children: [
                const SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      shape: BoxShape.circle, width: 20, height: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 10),
                  child: SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                        lines: 1,
                        spacing: 0,
                        lineStyle: SkeletonLineStyle(
                          randomLength: true,
                          height: 22,
                          borderRadius: BorderRadius.circular(8),
                          minLength: MediaQuery.of(context).size.width / 2,
                          maxLength: MediaQuery.of(context).size.width / 1.6,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 22),
            child: Row(
              children: [
                const SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      shape: BoxShape.circle, width: 20, height: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 10),
                  child: SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                        lines: 1,
                        spacing: 0,
                        lineStyle: SkeletonLineStyle(
                          randomLength: true,
                          height: 22,
                          borderRadius: BorderRadius.circular(8),
                          minLength: MediaQuery.of(context).size.width / 2,
                          maxLength: MediaQuery.of(context).size.width / 1.6,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onSubmit(quizAnswers) async {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black26,
      context: context,
      builder: (context) {
        return
            WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            elevation: 0,
            backgroundColor: const Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    quizAnswers[currentQuestion]
                        ? const Text(
                            'Correct Answer',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.35,
                                color: Color.fromRGBO(56, 193, 114, 1)),
                          )
                        : const Text(
                            'Wrong Answer',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.35,
                                color: Color.fromRGBO(227, 52, 47, 1)),
                          ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: Text(
                        'Here is how to do the problem!',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            color: Color.fromRGBO(34, 34, 34, 1)),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Html(
                          data: quizList[currentQuestion].answerHint!,
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
                        )
                        ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Expanded(child: continueNext(quizAnswers, context)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> endQuiz() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      width: 1,
                      color: themeColor,
                    )),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'CANCEL',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                ),
                onPressed: () {
                  addScore();
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScoreCard(
                              score: score,
                              noQ: quizList.length,
                              quizAttempt: widget.quizAttempt,
                              moduleId: widget.moduleId,
                              moduleName: widget.moduleName,
                              moduleDescription: widget.moduleDescription)));
                },
                child: const Text(
                  'END QUIZ',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return WillPopScope(
                  onWillPop: () async {
                    return true;
                  },
                  child: SizedBox(
                    width: 450,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Are you sure you want to exit from the quiz",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Your Score will be $score',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: activeColorGreen,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
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

  SizedBox continueNext(quizAnswer, BuildContext displayContext) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(9))),
            backgroundColor: activeColorGreen,
            elevation: 0),
        onPressed: () {
          score = quizAnswer.where((item) => item == true).length;
          if (currentQuestion < quizList.length - 1) {
            // setState(() {
            //   currentQuestion = currentQuestion + 1;
            //   Navigator.pop(context);
            // });
            DefaultCacheManager().emptyCache();
            // DefaultCacheManager().dispose();
            Navigator.of(displayContext).pop();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Quiz(
                          quizAttempt: widget.quizAttempt,
                          moduleId: widget.moduleId,
                          userId: widget.userId,
                          moduleName: widget.moduleName,
                          moduleDescription: widget.moduleDescription,
                          currentQNo: currentQuestion + 1,
                          quizAnswers: quizAnswers,
                          quizList: quizList,
                          score: score,
                        )));
            // nextQuestion();
          } else {
            addScore();
            Navigator.of(displayContext).pop();
                  Navigator.of(parentContext!, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => ScoreCard(
                              score: score,
                              noQ: quizList.length,
                              quizAttempt: widget.quizAttempt,
                              moduleId: widget.moduleId,
                              moduleName: widget.moduleName,
                              moduleDescription: widget.moduleDescription)));
          }
          selectedValue = -1;
          answerText1 = null;
          answerText2 = null;
          answerText3 = null;
          answerText1Controller.text = "";
          answerText2Controller.text = "";
          answerText3Controller.text = "";

          // if (currentQuestion == quizList.length) {
          //   addScore();
          //    Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => AboutModule(
          //               moduleId: widget.moduleId,
          //               moduleName: widget.moduleName,
          //               moduleDescription: widget.moduleDescription)));
          // }
          setState(() {});
        },
        child: Text(
          currentQuestion == quizList.length - 1
              ? 'End Quiz'
              : 'Continue to Next Question',
          style: const TextStyle(
              fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  Widget quizOptions(optionText, int value) {
    var option = optionText.replaceAll("<", "\\lt");
    option = option.replaceAll(">", "\\gt");
    return Padding(
      padding: const EdgeInsets.only(bottom: 2, top: 2),
      child: InkWell(
        onTap: () {
          current = optionText;
          optionText == quizList[currentQuestion].objectiveAnswer
              ? quizAnswers[currentQuestion] = true
              : quizAnswers[currentQuestion] = false;
          setState(() {});
        },
        child: Row(
          children: [
            // Radio(
            //     activeColor: themeColor,
            //     value: value,
            //     groupValue: selectedValue,
            //     onChanged: (int? value) {
            //       setState(() {
            //         selectedValue = value!;
            //         quizAnswerOption = option;
            //         option == quizList[currentQuestion].objectiveAnswer
            //             ? quizAnswers[currentQuestion] = true
            //             : quizAnswers[currentQuestion] = false;
            //       });
            //     }),
            // Expanded(
            //   child: TeXView(
            //       onRenderFinished: (v) {
            //         setState(() {
            //           texLoader = false;
            //         });
            //       },
            //       // renderingEngine: const TeXViewRenderingEngine.katex(),
            //       child: TeXViewDocument(
            //         "<p>\\(" + option + "\\)</p>",
            //         // r"""<p>"""+ quizList[currentQuestion].description!+"""<\p>""",
            //       ),
            //       style: TeXViewStyle(
            //           // backgroundColor: Colors.white,
            //           fontStyle: TeXViewFontStyle(
            //             fontSize: width! > 768 ? 18 : 16,
            //             fontWeight: TeXViewFontWeight.w400,
            //           ),
            //           contentColor: paragraphFont)),
            // ),
            Padding(
              padding: const EdgeInsets.only(right: 5, bottom: 2),
              child: SvgPicture.asset(
                quizAnswers[currentQuestion] != 0 && current == optionText
                    ? CustomIcons.radio2
                    : CustomIcons.radio1,
                width: 18,
                height: 23,
              ),
            ),
            Expanded(
              child: Html(
                data: "<p><tex>$option</tex></p>",
                style: {
                  "p": Style(
                    fontSize: width! > 768 ? FontSize.large : FontSize.larger,
                  ),
                },
                extensions: [
                  TagExtension(
                    tagsToExtend: {'tex'},
                    builder: (context) {
                      final texString = context.element?.innerHtml ?? '';
                      final textStyle = context.style?.generateTextStyle() ?? const TextStyle();

                      return Math.tex(
                        texString,
                        mathStyle: MathStyle.text, // This differs from your previous ones
                        textStyle: textStyle,
                        onErrorFallback: (FlutterMathException e) => Text(e.message),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
