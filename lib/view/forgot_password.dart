import 'package:algebraic/routes/route_constants.dart';
import 'package:algebraic/view/components/textformfield_widget.dart';
import 'package:algebraic/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/api_provider.dart';
import '../utils/constants.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isLoading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController retypePasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showpassword1 = false;
  bool showpassword2 = false;
  String? userName;
  String? password;
  String? email;
  Future<void> onSubmit() async {
    setState(() => isLoading = true);
    ForgotPasswordApiProvider forgotPassword = ForgotPasswordApiProvider();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map payLoad = {
        "email": email,
        "username": userName,
        "password": password
      };
      try {
        await forgotPassword.forgotPasswordAPI(payLoad).then(
          (op) async {
            if (op["error"] == null) {
              Fluttertoast.showToast(msg: op["data"]);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
              setState(() {});
            } else {
              Fluttertoast.showToast(msg: op["error"]);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            }
          },
        );
      } catch (err) {
        Fluttertoast.showToast(msg: "An error occured please try again later");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, loginRoute);
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leadingWidth: 70,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, loginRoute);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: themeColor,
              ),
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
          //     child: InkWell(
          //       onTap: () {
          //         Navigator.pushNamed(context, loginRoute);
          //       },
          //       child: Icon(
          //         Icons.arrow_back_ios,
          //         color: themeColor,
          //       ),
          //     ),
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
                      Text(
                        'Change',
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
                      Text(
                        'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 36,
                          color: Color.fromRGBO(
                            34,
                            34,
                            34,
                            1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Text(
                          'To change password please enter correct username and email',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color.fromRGBO(
                              104,
                              110,
                              120,
                              1,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 14.0),
                        child: TextformWidget(
                          initialValue: '', labelName: 'User Name',
                          saved: (val) => userName = val,
                          // focusNode: nameFieldFocus,
                          // errortxt: errortext,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'This field is required';
                            } else if (val.length < 3) {
                              return 'Username must be 3 or more characters';
                            } else {
                              return null;
                            }
                          },
                          autofocus: false,
                          isMandatory: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          capitalization: TextCapitalization.words,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 14.0),
                        child: TextformWidget(
                          initialValue: '', labelName: 'Email',
                          saved: (val) => email = val,
                          // focusNode: nameFieldFocus,
                          autofocus: false,
                          isMandatory: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardtype: TextInputType.emailAddress,
                          capitalization: TextCapitalization.words,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                  color: Color.fromRGBO(142, 158, 177, 1)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: TextFormField(
                                  obscureText: !showpassword1,
                                  style: TextStyle(
                                    color: themeColor,
                                  ),
                                  controller: passwordController,
                                  textCapitalization: TextCapitalization.none,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    suffixIcon: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 14.0),
                                          child: InkWell(
                                            onTap: () {
                                              showpassword1 =
                                                  togglePasswordView(
                                                      showpassword1);
                                              setState(() {});
                                            },
                                            child: showpassword1
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
                                    counterText: "",
                                    contentPadding: const EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(202, 212, 224, 1),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(202, 212, 224, 1),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(
                                        color: themeColor,
                                      ),
                                    ),
                                    errorStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(244, 151, 142, 1)),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(244, 151, 142, 1),
                                      ),
                                    ),
                                  ),
                                  onSaved: (val) => password = val,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'This field is required';
                                      // } else if (val.length <= 4) {
                                      //   return ' Passwords must be 4 or more characters';
                                    } else {
                                      String pattern =
                                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{4,}$';
                                      RegExp regExp = RegExp(pattern);
                                      var isVaild = regExp.hasMatch(val);
                                      return isVaild
                                          ? null
                                          : "• Password must atleast 4 characters\n• Password must contain atleast 1 Upper Case\n• Password must contain atleast 1 Lower Case\n• Password must contain atleast 1 Numeric Number\n• Password must contain atleast 1 Special Charecter( ! @ # \$ & * ~ )";
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 14.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Retype Password',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      color: Color.fromRGBO(142, 158, 177, 1)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: TextFormField(
                                      obscureText: !showpassword2,
                                      style: TextStyle(
                                        color: themeColor,
                                      ),
                                      controller: retypePasswordController,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 14.0),
                                              child: InkWell(
                                                onTap: () {
                                                  showpassword2 =
                                                      togglePasswordView(
                                                          showpassword2);
                                                  setState(() {});
                                                },
                                                child: showpassword2
                                                    ? SvgPicture.asset(
                                                        CustomIcons
                                                            .visibilityOff,
                                                        color: themeColor,
                                                      )
                                                    : SvgPicture.asset(
                                                        CustomIcons
                                                            .visibilityOn,
                                                        color: themeColor,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        counterText: "",
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: const BorderSide(
                                            color: Color.fromRGBO(
                                                202, 212, 224, 1),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: const BorderSide(
                                            color: Color.fromRGBO(
                                                202, 212, 224, 1),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: BorderSide(
                                            color: themeColor,
                                          ),
                                        ),
                                        errorStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                244, 151, 142, 1)),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                244, 151, 142, 1),
                                          ),
                                        ),
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'This field is required';
                                        } else if (passwordController.text !=
                                            retypePasswordController.text) {
                                          return 'Passwords do not match';
                                        } else {
                                          return null;
                                        }
                                      }),
                                ),
                              ])),
                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(
                      //         left: 24.0, right: 23, bottom: 20),
                      //     child: Row(
                      //       crossAxisAlignment: CrossAxisAlignment.end,
                      //       children: [Expanded(child: changeButton())],
                      //     ),
                      //   ),
                      // )
                    ]),
              ),
            ),
          ),
        ]),
        bottomNavigationBar: changeButton(),
      ),
    );
  }

  Padding changeButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 23, bottom: 20),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(9))),
              backgroundColor: activeColorGreen,
              elevation: 0),
          onPressed: () {
            onSubmit();
          },
          child: const Text(
            'Change',
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }

  dynamic togglePasswordView(val) {
    setState(() {
      val = !val;
    });
    return val;
  }
}
