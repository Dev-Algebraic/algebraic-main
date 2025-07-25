import 'package:algebraic/utils/constants.dart';
import 'package:algebraic/view/components/textformfield_widget.dart';
import 'package:algebraic/view/login.dart';
import 'package:flutter/material.dart';
import 'package:algebraic/models/user.dart';

import '../../utils/sharedpref.dart';
import 'package:algebraic/routes/route_constants.dart';
import 'package:flutter_svg/svg.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  // Load user data
  bool isloading = true;

  UserDetails? user;
  UserDetails userDetails = UserDetails();
  
  Future<void> getInitialValue() async {
    setState(() {
      isloading = true;
    });
    SharedPref sharedPref = SharedPref();
    user = UserDetails.fromJson(await sharedPref.read("user"));
    setState(() {
      userDetails = user!;
      isloading = false;
    });
  }

  @override
  void initState() {
    getInitialValue();
    super.initState();
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: themeColor,
      
      leading: null,
      title: Row(
        children: [
          Text(
            'Profile',
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
              userDetails.firstName![0].toUpperCase(),
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

  SizedBox saveButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(9))),
            backgroundColor: activeColorGreen,
            elevation: 0),
        onPressed: () {},
        child: const Text(
          'Save',
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  SizedBox logoutButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(9)),
              side: BorderSide(
                color: Colors.red,
                width: 1.0,
              )
            ),
            backgroundColor: Colors.transparent,
            elevation: 0).copyWith(
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.red.withAlpha(30);
                }
                return null;
              }),
              shadowColor: WidgetStateProperty.all(Colors.transparent),
            ),
        onPressed: () {onLogout();},
        child: const Text(
          'Logout',
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 14, color: Colors.red),
        ),
      ),
    );
  }

  Future<void> onLogout() async {
    SharedPref sharedPref = SharedPref();
    final navigator = Navigator.of(context, rootNavigator: true);

    await sharedPref.remove("user");
    if (!mounted) return; // <- Prevents calling context if widget is disposed
    navigator.pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: isloading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: themeColor,
                strokeWidth: 2,
              ),
            ),
          )
        : Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(),
        body: Container(
          color: Colors.white,
          
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 19),
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // Heading text
                    const Text(
                      'Profile Settings',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 36,
                          color: Color.fromRGBO(
                            67,
                            77,
                            94,
                            1,
                          )),
                    ),

                    // Editable fields
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: const TextformWidget(
                        initialValue: 'Vishnu', labelName: 'First Name',
          
                        // saved: (val) => eventName = val,
                        // focusNode: nameFieldFocus,
                        autofocus: false,
                        isMandatory: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        capitalization: TextCapitalization.words,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 14.0),
                      child: TextformWidget(
                        initialValue: 'Vishnu', labelName: 'Last Name',
          
                        // saved: (val) => eventName = val,
                        // focusNode: nameFieldFocus,
                        autofocus: false,
                        isMandatory: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        capitalization: TextCapitalization.words,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 14.0),
                      child: TextformWidget(
                        initialValue: '+91 9544546278',
                        labelName: 'Phone Number',
          
                        // saved: (val) => eventName = val,
                        // focusNode: nameFieldFocus,
                        autofocus: false,
                        isMandatory: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        capitalization: TextCapitalization.words,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 14.0),
                      child: TextformWidget(
                        initialValue: 'Passcode094#21', labelName: 'Password',
                        // saved: (val) => eventName = val,
                        // focusNode: nameFieldFocus,
                        autofocus: false,
                        isMandatory: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        capitalization: TextCapitalization.words,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 14.0),
                      child: TextformWidget(
                        initialValue: '', labelName: 'Retype Password',
                        // saved: (val) => eventName = val,
                        // focusNode: nameFieldFocus,
                        autofocus: false,
                        isMandatory: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        capitalization: TextCapitalization.words,
                      ),
                    ),

                    // Save button
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: saveButton()),
                        ),
                      ],
                    ),

                    // Logout button
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: logoutButton()),
                        ),
                      ],
                    ),

                    /*
                    OLD Logout button
                    InkWell(
                      onTap: () {
                        onLogout();
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(right: 30.0, top: 30),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: const Color.fromRGBO(243, 244, 248, 1),
                            child: SvgPicture.asset(CustomIcons.logout),
                          )),
                    ),
                    */

                  ]),
            )),
          ),
        ),
      ),
    );
  }
}
