import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/infrastructure/screens/warehouse_category_screen.dart';
import 'package:poultry_login_signup/infrastructure/screens/warehouse_sub_category_screen_details.dart';

import '../infrastructure/screens/warehousemanagement_page.dart';

class WareHouseDataScreen extends StatefulWidget {
  WareHouseDataScreen({Key? key}) : super(key: key);
  static const routeName = '/WareHouseDataScreen';
  @override
  State<WareHouseDataScreen> createState() => _WareHouseDataScreenState();
}

class _WareHouseDataScreenState extends State<WareHouseDataScreen>
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
        width: 166,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'WareHouse Details',
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
          'WareHouse Category',
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
        width: 190,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'WareHouse Sub Category',
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
    return Container(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 30,
              bottom: 00,
              left: 43.0,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                margin: const EdgeInsets.only(bottom: 0),
                height: 40,
                child: TabBar(
                  automaticIndicatorColorAdjustment: true,
                  enableFeedback: true,
                  indicatorColor: Colors.white,
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
              height: MediaQuery.of(context).size.height * 0.8,
              child: TabBarView(controller: _tabController, children: [
                SingleChildScrollView(child: WareHouseManagementPage()),
                SingleChildScrollView(child: WarehouseCategoryScreen()),
                SingleChildScrollView(
                    child: WarehouseSubCategoryScreenDetails()),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
