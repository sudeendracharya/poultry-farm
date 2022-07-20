import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/inventory_adjustment/screens/egg_grading_page.dart';
import 'package:poultry_login_signup/inventory_adjustment/screens/egg_collection_page.dart';
import 'package:poultry_login_signup/inventory_adjustment/screens/inventory_adjustment_journal.dart';
import 'package:poultry_login_signup/inventory_adjustment/screens/mortality_page.dart';

import '../../inventory_adjustment/screens/bird_grading_page.dart';

class InventoryAdjustmentScreen extends StatefulWidget {
  InventoryAdjustmentScreen({Key? key}) : super(key: key);

  @override
  State<InventoryAdjustmentScreen> createState() =>
      _InventoryAdjustmentScreenState();
}

class _InventoryAdjustmentScreenState extends State<InventoryAdjustmentScreen>
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
        width: 280,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'Inventory Adjustment Journal',
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
    // Tab(
    //   child: Container(
    //     width: 200,
    //     height: 44,
    //     alignment: Alignment.center,
    //     child: Text(
    //       'Bird Grading',
    //       style: GoogleFonts.roboto(
    //         textStyle: const TextStyle(
    //           fontWeight: FontWeight.w500,
    //           fontSize: 16,
    //           color: Colors.black,
    //         ),
    //       ),
    //     ),
    //   ),
    //   // text: 'Administration',
    // ),
    Tab(
      child: Container(
        width: 120,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'Mortality',
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
        width: 160,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'Egg Collection',
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
        width: 180,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'Egg Grading',
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
              top: 29.0,
              bottom: 00,
              left: 43.0,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
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
              height: MediaQuery.of(context).size.height * 0.7,
              child: TabBarView(controller: _tabController, children: [
                SingleChildScrollView(
                  child: InventoryAdjustmentJournal(),
                ),
                // SingleChildScrollView(
                //   child: BirdGrading(),
                // ),
                SingleChildScrollView(
                  child: Mortalitypage(),
                ),
                SingleChildScrollView(
                  child: EggCollection(),
                ),
                SingleChildScrollView(
                  child: EggGrading(),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
