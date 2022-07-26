import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/sales_journal/screens/sales_page.dart';
import 'package:poultry_login_signup/planning/screens/inventory_adjustment_screen.dart';
import 'package:poultry_login_signup/planning/screens/planning_screen.dart';
import 'package:poultry_login_signup/screens/global_app_bar.dart';
import 'package:poultry_login_signup/screens/main_drawer_screen.dart';
import 'package:poultry_login_signup/screens/secondary_dashboard_screen.dart';
import 'package:poultry_login_signup/transfer_journal/screens/transfers_screen.dart';

import '../planning/screens/batch_planning_page.dart';

class OperationsScreen extends StatefulWidget {
  OperationsScreen({Key? key}) : super(key: key);

  static const routeName = '/OperationsScreen';
  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen>
    with SingleTickerProviderStateMixin {
  List<bool> _isOpen = [false];
  bool isOpened = false;

  var route = false;
  var query = '';
  ScrollController controller = ScrollController();

  TextStyle tabStyle() {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black));
  }

  @override
  void initState() {
    var index = Get.arguments;

    _tabController = TabController(
        vsync: this, length: myTabs.length, initialIndex: index ?? 0);

    super.initState();
  }

  static List<Tab> myTabs = <Tab>[
    // Tab(
    //   child: Container(
    //     width: 166,
    //     height: 44,
    //     alignment: Alignment.center,
    //     child: Text(
    //       'Planning',
    //       style: GoogleFonts.roboto(
    //           textStyle: const TextStyle(
    //               fontWeight: FontWeight.w700,
    //               fontSize: 18,
    //               color: Colors.black)),
    //     ),
    //   ),
    //   // text: 'Administration',
    // ),
    // Tab(
    //   child: Container(
    //     width: 100,
    //     height: 44,
    //     alignment: Alignment.center,
    //     child: Text(
    //       'Transfers',
    //       style: GoogleFonts.roboto(
    //           textStyle: const TextStyle(
    //               fontWeight: FontWeight.w700,
    //               fontSize: 18,
    //               color: Colors.black)),
    //     ),
    //   ),
    //   // text: 'Administration',
    // ),
    // Tab(
    //   child: Container(
    //     width: 100,
    //     height: 44,
    //     alignment: Alignment.center,
    //     child: Text(
    //       'Sales',
    //       style: GoogleFonts.roboto(
    //           textStyle: const TextStyle(
    //               fontWeight: FontWeight.w700,
    //               fontSize: 18,
    //               color: Colors.black)),
    //     ),
    //   ),
    //   // text: 'Administration',
    // ),
    Tab(
      child: Container(
        width: 200,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'Inventory Adjustment',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black)),
        ),
      ),
      // text: 'Administration',
    ),
  ];

  late TabController _tabController;
  @override
  Widget build(BuildContext context) {
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    return Scaffold(
      drawer: MainDrawer(controller: controller),
      appBar: GlobalAppBar(firmName: query, appbar: AppBar()),
      body: Padding(
        padding: const EdgeInsets.only(top: 18),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Get.offNamed(SecondaryDashBoardScreen.routeName);
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
                    'Operations',
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
                    controller: _tabController,
                    tabs: myTabs,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 43.0),
              child: Divider(
                color: Colors.black,
                height: 0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 43.0,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                child: TabBarView(controller: _tabController, children: [
                  // PlanningScreen(),
                  // SingleChildScrollView(child: BatchPlanningPage()),
                  // TransfersJournelScreen(),
                  // CustomerSalesPage(),
                  InventoryAdjustmentScreen(),
                ]),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
