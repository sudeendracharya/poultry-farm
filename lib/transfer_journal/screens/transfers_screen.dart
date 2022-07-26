import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/transfer_journal/screens/transfer_in_screen.dart';
import 'package:poultry_login_signup/transfer_journal/screens/transfer_out_screen.dart';

import '../../screens/global_app_bar.dart';
import '../../screens/main_dash_board.dart';

class TransfersJournelScreen extends StatefulWidget {
  TransfersJournelScreen({Key? key}) : super(key: key);

  static const routeName = '/TransfersJournelScreen';

  @override
  State<TransfersJournelScreen> createState() => _TransfersJournelScreenState();
}

class _TransfersJournelScreenState extends State<TransfersJournelScreen>
    with SingleTickerProviderStateMixin {
  List<bool> _isOpen = [false];
  bool isOpened = false;

  var route = false;
  var query = '';
  ScrollController controller = ScrollController();
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: myTabs.length,
    );

    super.initState();
  }

  static List<Tab> myTabs = <Tab>[
    Tab(
      child: Container(
        width: 150,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'Transfer Out',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ),
      // text: 'Administration',
    ),
    Tab(
      child: Container(
        width: 166,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'Transfer In',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ),
      // text: 'Administration',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final expansionHeaderTheme = Theme.of(context).textTheme.headline6;
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;

    return Scaffold(
      drawer: PrimarySideBar(
        controller: controller,
        expansionHeaderTheme: expansionHeaderTheme,
      ),
      appBar: GlobalAppBar(firmName: query, appbar: AppBar()),
      body: Container(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
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
                    'Transfers',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: const Color.fromRGBO(0, 0, 0, 0.5)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 29.0,
                bottom: 00,
                left: 43.0,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  margin: const EdgeInsets.only(bottom: 0),
                  height: 40,
                  child: TabBar(
                    automaticIndicatorColorAdjustment: true,
                    enableFeedback: true,
                    indicatorColor: Colors.black,
                    indicatorWeight: 3,
                    indicator: const BoxDecoration(
                        color: Color.fromRGBO(245, 245, 245, 1)),
                    overlayColor: MaterialStateProperty.all(Colors.grey),
                    controller: _tabController,
                    tabs: myTabs,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 43.0,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                child: TabBarView(controller: _tabController, children: [
                  SingleChildScrollView(child: TransferOutScreen()),
                  SingleChildScrollView(child: TransferInScreen()),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
