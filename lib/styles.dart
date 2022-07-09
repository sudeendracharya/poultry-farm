import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectStyles {
  static TextStyle contentHeaderStyle() {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.w700,
      fontSize: 24,
    );
  }

  static TextStyle formFieldsHeadingStyle() {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.w700,
      fontSize: 24,
    );
  }

  static TextStyle fontStyle() {
    return GoogleFonts.roboto();
  }

  static TextStyle paginatedHeaderStyle() {
    return const TextStyle(fontWeight: FontWeight.bold);
  }

  static TextStyle normalStyle() {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
  }

  static TextStyle cancelStyle() {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );
  }
}
