import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/screens/firm_and_plant_selection_page.dart';
import 'package:poultry_login_signup/screens/main_drawer_screen.dart';

import '../search_widget.dart';

class ProductionDashBoardScreen extends StatefulWidget {
  ProductionDashBoardScreen({Key? key}) : super(key: key);

  static const routeName = '/ProductionDashBoardScreen';

  @override
  _ProductionDashBoardScreenState createState() =>
      _ProductionDashBoardScreenState();
}

class _ProductionDashBoardScreenState extends State<ProductionDashBoardScreen> {
  ScrollController controller = ScrollController();

  String query = '';

  TextStyle headerStyle() {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24));
  }

  TextStyle tableHeaderStyle() {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18));
  }

  TextStyle tableDataStyle() {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24));
  }

  TextStyle buttonStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          decoration: TextDecoration.underline,
          color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(FirmPlantSelectionPage.routeName);
        return true;
      },
      child: Scaffold(
        drawer: MainDrawer(controller: controller),
        appBar: AppBar(
          title: const Text('Firm Name'),
          backgroundColor: Theme.of(context).backgroundColor,
          actions: [
            Container(
                width: 216,
                height: 36,
                child: SearchWidget(
                    text: query, onChanged: (value) {}, hintText: 'Search')),
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
            const SizedBox(
              width: 6,
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 35),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: InteractiveViewer(
                alignPanAxis: true,
                // alignPanAxis: true,
                constrained: false,
                scaleEnabled: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'DashBoard',
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 36),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Row(
                            children: [
                              Card(
                                elevation: 5,
                                child: Container(
                                  width: 400,
                                  height: 280,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18.0,
                                          top: 13,
                                        ),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Infrastructure',
                                                style: headerStyle(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18.0),
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 100,
                                                height: 100,
                                                child: CircleAvatar(
                                                  child: SizedBox(
                                                    width: 36,
                                                    height: 28,
                                                    child: Image.asset(
                                                        'assets/images/production/infrastructure.png'),
                                                  ),
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          227, 240, 255, 1),
                                                )),
                                            const SizedBox(
                                              width: 82,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '0',
                                                  style: tableDataStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Firms',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                ),
                                                Text(
                                                  '0',
                                                  style: tableDataStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Plants',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                ),
                                                Text(
                                                  '0',
                                                  style: tableDataStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Users',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                        thickness: 1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'View Details',
                                                style: buttonStyle(),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 42,
                              ),
                              Card(
                                elevation: 5,
                                child: Container(
                                  width: 400,
                                  height: 280,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18.0,
                                          top: 13,
                                        ),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Inventory',
                                                style: headerStyle(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18.0),
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 100,
                                                height: 100,
                                                child: CircleAvatar(
                                                  child: SizedBox(
                                                    width: 36,
                                                    height: 28,
                                                    child: Image.asset(
                                                        'assets/images/production/Shopping_cart.png'),
                                                  ),
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          227, 240, 255, 1),
                                                )),
                                            const SizedBox(
                                              width: 82,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '0',
                                                  style: tableDataStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Total Birds',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                ),
                                                Text(
                                                  '0',
                                                  style: tableDataStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Total Eggs',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                ),
                                                Text('0%',
                                                    style: GoogleFonts.roboto(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 20,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        218,
                                                                        34,
                                                                        34,
                                                                        1)))),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Mortality Rate',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                        thickness: 1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'View Details',
                                                style: buttonStyle(),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 42,
                              ),
                              Card(
                                elevation: 5,
                                child: Container(
                                  width: 400,
                                  height: 280,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18.0,
                                          top: 13,
                                        ),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Operations',
                                                style: headerStyle(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18.0),
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 100,
                                                height: 100,
                                                child: CircleAvatar(
                                                  child: SizedBox(
                                                    width: 36,
                                                    height: 28,
                                                    child: Image.asset(
                                                        'assets/images/production/billing.png'),
                                                  ),
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          227, 240, 255, 1),
                                                )),
                                            const SizedBox(
                                              width: 82,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '0',
                                                  style: tableDataStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Activity Planning',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                ),
                                                Text(
                                                  '0%',
                                                  style: GoogleFonts.roboto(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 24,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      242,
                                                                      194,
                                                                      21,
                                                                      1))),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Sales',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                ),
                                                Text(
                                                  '0',
                                                  style: tableDataStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Activity Logs',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                        thickness: 1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'View Details',
                                                style: buttonStyle(),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: [
                              Card(
                                elevation: 5,
                                child: Container(
                                  width: 400,
                                  height: 280,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18.0,
                                          top: 13,
                                        ),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Product Management',
                                                style: headerStyle(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18.0),
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 100,
                                                height: 100,
                                                child: CircleAvatar(
                                                  child: SizedBox(
                                                    width: 36,
                                                    height: 28,
                                                    child: Image.asset(
                                                        'assets/images/production/inventory_chart.png'),
                                                  ),
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          227, 240, 255, 1),
                                                )),
                                            const SizedBox(
                                              width: 82,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '0',
                                                  style: tableDataStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Total Products',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                ),
                                                Text(
                                                  '0',
                                                  style: tableDataStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Sub Products',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                ),
                                                Text(
                                                  '0',
                                                  style: tableDataStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Total Batches',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                        thickness: 1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'View Details',
                                                style: buttonStyle(),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 42,
                              ),
                              Card(
                                elevation: 5,
                                child: Container(
                                  width: 400,
                                  height: 280,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18.0,
                                          top: 13,
                                        ),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Logs',
                                                style: headerStyle(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18.0),
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 100,
                                                height: 100,
                                                child: CircleAvatar(
                                                  child: SizedBox(
                                                    width: 36,
                                                    height: 28,
                                                    child: Image.asset(
                                                        'assets/images/production/system_check.png'),
                                                  ),
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          227, 240, 255, 1),
                                                )),
                                            const SizedBox(
                                              width: 82,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '0',
                                                  style: tableDataStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Total Logs',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                ),
                                                Text(
                                                  '0',
                                                  style: tableDataStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Data to be added',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                ),
                                                Text(
                                                  '0',
                                                  style: tableDataStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Data to be added',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                        thickness: 1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'View Details',
                                                style: buttonStyle(),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 42,
                              ),
                              Card(
                                elevation: 5,
                                child: Container(
                                  width: 400,
                                  height: 280,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18.0,
                                          top: 13,
                                        ),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Tasks',
                                                style: headerStyle(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18.0),
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 100,
                                                height: 100,
                                                child: CircleAvatar(
                                                  child: SizedBox(
                                                    width: 36,
                                                    height: 28,
                                                    child: Image.asset(
                                                        'assets/images/production/calender.png'),
                                                  ),
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          227, 240, 255, 1),
                                                )),
                                            const SizedBox(
                                              width: 82,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '0',
                                                  style: tableDataStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'Total tasks',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                ),
                                                Text(
                                                  '0',
                                                  style: tableDataStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: Text(
                                                    'pending',
                                                    style: tableHeaderStyle(),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                          Icons.add_circle,
                                                          color: Color.fromRGBO(
                                                              227, 240, 255, 1),
                                                        )),
                                                    Text(
                                                      'Add Tasks',
                                                      style: tableHeaderStyle(),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                        thickness: 1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'View Details',
                                                style: buttonStyle(),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
