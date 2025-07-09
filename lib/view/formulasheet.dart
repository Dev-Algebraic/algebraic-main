import 'dart:async';
import 'dart:io';

import 'package:algebraic/app_config.dart';
import 'package:algebraic/models/user.dart';
import 'package:algebraic/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../services/api_provider.dart';
import '../utils/constants.dart';

class FormulaSheet extends StatefulWidget {
  final bool isSubview;

  const FormulaSheet({super.key, required this.isSubview});

  @override
  State<FormulaSheet> createState() => _FormulaSheetState();
}

class _FormulaSheetState extends State<FormulaSheet> with TickerProviderStateMixin  {
  bool isLoading = true;
  List htmlData = [];
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  TabController? pageController;
  int? pages = 0;
  int? currentPage = 0;
  String pdfFile="formula sheet.pdf";
  UserDetails userDetails = UserDetails();
  Future<void> getContentList() async {
    setState(() {
      isLoading = true;
    });
    GetFormulaSheetApiProvider formulaSheet = GetFormulaSheetApiProvider();
    try {
      await formulaSheet.getFormulaSheetAPI().then((op) => {
            setState(() {
              if (op["data"] != null) {
                htmlData = op["data"];
              } else {
                Fluttertoast.showToast(msg: op["error"]);
              }
            }),
            setState(() {
              isLoading = false;
            })
          });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'An error occurred.Please try again.');
    }
  }
  File? pfile;
  Future<void> loadNetwork() async {
    var url = URLIdentifier.BASE_URL + pdfFile;
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    // final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$pdfFile');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      pfile = file;
    });

    print(pfile);
    setState(() {
      isLoading = false;
    });
  }

  AppBar appBar() {
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
            children: [Icon(Icons.arrow_back_ios)],
          ),
        ),
      ),
      title: Row(
        children: [
          Text(
            'Formula Sheet',
            style: TextStyle(
                fontSize: 15.75,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: CircleAvatar(
            radius: 14,
            backgroundColor: Color.fromRGBO(219, 224, 239, 1),
            child: Text(
             userDetails.firstName!=null ? userDetails.firstName![0].toUpperCase():"",
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

  Future<void> getSession() async {
    SharedPref sharedPref = SharedPref();
    userDetails = UserDetails.fromJson(await sharedPref.read("user"));

    setState(() {});
  }

  @override
  void initState() {
      pageController = TabController(length: 1, vsync: this);
    loadNetwork();
    getSession();
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
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
                        const EdgeInsets.only(left: 10, right: 10, bottom: 25),
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
      ),
    );
  }
}
