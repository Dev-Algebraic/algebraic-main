import 'package:algebraic/app_config.dart';
import 'package:algebraic/routes/route_constants.dart';
import 'package:algebraic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({Key? key}) : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late File Pfile;
  bool isLoading = false;
  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    var url = '${URLIdentifier.BASE_URL}Types of Functions.pdf';
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      Pfile = file;
    });

    print(Pfile);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    loadNetwork();

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
              Navigator.pushNamed(context, dashboardRoute);
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
                "Types of Functions",
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

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, dashboardRoute);
        return true;
      },
      child: Scaffold(
        appBar: appBar(),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: Center(
                  child: PDFView(
                    fitPolicy: FitPolicy.BOTH,
                    fitEachPage: true,
                    filePath: Pfile.path,
                  ),
                ),
              ),
      ),
    );
  }
}
