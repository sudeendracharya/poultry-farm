import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key? key}) : super(key: key);

  static const routeName = '/NotificationPage';

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // var index = Get.arguments;

    _tabController =
        TabController(vsync: this, length: myTabs.length, initialIndex: 0);

    super.initState();
  }

  static List<Widget> myTabs = [
    Tab(
      child: Container(
        width: 120,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'Notifications',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black)),
        ),
      ),
      // text: 'Administration',
    ),
    Tab(
      child: Container(
        width: 120,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          'Reminders',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black)),
        ),
      ),
      // text: 'Administration',
    ),
    // IconButton(onPressed: () {}, icon: Icon(Icons.close))
  ];
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var appBarHeight = AppBar().preferredSize.height;
    return Padding(
      padding: EdgeInsets.only(top: appBarHeight),
      child: Container(
        width: 450,
        height: height - appBarHeight,
        child: Drawer(
          child: Theme(
            data: ThemeData(
              colorScheme: Theme.of(context)
                  .colorScheme
                  .copyWith(primary: const Color.fromRGBO(44, 95, 154, 1)),
            ),
            child: Column(
              children: [
                Container(
                  width: 450,
                  // height: height - appBarHeight,
                  child: Row(
                    children: [
                      Expanded(
                        child: TabBar(
                          automaticIndicatorColorAdjustment: true,
                          enableFeedback: true,
                          indicatorColor: Colors.black,
                          indicatorWeight: 2,
                          controller: _tabController,
                          tabs: myTabs,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 450,
                  height: height - appBarHeight - 49,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Center(
                        child: Text('Notifications'),
                      ),
                      Center(
                        child: Text('Reminders'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
