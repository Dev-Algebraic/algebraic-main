import 'dart:io';

import 'package:algebraic/services/api_provider.dart';
import 'package:algebraic/utils/constants.dart';
import 'package:algebraic/view/components/textformfield_widget.dart';
import 'package:algebraic/view/forgot_password.dart';
import 'package:algebraic/view/introduction.dart';
import 'package:algebraic/view/privacy.dart';
import 'package:algebraic/view/signup.dart';
import 'package:algebraic/view/terms.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/read_list.dart';
import '../models/user.dart';
import '../utils/sharedpref.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showpassword = false;
  Align footer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50.0, left: 41, right: 42),
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: '''You agree to algebraic ''',
                style: const TextStyle(
                  color: Color.fromRGBO(91, 93, 107, 1),
                ),
                children: [
                  TextSpan(
                      text: '''Terms of service ''',
                      style: TextStyle(color: activeColorGreen)),
                  const TextSpan(
                      text: '''and confirm that you have read ''',
                      style: TextStyle(
                        color: Color.fromRGBO(91, 93, 107, 1),
                      )),
                  TextSpan(
                      text: '''privacy Policy''',
                      style: TextStyle(color: activeColorGreen))
                ])),
      ),
    );
  }

  bool isLoading = false;
  String? userName;
  String? password;
  List<ReadList> readTopicsList = [];
  Future<void> getReadTopics(id) async {
    GetReadTopicsApiProvider readTopicsListApi = GetReadTopicsApiProvider();
    try {
      await readTopicsListApi.getReadTopicsAPI(id).then((op) async {
        if (op["data"] != null) {
          if (op["data"].isEmpty) {
          } else {
            SharedPref sharedPref = SharedPref();
            final List resItems = op["data"];
            readTopicsList =
                resItems.map((resRaw) => ReadList.fromJson(resRaw)).toList();
            await sharedPref.save("readList", readTopicsList);
            setState(() {});
          }
          isLoading = false;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Introduction()));
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => const Dashboard()));
        } else {
          Fluttertoast.showToast(msg: op["error"]);
          isLoading = false;
          setState(() {});
        }
      });
    } catch (e) {
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(
          msg: 'An error occurred.Please try again.read topics');
    }
  }

  Future<void> onLogin() async {
    setState(() => isLoading = true);
    LoginApiProvider login = LoginApiProvider();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map payLoad = {"username": userName, "password": password};
      UserDetails userobj = UserDetails();
      SharedPref sharedPref = SharedPref();
      try {
        await login.loginAPI(payLoad).then(
          (op) async {
            if (op["error"] == null && op["data"].isNotEmpty) {
              userobj.firstName = op["data"]["first_name"];
              userobj.lastName = op["data"]["last_name"];
              userobj.phoneNumber = op["data"]["phone_no"];
              userobj.username = op["data"]['username'];
              userobj.emailId = op["data"]['email'];
              userobj.id = op["data"]['id'];
              await sharedPref.save("user", userobj);
              // await sharedPref.save("userName", userName);
              // await sharedPref.save("password", password);
              getReadTopics(op["data"]['id']);
            } else {
              Fluttertoast.showToast(msg: op["error"]);
              isLoading = false;
              setState(() {});
            }
          },
        );
      } catch (err) {
        isLoading = false;
        setState(() {});
        Fluttertoast.showToast(
            msg: "An error occured please try again later inside API");
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  Row loginButton() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(9))),
                  backgroundColor: themeColor,
                  elevation: 0),
              onPressed: () {
                onLogin();
              },
              child: isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                    )
                  : const Text(
                      'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.white),
                    ),
            ),
          ),
        ),
        // CircleAvatar(
        //   radius: 25,
        //   backgroundColor: Color.fromRGBO(221, 226, 243, 1),
        //   child: Icon(
        //     Icons.info_outline,
        //     color: themeColor,
        //   ),
        // )
      ],
    );
  }

  SizedBox registerButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(9))),
            backgroundColor: activeColorGreen,
            elevation: 0),
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const SignUp()));
        },
        child: const Text(
          'Register as New',
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return exit(0);
      },
      child: IgnorePointer(
        ignoring: isLoading,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leadingWidth: 70,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Row(
                children: [SvgPicture.asset(CustomIcons.logo)],
              ),
            ),
          ),
          body: Stack(children: [
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                  child: SvgPicture.asset(
                    CustomIcons.background,
                  ),
                )),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Padding(
            //     padding: const EdgeInsets.fromLTRB(25, 51, 0, 35),
            //     child: SvgPicture.asset(CustomIcons.logo),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 19, top: 120),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Welcome to',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 36,
                              color: Color.fromRGBO(
                                34,
                                34,
                                34,
                                1,
                              )),
                        ),
                        const Text(
                          'Algebraic!',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 36,
                              color: Color.fromRGBO(
                                34,
                                34,
                                34,
                                1,
                              )),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(right: 52.0, top: 15, bottom: 27),
                          child: Text(
                            '''This app goes over all of the major topics in Algebra 1 and can be used a study material to understand topics in Algebra 1 and test your knowledge to help prepare for class tests and the EOC at the end of the year.''',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Color.fromRGBO(104, 110, 120, 1)),
                          ),
                        ),
                        TextformWidget(
                          initialValue: '', labelName: 'User Name',
                          saved: (val) => userName = val,
                          // focusNode: nameFieldFocus,
                          autofocus: false,
                          isMandatory: true,
                          maxlines: 1,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          capitalization: TextCapitalization.none,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14.0),
                          child: TextformWidget(
                            minlines: 1,
                            obscureText: !showpassword, maxlines: 1,
                            initialValue: '', labelName: 'Password',
                            saved: (val) => password = val,
                            // focusNode: nameFieldFocus,
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 14.0),
                                  child: InkWell(
                                    onTap: () {
                                      togglePasswordView();
                                    },
                                    child: showpassword
                                        ? SvgPicture.asset(
                                            CustomIcons.visibilityOff,
                                            color: themeColor,
                                          )
                                        : SvgPicture.asset(
                                            CustomIcons.visibilityOn,
                                            color: themeColor,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            autofocus: false,
                            isMandatory: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            capitalization: TextCapitalization.none,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 13.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword()));
                            },
                            child: const Text(
                              'Forgot Password ?',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Color.fromRGBO(161, 195, 21, 1)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 13.0),
                          child: loginButton(),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: registerButton()),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 50.0, top: 20),
                            child: Column(
                              children: [
                                // const Text(
                                //   '© Aditya Krishnan, Lake Nona High School',
                                //   style: TextStyle(
                                //     color: Color.fromRGBO(91, 93, 107, 1),
                                //   ),
                                // ),
                                RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text: '''© Aditya Krishnan, Lake Nona High School\n''',
                                        style: const TextStyle(
                                          color: Color.fromRGBO(91, 93, 107, 1),
                                        ),
                                        children: [
                                          const TextSpan(
                                        text: '''You agree to algebraic''',
                                        style: TextStyle(
                                          color: Color.fromRGBO(91, 93, 107, 1),
                                        ),),
                                          TextSpan(
                                              text: ''' Terms of service''',
                                              style: TextStyle(
                                                  color: activeColorGreen),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Terms(
                                                                isLogin: true,
                                                              )));
                                                }),
                                          const TextSpan(
                                              text:
                                                  ''' and confirm that you have read''',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    91, 93, 107, 1),
                                              )),
                                          TextSpan(
                                              text: ''' privacy Policy''',
                                              style: TextStyle(
                                                  color: activeColorGreen),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Privacy(
                                                                isLogin: true,
                                                              )));
                                                }),
                                        ])),
                              ],
                            ),
                          ),
                        )
                        // Padding(padding: EdgeInsets.only(top: 50), child: footer())
                      ]),
                ),
              ),
            ),

            //  const Align(alignment: Alignment.bottomCenter,child: Text('v 1.0.1',style: TextStyle(
            //                     fontStyle: FontStyle.normal,
            //                     fontWeight: FontWeight.w400,
            //                     fontSize: 10,
            //                     color: Colors.black26),),)
          ]),
        ),
      ),
    );
  }

  void togglePasswordView() {
    setState(() {
      showpassword = !showpassword;
    });
  }
}
