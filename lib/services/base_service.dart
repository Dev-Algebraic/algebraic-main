import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../app_config.dart';

class BaseService {
  Future getRequest<T, K>(dataURL) async {
    //  SharedPref sharedPref = SharedPref();

    var url = (URLIdentifier.BASE_URL) +
        dataURL ;
       
    var client = http.Client();

    final response = await client.get(
      Uri.parse(url),
    );
    print(Uri.parse(url));
    if (response.statusCode == 200) {
      return response;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('An exception occured');
    }
  }

  Future postRequest<T, K>(dataURL, jsonMap) async {
    var url = URLIdentifier.BASE_URL +
        dataURL ;
    HttpClient httpClient = HttpClient();
    // debugPrint(jsonMap);
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    print(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(
      utf8.encode(
        json.encode(jsonMap),
      ),
    );

    //log(json.encode(jsonMap));
    HttpClientResponse response = await request.close();
    String responseData = await response.transform(utf8.decoder).join();
    httpClient.close();
    // print(responseData);
    return responseData;
    // if (response.statusCode == 200) {
    //  return response;
    // } else {
    //   // If that call was not successful, throw an error.
    //   throw Exception('An exception occured');
    // }
  }
}
