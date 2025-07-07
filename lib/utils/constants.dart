import 'package:flutter/cupertino.dart';

String iconPath = "assets/svg/";

Color themeColor = Color.fromRGBO(62, 81, 141, 1);
Color activeColorGreen = Color.fromRGBO(161, 195, 21, 1);
Color disableButtonColor = Color.fromRGBO(207, 211, 221, 1);
Color paragraphFont = Color.fromRGBO(91, 93, 107, 1);

class CustomIcons {
  static String background = "${iconPath}background.svg";
  static String logo = "${iconPath}logo.svg";
  static String menuBar = "${iconPath}menuBar.svg";
  static String formulaSheet = "${iconPath}formulaSheet.svg";
  static String fileIcon = "${iconPath}fileIcon.svg";
  static String bookmark = "${iconPath}bookmark.svg";
  static String logout = "${iconPath}logout.svg";
  static String home = "${iconPath}home.svg";
  static String formula = "${iconPath}formula.svg";
  static String quiz = "${iconPath}quiz.svg";
  static String visibilityOff = "${iconPath}visibility_off.svg";
  static String visibilityOn = "${iconPath}visibility_on.svg";
  static String per100 = "${iconPath}1.svg";
  static String per90 = "${iconPath}2.svg";
  static String per80 = "${iconPath}3.svg";
  static String per70 = "${iconPath}4.svg";
  static String per60 = "${iconPath}5.svg";
  static String per50 = "${iconPath}6.svg";
  static String per40 = "${iconPath}7.svg";
  static String per30 = "${iconPath}8.svg";
  static String per20 = "${iconPath}9.svg";
  static String per10 = "${iconPath}10.svg";
  static String per0 = "${iconPath}0.svg";
  static String radio1 = "${iconPath}radio1.svg";
  static String radio2 = "${iconPath}radio2.svg";
  static String pdf = "${iconPath}Adding and Subtracting Polynomials.pdf";
}

//email validation
String? validateEmail(String? value) {
  if (value!.isEmpty) return 'Enter a valid email';
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern as String);
  if (!regex.hasMatch(value)) {
    return 'Enter a valid email';
  } else {
    return null;
  }
}





// String? htmlData;
// const htmlData = r"""<h1 style = "font-family: 'Inter';
// font-style: normal;
// font-weight: 400;
// font-size: 36px;
// color: #222222;">Basics of Polynomials</h1>
//     <p style="font-family: 'Inter';
// font-style: normal;
// font-weight: 400;
// font-size: 12px;
// color: #5B5D6B;"> Polynomials are expressions with many terms. There are specific names for certain polynomials that have 1, 2 or 3 terms in them. </p>
//       <ul style="font-family: 'Inter';
// font-style: normal;
// font-weight: 400;
// font-size: 12px;
// color: #5B5D6B;">
//   <li>A monomial is a polynomial with 1 term</li>
//   <li>A binomial is a polynomial with 2 terms</li>
//   <li>A trinomial is a polynomial with 3 terms</li>
// </ul>
//  <h2 style=" font-family: 'Inter';
// font-style: normal;
// font-weight: 600;
// font-size: 18px;
// color: #434D5E;">Vocabulary:</h2>
//       <p style="font-family: 'Inter';
// font-style: normal;
// font-weight: 400;
// font-size: 12px;
// color: #5B5D6B;">Terms - Numbers or variables that differ by their exponents (Examples are 6x?, 3x and 15) In polynomials, terms are separated by addition or subtraction signs Like Terms - Terms that have the SAME exponents but have DIFFERENT coefficients (20x* and 10x° are like terms) Coefficents - A number placed BEFORE a variable in a term (In 4x’, 4 is the coefficent) Exponents - The number that the base is RAISED to (In 8, 2 is the exponent and 8 is the base) Variables - A symbol used to describe any number (In 3x°, x is the variable) Constant - A FIXED value that never changes - as a variable, it would be x’, which is 1 (Examples are 35, 5, TT) rT</p>
//  <img src="http://zinemind.in/login-rht-img.0d3a707e0294f342ee0c.png">

//  <p style="font-family: 'Inter';
// font-style: normal;
// font-weight: 400;
// font-size: 12px;
// color: #5B5D6B;">Terms - Numbers or variables that differ by their exponents (Examples are 6x?, 3x and 15) In polynomials, terms are separated by addition or subtraction signs Like Terms - Terms that have the SAME exponents but have DIFFERENT coefficients (20x* and 10x° are like terms) Coefficents - A number placed BEFORE a variable in a term (In 4x’, 4 is the coefficent) Exponents - The number that the base is RAISED to (In 8, 2 is the exponent and 8 is the base) Variables - A symbol used to describe any number (In 3x°, x is the variable) Constant - A FIXED value that never changes - as a variable, it would be x’, which is 1 (Examples are 35, 5, TT) rT
// </p>
// <h2 style=" font-family: 'Inter';
// font-style: normal;
// font-weight: 600;
// font-size: 18px;

// color: #434D5E;">Vocabulary Table :</h2>

//     <table style="width:100%">
//     <tr>
//     <th>No</th>
//     <th>Name</th>
//     <th>Weight</th>
//       <th>Symbol</th>
//   </tr>
//   <tr>
//     <td>1</td>
//     <td>Hydrogen</td>
//     <td>1.007</td>
//     <td>H</td>

//   </tr>
//   <tr>
//     <td>1</td>
//     <td>Hydrogen</td>
//     <td>1.007</td>
//     <td>H</td>

//   </tr>
//       <tr>
//     <td>1</td>
//     <td>Hydrogen</td>
//     <td>1.007</td>
//     <td>H</td>

//   </tr>
//       <tr>
//     <td>1</td>
//     <td>Hydrogen</td>
//     <td>1.007</td>
//     <td>H</td>

//   </tr>
//       <tr>
//     <td>1</td>
//     <td>Hydrogen</td>
//     <td>1.007</td>
//     <td>H</td>

//   </tr>
//     </table>""";




