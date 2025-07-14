import 'dart:async';
import 'dart:io';

import 'package:algebraic/app_config.dart';
import 'package:algebraic/models/user.dart';
import 'package:algebraic/utils/sharedpref.dart';
import 'package:algebraic/view/login.dart';
import 'package:algebraic/view/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../services/api_provider.dart';
import '../utils/constants.dart';

class Privacy extends StatefulWidget {
  final bool isLogin;
  const Privacy({Key? key, required this.isLogin}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> with TickerProviderStateMixin {
  bool isLoading = true;
  List htmlData = [];
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  TabController? pageController;
  int? pages = 0;
  int? currentPage = 0;
  String pdfFile = "Privacy Policy.pdf";
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
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      widget.isLogin ? const Login() : const SignUp()));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Row(
            children: const [Icon(Icons.arrow_back_ios)],
          ),
        ),
      ),
      title: Row(
        children: const [
          Text(
            'Privacy Policy',
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

  Future<void> getSession() async {
    SharedPref sharedPref = SharedPref();
    userDetails = UserDetails.fromJson(await sharedPref.read("user"));

    setState(() {});
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
                builder: (context) =>
                    widget.isLogin ? const Login() : const SignUp()));
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
                            animationDuration: const Duration(seconds: 1));
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
                ],
              ),
      ),
    );
  }
}
