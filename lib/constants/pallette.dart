import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kblack = Colors.black;
const Color kblue = Color.fromARGB(255, 37, 91, 184);
final Color kpink = Colors.pink.shade700;

class TextStyling {
  final styleh1 = GoogleFonts.lato(
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 26,
      fontWeight: FontWeight.bold,
    ),
  );

  final styleh2 = GoogleFonts.lato(
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.w400,
    ),
  );

  final styleh3 = GoogleFonts.lato(
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
  );

  final stylep1 = GoogleFonts.lato(
    textStyle: const TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );
}
