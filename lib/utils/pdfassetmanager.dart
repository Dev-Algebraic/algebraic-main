import 'package:algebraic/utils/constants.dart';

String getPdfUrl(moduleName, topicName) {
  String convertedTopicName = topicName.replaceAll(' ', '_');
  String finalPath = '${pdfPath}${moduleName}/${convertedTopicName}.pdf';

  return finalPath;
}