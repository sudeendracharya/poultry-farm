import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/breed_info/screens/bird_age_group.dart';
import 'package:poultry_login_signup/breed_info/screens/breed_page.dart';
import 'package:poultry_login_signup/breed_info/screens/breed_version.dart';

import '../planning/screens/activity_planning_page.dart';
import '../planning/screens/medication_planning_page.dart';
import '../planning/screens/vaccinationplanning_page.dart';

class ReferenceDataScreen extends StatefulWidget {
  ReferenceDataScreen({Key? key}) : super(key: key);

  static const routeName = '/ReferenceDataScreen';

  @override
  State<ReferenceDataScreen> createState() => _ReferenceDataScreenState();
}

class _ReferenceDataScreenState extends State<ReferenceDataScreen>
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
          'Activity Plan',
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
          'Vaccination Plan',
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
          'Medication Plan',
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
          'Breed',
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
          'Breed Version',
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
          'Bird Age Grouping',
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
                SingleChildScrollView(child: ActivityPlanningPage()),
                SingleChildScrollView(child: VaccinationPlanningPage()),
                SingleChildScrollView(child: MedicationPlanningPage()),
                SingleChildScrollView(child: BreedPage()),
                SingleChildScrollView(child: BreedVersion()),
                SingleChildScrollView(child: BirdAgeGroup()),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
