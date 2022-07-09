import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/items/screens/product_management_secondary.dart';
import 'package:poultry_login_signup/items/screens/product_sub_type.dart';
import 'package:poultry_login_signup/items/screens/product_type.dart';

import '../../screens/global_app_bar.dart';
import '../../screens/main_drawer_screen.dart';
import '../../screens/secondary_dashboard_screen.dart';

class ProductManagementSecondaryBar extends StatefulWidget {
  ProductManagementSecondaryBar({Key? key}) : super(key: key);
  static const routeName = '/ProductManagementSecondaryBar';
  @override
  State<ProductManagementSecondaryBar> createState() =>
      _ProductManagementSecondaryBarState();
}

class _ProductManagementSecondaryBarState
    extends State<ProductManagementSecondaryBar>
    with SingleTickerProviderStateMixin {
  List<bool> _isOpen = [false];
  bool isOpened = false;

  List firmData = [];
  List plantData = [];
  var route = false;
  var query = '';
  ScrollController controller = ScrollController();

  @override
  void initState() {
    var index = Get.arguments;

    _tabController = TabController(
        vsync: this, length: myTabs.length, initialIndex: index ?? 0);

    super.initState();
  }

  static List<Tab> myTabs = <Tab>[
    Tab(
      child: Container(
        width: 166,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'Product',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black)),
        ),
      ),
      // text: 'Administration',
    ),
    // Tab(
    //   child: Container(
    //     width: 67,
    //     height: 44,
    //     child: Text(
    //       'Users',
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
        width: 222,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'Product Type',
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
          'Product Sub-Type',
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

    return WillPopScope(
      onWillPop: () async {
        // Get.toNamed(ProductionDashBoardScreen.routeName);
        return true;
      },
      child: Scaffold(
          drawer: MainDrawer(controller: controller),
          appBar: GlobalAppBar(query: query, appbar: AppBar()),
          body: Padding(
            padding: const EdgeInsets.only(top: 18),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                          'Product Management',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: const Color.fromRGBO(0, 0, 0, 0.5)),
                        ),
                      ),
                    ],
                  ),
                  // BannerNotifications(),
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
                        SingleChildScrollView(
                            child: ProductManagementSecondary()),
                        SingleChildScrollView(child: ProductTypePage()),
                        SingleChildScrollView(child: ProductSubCategory()),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          )
          // Center(
          //     child: Container(
          //   width: 500,
          //   height: 500,
          //   child: firmData.isEmpty
          //       ? Text('Loading')
          //       : ListView.builder(
          //           itemCount: firmData.length,
          //           itemBuilder: (BuildContext context, int index) {
          //             return DisplayFirmDetails(
          //               firmData: firmData,
          //               index: index,
          //               key: UniqueKey(),
          //               plantData: plantData,
          //             );
          //           },
          //         ),
          // )),
          ),
    );
  }
}
