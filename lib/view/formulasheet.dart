import 'dart:async';
import 'dart:io';

import 'package:algebraic/app_config.dart';
import 'package:algebraic/models/user.dart';
import 'package:algebraic/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../services/api_provider.dart';
import '../utils/constants.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class FormulaSheet extends StatefulWidget {
  final bool isSubview;

  const FormulaSheet({super.key, required this.isSubview});

  @override
  State<FormulaSheet> createState() => _FormulaSheetState();
}

class _FormulaSheetState extends State<FormulaSheet> with TickerProviderStateMixin  {
  bool isLoading = true;
  String htmlData = "";
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
                htmlData = op["data"][0]['content'];
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

    setState(() {
      isLoading = false;
    });
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: themeColor,
      // toolbarHeight: 64,
      
      leading: widget.isSubview ? InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Row(
              children: [Icon(Icons.arrow_back_ios, color: Colors.white,)],
            ),
          ),

      ) : null,
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
            backgroundColor: activeColorGreen,
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

    loadNetwork();
    getSession();
    getContentList();

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
                    child: SafeArea(
                      child: SfPdfViewerTheme(
                        data: SfPdfViewerThemeData(
                          backgroundColor: Colors.black,
                        ),
                        child: SfPdfViewer.asset(
                          'assets/pdfs/Formula_Sheet.pdf',
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
