import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/sales_journal/screens/companies_page.dart';
import 'package:poultry_login_signup/sales_journal/screens/customers_page.dart';
import 'package:poultry_login_signup/screens/global_app_bar.dart';
import 'package:poultry_login_signup/screens/main_dash_board.dart';
import 'package:poultry_login_signup/screens/main_drawer_screen.dart';
import 'package:poultry_login_signup/screens/secondary_dashboard_screen.dart';

import '../sales_journal/screens/compan_sales_page.dart';
import '../sales_journal/screens/sales_page.dart';

class SalesDisplayScreen extends StatefulWidget {
  SalesDisplayScreen({Key? key}) : super(key: key);

  static const routeName = '/SalesDisplayScreen';

  @override
  State<SalesDisplayScreen> createState() => _SalesDisplayScreenState();
}

class _SalesDisplayScreenState extends State<SalesDisplayScreen>
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
    //     width: 250,
    //     height: 44,
    //     alignment: Alignment.center,
    //     child: Text(
    //       'Individual Customer Sales',
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
    //     width: 250,
    //     height: 44,
    //     alignment: Alignment.center,
    //     child: Text(
    //       'Company Sales',
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
        width: 180,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'Individual Customers',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black)),
        ),
      ),
      // text: 'Administration',
    ),
    Tab(
      child: Container(
        width: 180,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'Company Customers',
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
    final expansionHeaderTheme = Theme.of(context).textTheme.headline6;

    return Scaffold(
      drawer: PrimarySideBar(
          controller: controller, expansionHeaderTheme: expansionHeaderTheme),
      appBar: GlobalAppBar(query: query, appbar: AppBar()),
      body: Padding(
        padding: const EdgeInsets.only(top: 18),
        child: SingleChildScrollView(
            child: Column(
          children: [
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
                    'Sales',
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
                  // TransfersJournelScreen(),
                  // CustomerSalesPage(),
                  // SingleChildScrollView(
                  //   child: CompanySalesPage(),
                  // ),
                  SingleChildScrollView(
                    child: CustomersPage(),
                  ),
                  SingleChildScrollView(
                    child: CompanyPage(),
                  )
                  // InventoryAdjustmentScreen(),
                ]),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
