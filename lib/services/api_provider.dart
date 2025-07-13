import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'base_service.dart';

class SignUpApiProvider extends BaseService {
  Future<dynamic> signUpAPI(jsonMap) async {
    var url = "signup";
    try {
      var response = await postRequest(url, jsonMap);
      return json.decode(response);
    } catch (err) {

      Fluttertoast.showToast(
          msg:
              'An error occurred while processing your request. Please try again later.');
    }
  }
}

class LoginApiProvider extends BaseService {
  Future<dynamic> loginAPI(jsonMap) async {
    var url = "login";
    try {
      var response = await postRequest(url, jsonMap);
      return json.decode(response);
    } catch (err) {
      Fluttertoast.showToast(
          msg:
              'An error occurred while processing your request. Please try again later. Provider');
    }
  }
}

class GetModulesApiProvider extends BaseService {
  Future<dynamic> getModulesAPI(id) async {
    Response response;
    response = await getRequest("modules/get/$id");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('An exception occured');
    }
  }
}

class PostReadApiProvider extends BaseService {
  Future<dynamic> postReadAPI(jsonMap) async {
    var url = "modules/read-topics/create";
    try {
      var response = await postRequest(url, jsonMap);
      return json.decode(response);
    } catch (err) {
      Fluttertoast.showToast(
          msg:
              'An error occurred while processing your request. Please try again later.');
    }
  }
}

class GetTopicsApiProvider extends BaseService {
  Future<dynamic> getTopicsAPI(id) async {
    Response response;
    response = await getRequest("modules/topics/$id");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('An exception occured');
    }
  }
}

class GetReadTopicsApiProvider extends BaseService {
  Future<dynamic> getReadTopicsAPI(id) async {
    Response response;
    response = await getRequest("modules/read-topics/$id");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('An exception occured');
    }
  }
}

class GetQuizApiProvider extends BaseService {
  Future<dynamic> getQuizAPI(id) async {
    Response response;
    response = await getRequest("modules/quiz/$id");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('An exception occured');
    }
  }
}

class GetScoreByModuleIdApiProvider extends BaseService {
  Future<dynamic> getScoreByModuleId(moduleId, userId) async {
    Response response;

    response = await getRequest("modules/score/attempts/module/$moduleId/$userId");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('An exception occured');
    }
  }
}

class GetTopicContentApiProvider extends BaseService {
  Future<dynamic> getTopicContentAPI(id) async {
    Response response;
    response = await getRequest("modules/topics/read/$id");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('An exception occured');
    }
  }
}

class PostScoreProvider extends BaseService {
  Future<dynamic> postScoreAPI(jsonMap) async {
    var url = "modules/score/create";
    try {
      var response = await postRequest(url, jsonMap);
      return json.decode(response);
    } catch (err) {
      Fluttertoast.showToast(
          msg:
              'An error occurred while processing your request. Please try again later.');
    }
  }
}

class GetFormulaSheetApiProvider extends BaseService {
  Future<dynamic> getFormulaSheetAPI() async {
    Response response;
    response = await getRequest("formula-sheet/get");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('An exception occured');
    }
  }
}

class ForgotPasswordApiProvider extends BaseService {
  Future<dynamic> forgotPasswordAPI(jsonMap) async {
    var url = "forgot-password";
    try {
      String response = await postRequest(url, jsonMap);
      return json.decode(response);
    } catch (err) {
      Fluttertoast.showToast(
          msg:
              'An error occurred while processing your request. Please try again later.');
    }
  }
}
