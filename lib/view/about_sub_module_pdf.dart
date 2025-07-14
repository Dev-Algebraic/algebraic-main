import 'dart:async';
import 'dart:io';

import 'package:algebraic/app_config.dart';
import 'package:algebraic/routes/route_constants.dart';
import 'package:algebraic/view/quiz.dart';
import 'package:algebraic/utils/pdfassetmanager.dart';
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
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';

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
    
    if (widget.pdfFile != null) {
      loadNetwork();
    }

    super.initState();
  }

  File? pfile;
  Future<void> loadNetwork() async {

    var url = URLIdentifier.BASE_URL + widget.pdfFile!;
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

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

    String pdfUrl = getPdfUrl(widget.moduleName, widget.topicName);

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
                    child: SafeArea(
                      child: SfPdfViewerTheme(
                        data: SfPdfViewerThemeData(
                          backgroundColor: Colors.black,
                        ),
                        child: SfPdfViewer.asset(
                          pdfUrl,
                          pageLayoutMode: PdfPageLayoutMode.continuous,
                          canShowScrollHead: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
