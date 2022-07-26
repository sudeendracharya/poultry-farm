library admin;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/admin/screens/user.dart';
import 'package:poultry_login_signup/admin/screens/user_roles.dart';
import 'package:poultry_login_signup/main.dart';

import '../../screens/global_app_bar.dart';
import '../../screens/main_dash_board.dart';
import '../../screens/main_drawer_screen.dart';
import '../../screens/secondary_dashboard_screen.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  static const routeName = '/Admin';

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> with SingleTickerProviderStateMixin {
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

  Future<void> getfirm() async {
    query = await getFirmName();
  }

  @override
  void initState() {
    var index = Get.arguments;
    getfirm();
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
          'Users',
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
        width: 100,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'Roles',
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
        controller: controller,
        expansionHeaderTheme: expansionHeaderTheme,
      ),
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
                    'Users',
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
                child: TabBarView(controller: _tabController, children: const [
                  SingleChildScrollView(
                    child: User(),
                  ),
                  SingleChildScrollView(
                    child: UserRoles(),
                  ),
                ]),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
