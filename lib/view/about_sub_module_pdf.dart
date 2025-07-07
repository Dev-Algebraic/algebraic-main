import 'dart:async';
import 'dart:io';

import 'package:algebraic/app_config.dart';
import 'package:algebraic/routes/route_constants.dart';
import 'package:algebraic/view/quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';
import '../services/api_provider.dart';
import '../utils/constants.dart';
import '../utils/sharedpref.dart';

class AboutSubmodulePdf extends StatefulWidget {
  final int? topicId;
  final List? readTopicList;
  final String? htmlContent;
  final ValueChanged? onchanged;
  final int? moduleId;
  final String? moduleName;
  final String? topicName;
  final String? moduleDescription;
  final int? quizattempt;
  final String? pdfFile;
  const AboutSubmodulePdf({
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
    this.pdfFile,
  });

  @override
  State<AboutSubmodulePdf> createState() => _AboutSubmodulePdfState();
}

class _AboutSubmodulePdfState extends State<AboutSubmodulePdf>
    with TickerProviderStateMixin {
  bool isLoading = false;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  TabController? pageController;
  int? pages = 0;
  int? currentPage = 0;
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
  String? landscapePathPdf;
  Future<void> getInitialValue() async {
    setState(() {
      isLoading = true;
    });
    SharedPref sharedPref = SharedPref();
    user = UserDetails.fromJson(await sharedPref.read("user"));
    setState(() {
      userDetails = user!;
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
    pageController = TabController(length: 1, vsync: this);
    getInitialValue();
    if (widget.pdfFile != null) {
      loadNetwork();
    }
    super.initState();
    // fromAsset(CustomIcons.pdf, 'Adding and Subtracting Polynomials.pdf')
    //     .then((f) {
    //   setState(() {
    //     landscapePathPdf = f.path;
    //   });
    // });
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  File? pfile;
  Future<void> loadNetwork() async {
    var url = URLIdentifier.BASE_URL + widget.pdfFile!;
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    // final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/ ${widget.pdfFile!}');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      pfile = file;
    });

    setState(() {
      isLoading = false;
    });
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
        body: isLoading || pfile == null
            ? Center(
                child: CircularProgressIndicator(
                  color: themeColor,
                  strokeWidth: 2,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: PDFView(
                      swipeHorizontal: true,
                      fitPolicy: FitPolicy.BOTH,
                      fitEachPage: true,
                      filePath:pfile!.path,
                      // defaultPage: currentPage!,
                      onViewCreated: (PDFViewController pdfViewController) {
                        _controller.complete(pdfViewController);
                      },
                      onRender: (pages) {
                         pageController = TabController(length: pages!, vsync: this,animationDuration: Duration(seconds: 1));
                        setState(() {
                          pages = pages;
                        });
                      },
                      onPageChanged: (int? page, int? total) {
                        pageController!.index=page!;

                        // pageController.animateToPage(
                        //   page!,
                        //   duration: const Duration(milliseconds: 400),
                        //   curve: Curves.easeInOut,
                        // );
                        currentPage = page;
                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // FutureBuilder<PDFViewController>(
                        //     future: _controller.future,
                        //     builder: (context,
                        //         AsyncSnapshot<PDFViewController> snapshot) {
                        //       if (snapshot.hasData && currentPage != 0) {
                        //         return InkWell(
                        //           onTap: () async {
                        //             currentPage = currentPage! - 1;
                        //             await snapshot.data!.setPage(currentPage!);
                        //           },
                        //           child: const Center(
                        //             child: Icon(
                        //               Icons.arrow_back_rounded,
                        //               color: Colors.black54,
                        //             ),
                        //           ),
                        //         );
                        //       }
                        //       return const Center(
                        //         child: Icon(
                        //           Icons.arrow_forward_rounded,
                        //           color: Colors.white,
                        //         ),
                        //       );
                        //     }),
                        TabPageSelector(controller: pageController,
                        selectedColor: themeColor),
                      
                        // Text(
                        //   "Page " +
                        //       (currentPage! + 1).toString() +
                        //       " of $pages",
                        //   style: const TextStyle(
                        //       fontSize: 12,
                        //       fontWeight: FontWeight.w500,
                        //       color: Colors.black54),
                        // ),
                        // FutureBuilder<PDFViewController>(
                        //     future: _controller.future,
                        //     builder: (context,
                        //         AsyncSnapshot<PDFViewController> snapshot) {
                        //       if (snapshot.hasData &&
                        //           currentPage! < pages! - 1) {
                        //         return InkWell(
                        //           onTap: () async {
                        //             currentPage = currentPage! + 1;
                        //             await snapshot.data!.setPage(currentPage!);
                        //           },
                        //           child: const Center(
                        //             child: Icon(
                        //               Icons.arrow_forward_rounded,
                        //               color: Colors.black54,
                        //             ),
                        //           ),
                        //         );
                        //       }
                        //       return const Center(
                        //         child: Icon(
                        //           Icons.arrow_forward_rounded,
                        //           color: Colors.white,
                        //         ),
                        //       );
                        //     }),
                      ],
                    ),
                  ),

                  // IconButton(
                  //     onPressed: () {
                  //       // _controller.setPage(pages! ~/ 2)
                  //     },
                  //     icon: const Icon(
                  //       Icons.arrow_forward_ios,
                  //       color: Colors.black,
                  //     ))
                ],
              ),
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
                      Navigator.pop(context);
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
