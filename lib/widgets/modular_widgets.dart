import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/colors.dart';

import '../styles.dart';

class ModularWidgets {
  static Padding globalAddDetailsDialog(Size size, var save) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: SizedBox(
              width: size.width * 0.1,
              height: 48,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(44, 96, 154, 1),
                    ),
                  ),
                  onPressed: save,
                  child: Text(
                    'Add Details',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Color.fromRGBO(255, 254, 254, 1),
                      ),
                    ),
                  )),
            ),
          ),
          const SizedBox(
            width: 42,
          ),
          InkWell(
            excludeFromSemantics: true,
            splashColor: ProjectColors.themecolor,
            enableFeedback: true,
            onTap: () => Get.back(),
            child: Container(
              width: size.width * 0.1,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(44, 96, 154, 1),
                ),
              ),
              child: Text(
                'Cancel',
                style: ProjectStyles.cancelStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Padding globalUpdateDetailsDialog(Size size, var save) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: SizedBox(
              width: size.width * 0.1,
              height: 48,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(44, 96, 154, 1),
                    ),
                  ),
                  onPressed: save,
                  child: Text(
                    'Update Details',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Color.fromRGBO(255, 254, 254, 1),
                      ),
                    ),
                  )),
            ),
          ),
          const SizedBox(
            width: 42,
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: size.width * 0.1,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(44, 96, 154, 1),
                ),
              ),
              child: Text(
                'Cancel',
                style: ProjectStyles.cancelStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Padding validationDesign(Size size, var message) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: size.width * 0.25,
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromRGBO(255, 219, 219, 1)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Validation Error',
                    style: ProjectStyles.fontStyle().copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: const Color.fromRGBO(68, 68, 68, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    message,
                    style: ProjectStyles.fontStyle().copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  static Padding exceptionDesign(Size size, var message) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: size.width * 0.25,
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromRGBO(255, 219, 219, 1)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exception Error',
                    style: ProjectStyles.fontStyle().copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: const Color.fromRGBO(68, 68, 68, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    message,
                    style: ProjectStyles.fontStyle().copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Padding genericFormField({
    required Size size,
    required String hintText,
    required String onSaved,
    required TextEditingController controller,
    required Color borderColor,
    required String formHeader,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size.width * 0.25,
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(formHeader),
            ),
            Container(
              width: size.width * 0.25,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(color: borderColor),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: hintText, border: InputBorder.none),
                  onSaved: (value) {
                    onSaved = value!;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
