

import 'package:flutter/material.dart';

Color primaryColor = const Color(0xFF000000); // Black color
Color secondaryColor = const Color(0xffffffff);
Color accentColor = const Color(0xfff6f0f1);

double kSpacing = 20.00;

double kfontSize = 18.00;
double kLargefontSize = 25.00;

BorderRadius kBorderRadius = BorderRadius.circular(kSpacing);

EdgeInsets kPadding = EdgeInsets.all(kSpacing);
EdgeInsets kHPadding = EdgeInsets.symmetric(horizontal: kSpacing);
EdgeInsets kVPadding = EdgeInsets.symmetric(vertical: kSpacing);


getBtnStyle(context) => ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: kBorderRadius), backgroundColor: primaryColor,
    fixedSize: Size(MediaQuery.of(context).size.width, 47),
    textStyle: const TextStyle(fontWeight: FontWeight.bold));
var btnTextStyle = TextStyle(fontSize: kfontSize);
