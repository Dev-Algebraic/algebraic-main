import 'dart:async';
import 'dart:io';

import 'package:algebraic/app_config.dart';
import 'package:algebraic/models/user.dart';
import 'package:algebraic/view/login.dart';
import 'package:algebraic/view/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class Terms extends StatefulWidget {
  final bool isLogin;
  const Terms({Key? key, required this.isLogin}) : super(key: key);

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> with TickerProviderStateMixin {
  bool isLoading = true;
  List htmlData = [];
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  TabController? pageController;
  int? pages = 0;
  int? currentPage = 0;
  String pdfFile = "Terms of Use.pdf";
  UserDetails userDetails = UserDetails();

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
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => widget.isLogin ? Login() : SignUp()));
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
            'Terms of Use',
            style: TextStyle(
                fontSize: 15.75,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ],
      ),
      centerTitle: false,
    );
  }

  @override
  void initState() {
    pageController = TabController(length: 1, vsync: this);
    loadNetwork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => widget.isLogin ? Login() : SignUp()));
        return true;
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
                      filePath: pfile!.path,
                      // defaultPage: currentPage!,
                      onViewCreated: (PDFViewController pdfViewController) {
                        _controller.complete(pdfViewController);
                      },
                      onRender: (pages) {
                        pageController = TabController(
                            length: pages!,
                            vsync: this,
                            animationDuration: Duration(seconds: 1));
                        setState(() {
                          pages = pages;
                        });
                      },
                      onPageChanged: (int? page, int? total) {
                        pageController!.index = page!;

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
                        TabPageSelector(
                            controller: pageController,
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
