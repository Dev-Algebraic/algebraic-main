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
              children: const [Icon(Icons.arrow_back_ios, color: Colors.white,)],
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
      ),
    );
  }

  @override
  void dispose() {
    //...
    super.dispose();
    //...
  }
}
