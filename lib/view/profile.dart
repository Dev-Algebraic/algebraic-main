import 'package:algebraic/utils/constants.dart';
import 'package:algebraic/view/components/textformfield_widget.dart';
import 'package:flutter/material.dart';

import '../../utils/sharedpref.dart';
import 'package:algebraic/routes/route_constants.dart';
import 'package:flutter_svg/svg.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AppBar appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: themeColor,
      // toolbarHeight: 64,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
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
            'Settings',
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
              'V',
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

  Future<void> onLogout() async {
    SharedPref sharedPref = SharedPref();

    await sharedPref.remove("user");
    Navigator.pushNamed(context, loginRoute);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: appBar(),
        body: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 19),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  const Text(
                    'Profile',
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
                  const Text(
                    'Settings',
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
                  Padding(
                    padding: const EdgeInsets.only(top: 37.0),
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
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: saveButton()),
                      ),
                    ],
                  ),
                ]),
          )),
        ),
      ),
    );
  }
}
