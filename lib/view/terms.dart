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
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';

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
                    child: SafeArea(
                      child: SfPdfViewerTheme(
                        data: SfPdfViewerThemeData(
                          backgroundColor: Colors.black,
                        ),
                        child: SfPdfViewer.asset(
                          'assets/pdfs/Terms_of_Use.pdf',
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
}
