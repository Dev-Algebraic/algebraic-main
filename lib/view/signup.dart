
import 'package:algebraic/services/api_provider.dart';
import 'package:algebraic/utils/constants.dart';
import 'package:algebraic/view/components/textformfield_widget.dart';
import 'package:algebraic/view/login.dart';
import 'package:algebraic/view/privacy.dart';
import 'package:algebraic/view/terms.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import '../models/user.dart';
// import '../utils/sharedpref.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? fName;
  String? lName;
  String? email;
  String? phNo;
  String? userName;
  String? password;
  String? retypePassword;
  String? errortext;
  TextEditingController retypePasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showpassword1 = false;
  bool showpassword2 = false;
  
  Future<void> onSubmit() async {
    setState(() => isLoading = true);
    SignUpApiProvider signup = SignUpApiProvider();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map payLoad = {
        "firstName": fName,
        "lastName": lName,
        "email": email,
        "phoneNo": phNo,
        "username": userName,
        "password": password
      };
      // UserDetails userobj = UserDetails();
      // SharedPref sharedPref = SharedPref();
      try {
        final navigator = Navigator.of(context);

        await signup.signUpAPI(payLoad).then(
          (op) async {

            if (op["error"] == null && op["data"] != null) {
              Fluttertoast.showToast(
                  msg: 'You have Successfully Registered New User');
              setState(() => isLoading = false);
              navigator.pushReplacement(MaterialPageRoute(builder: (context) => const Login()));
              // userobj.firstName = fName;
              // userobj.lastName = lName;
              // userobj.phoneNumber = phNo;
              // userobj.username = userName;
              // userobj.emailId = email;
              // userobj.id = op["data"][0]["id"];

              // await sharedPref.save("user", userobj);
              // // await sharedPref.save("userName", userName);
              // // await sharedPref.save("password", password);
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const Introduction()));
              // setState(() {});
            } else {
              Fluttertoast.showToast(msg: op["error"]);
              setState(() => isLoading = false);
            }
          },
        );
      } catch (err) {
        setState(() => isLoading = false);
        // errorToastMsg(
        //   errorToastMsgString,
        // );
        // setState(() {
        //   LoaderStatus.isLoading = false;
        //   isError = true;
        // });
        // logError(
        //   err.toString(),
        //   "Get Andon List",
        //   stack: stack.toString(),
        // );
      }
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  Row loginButton() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 0),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9))),
                    backgroundColor: themeColor,
                    elevation: 0),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: const Text(
                  'Back to Login',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        // CircleAvatar(
        //   radius: 25,
        //   backgroundColor: const Color.fromRGBO(221, 226, 243, 1),
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
          onSubmit();
        },
        child: isLoading
            ? const CircularProgressIndicator(
                strokeWidth: 2,
              )
            : const Text(
                'Register as New',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.white),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        }
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
                children: [
                  SvgPicture.asset(CustomIcons.logo),
                ],
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
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 19, top: 120),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sign up to',
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
                        Padding(
                          padding: const EdgeInsets.only(top: 37.0),
                          child: TextformWidget(
                            initialValue: '', labelName: 'First Name',
                            saved: (val) => fName = val,
                            // focusNode: nameFieldFocus,
                            autofocus: false,
                            isMandatory: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            capitalization: TextCapitalization.words,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14.0),
                          child: TextformWidget(
                            initialValue: '', labelName: 'Last Name',
                            saved: (val) => lName = val,
                            // focusNode: nameFieldFocus,
                            autofocus: false,
                            isMandatory: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            capitalization: TextCapitalization.words,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14.0),
                          child: TextformWidget(
                            initialValue: '', labelName: 'Email',
                            saved: (val) => email = val,
                            // focusNode: nameFieldFocus,
                            autofocus: false,
                            isMandatory: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardtype: TextInputType.emailAddress,
                            capitalization: TextCapitalization.none,
                            email: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14.0),
                          child: TextformWidget(
                            initialValue: '', labelName: 'Phone Number',
                            saved: (val) => phNo = val,
                            // focusNode: nameFieldFocus,
                            autofocus: false,
                            isMandatory: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardtype: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14.0),
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            capitalization: TextCapitalization.none,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                                      colorFilter: ColorFilter.mode(themeColor, BlendMode.srcIn),
                                                    )
                                                  : SvgPicture.asset(
                                                      CustomIcons.visibilityOn,
                                                      colorFilter: ColorFilter.mode(themeColor, BlendMode.srcIn),
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
                                          color:
                                              Color.fromRGBO(202, 212, 224, 1),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(202, 212, 224, 1),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: BorderSide(
                                          color: themeColor,
                                        ),
                                      ),
                                      errorStyle: const TextStyle(
                                          color:
                                              Color.fromRGBO(244, 151, 142, 1)),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(244, 151, 142, 1),
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
                            padding: const EdgeInsets.only(top: 14.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Retype Password',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        color:
                                            Color.fromRGBO(142, 158, 177, 1)),
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
                                                          colorFilter: ColorFilter.mode(themeColor, BlendMode.srcIn),
                                                        )
                                                      : SvgPicture.asset(
                                                          CustomIcons
                                                              .visibilityOn,
                                                          colorFilter: ColorFilter.mode(themeColor, BlendMode.srcIn),
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
                                          errorStyle: const TextStyle(
                                              color: Color.fromRGBO(
                                                  244, 151, 142, 1)),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: const BorderSide(
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
                                            // } else if (val.length < 4) {
                                            //   return ' Passwords must be 4 or more characters';
                                          } else if (passwordController.text !=
                                              retypePasswordController.text) {
                                            return 'Passwords do not match';
                                          } else {
                                            return null;
                                          }
                                        }),
                                  ),
                                ])),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 14.0),
                                    child: registerButton())),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: loginButton()),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 50.0, top: 20),
                            child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text:
                                        '''© Aditya Krishnan, Lake Nona High School\n''',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(91, 93, 107, 1),
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: '''You agree to algebraic''',
                                        style: TextStyle(
                                          color: Color.fromRGBO(91, 93, 107, 1),
                                        ),
                                      ),
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
                                                            isLogin: false,
                                                          )));
                                            }),
                                      const TextSpan(
                                          text:
                                              ''' and confirm that you have read''',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(91, 93, 107, 1),
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
                                                            isLogin: false,
                                                          )));
                                            }),
                                    ])),
                          ),
                        )
                      ]),
                ),
              ),
            ),
          ]),
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
