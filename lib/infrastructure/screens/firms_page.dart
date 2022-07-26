import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/infrastructure/screens/administration.dart';
import 'package:poultry_login_signup/screens/global_app_bar.dart';

import 'package:poultry_login_signup/screens/main_dash_board.dart';

import '../../screens/notifications_page.dart';

class FirmsPage extends StatefulWidget {
  FirmsPage({Key? key}) : super(key: key);

  static const routeName = '/FirmsPage';

  @override
  State<FirmsPage> createState() => _FirmsPageState();
}

class _FirmsPageState extends State<FirmsPage> {
  ScrollController controller = ScrollController();

  String query = '';

  @override
  Widget build(BuildContext context) {
    final expansionHeaderTheme = Theme.of(context).textTheme.headline6;

    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    return Scaffold(
      drawer: PrimarySideBar(
          controller: controller, expansionHeaderTheme: expansionHeaderTheme),
      appBar: GlobalAppBar(firmName: '', appbar: AppBar()),
      body: Padding(
        padding: const EdgeInsets.only(left: 45.0, top: 18),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    Get.offNamed(MainDashBoardScreen.routeName);
                  },
                  child: Text('Dashboard', style: breadCrumpsStyle),
                ),
                const Icon(
                  Icons.arrow_back_ios_new,
                  size: 15,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Infrastructure',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: const Color.fromRGBO(0, 0, 0, 0.5)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 29),
              child: AdministrationPage(),
            ),
          ],
        ),
      ),
    );
  }
}
