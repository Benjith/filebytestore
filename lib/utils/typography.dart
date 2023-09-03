import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_resources.dart';

TextStyle display = GoogleFonts.inter(
  fontSize: 40,
  fontWeight: FontWeight.w800,
);
TextStyle h1 = GoogleFonts.inter(
  fontSize: 60,
  fontWeight: FontWeight.w500,
);
TextStyle h2 = GoogleFonts.inter(
  fontSize: 30,
  fontWeight: FontWeight.w500,
);

TextStyle h4 = GoogleFonts.inter(
  fontSize: 24,
  fontWeight: FontWeight.w500,
);
TextStyle h5 = GoogleFonts.inter(
  fontSize: 20,
  fontWeight: FontWeight.w500,
);
TextStyle h6 = GoogleFonts.inter(
  fontSize: 18,
  fontWeight: FontWeight.w500,
);
TextStyle subHeading1 = GoogleFonts.inter(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);
TextStyle subHeading2 = GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w600,
);
TextStyle font14W500 = GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);
TextStyle font14W400 = GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

TextStyle caption = GoogleFonts.inter(
  fontSize: 12,
  fontWeight: FontWeight.w400,
);
TextStyle captionMedium = GoogleFonts.inter(
  fontSize: 12,
  fontWeight: FontWeight.w500,
);
TextStyle buttonText = GoogleFonts.inter(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

TextStyle body1Medium = GoogleFonts.inter(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);
TextStyle body2Medium = GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);
TextStyle body1 = GoogleFonts.inter(
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

TextStyle body2 = GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w400,
);
TextStyle inter = GoogleFonts.inter(
  fontSize: 25,
  fontWeight: FontWeight.w600,
);

extension TextStyleExtensions on TextStyle {
  TextStyle get primary => copyWith(color: ColorResources.primary);
  TextStyle get border => copyWith(color: ColorResources.placeHolder);

  TextStyle get grey => copyWith(color: ColorResources.grey);
  TextStyle get placeholder => copyWith(color: ColorResources.placeHolder);
  TextStyle get red => copyWith(color: ColorResources.red);
  TextStyle get black => copyWith(color: Colors.black);

  TextStyle get s12 => copyWith(fontSize: 12.0);
  TextStyle get s14 => copyWith(fontSize: 14.0);
  TextStyle get s16 => copyWith(fontSize: 16.0);
  TextStyle get s18 => copyWith(fontSize: 18.0);
  TextStyle get s25 => copyWith(fontSize: 25.0);
  TextStyle get s30 => copyWith(fontSize: 30.0);
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);
}
