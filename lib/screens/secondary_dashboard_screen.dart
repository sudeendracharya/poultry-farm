// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/screens/main_dash_board.dart';
import 'package:poultry_login_signup/screens/main_drawer_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../infrastructure/screens/firms_page.dart';
import '../items/screens/product_management.dart';
import '../providers/apicalls.dart';
import '../infrastructure/providers/infrastructure_apicalls.dart';
import '../search_widget.dart';
import 'dashboard_default_screen.dart';

import 'notifications_page.dart';

class SecondaryDashBoardScreen extends StatefulWidget {
  SecondaryDashBoardScreen({Key? key}) : super(key: key);

  static const routeName = '/SecondaryDashBoardScreen';

  @override
  State<SecondaryDashBoardScreen> createState() =>
      _SecondaryDashBoardScreenState();
}

class _SecondaryDashBoardScreenState extends State<SecondaryDashBoardScreen> {
  String query = '';
  ScrollController controller = ScrollController();
  ScrollController primaryController = ScrollController();
  ScrollController secondaryController = ScrollController();
  ScrollController tertairyController = ScrollController();

  List firmsList = [];

  var firmId;

  bool firmSelected = false;

  List plantList = [];

  var plantId;

  var plantSelected;
  var firmName;
  var plantName;

  @override
  void initState() {
    super.initState();
    var data = Get.arguments;
    if (data != null) {
      firmId = data['firmId'];
      plantId = data['plantId'];
      firmName = data['firmName'];
      plantName = data['plantName'];
    }

    getFirmAndPlantDetails().then((value) {
      setState(() {});
    });
  }

  TextStyle dateTimestyle() {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14));
  }

  TextStyle primaryCardsTextStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color.fromRGBO(49, 49, 49, 1)),
    );
  }

  TextStyle secondaryCardsPrimaryTextStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: Color.fromRGBO(15, 15, 15, 1)),
    );
  }

  TextStyle secondaryCardsSecondaryTextStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: Color.fromRGBO(103, 103, 103, 1)),
    );
  }

  TextStyle secondaryCardsNumberStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 24,
          color: Color.fromRGBO(68, 68, 68, 1)),
    );
  }

  TextStyle primaryCardsSecondaryTextStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Color.fromRGBO(171, 171, 171, 1)),
    );
  }

  TextStyle primaryCardsNumberStyles() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 20,
          color: Color.fromRGBO(20, 20, 20, 1)),
    );
  }

  TextStyle dialogHeadingPrimaryTextStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: Color.fromRGBO(44, 96, 154, 1)),
    );
  }

  TextStyle dialogHeadingSecondaryTextStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black),
    );
  }

  Future<void> getFirmList() async {
    await Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      await Provider.of<InfrastructureApis>(context, listen: false)
          .getFirmDetails(token)
          .then((value1) {});
    });
  }

  String dateTime = DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now());

  Future<void> getFirmAndPlantDetails() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('FirmAndPlantDetails')) {
      var extratedData = json.decode(prefs.getString('FirmAndPlantDetails')!)
          as Map<String, dynamic>;

      firmName = extratedData['firmName'];
      plantName = extratedData['plantName'];

      // print(extratedData);
    }

    // print(firmName);
    // print(plantName);
  }

  @override
  Widget build(BuildContext context) {
    firmsList = Provider.of<InfrastructureApis>(context).firmDetails;
    plantList = Provider.of<InfrastructureApis>(context).plantDetails;
    if (firmsList.isNotEmpty) {
      // print('object');
    }
    return Scaffold(
      drawer: MainDrawer(controller: controller),
      appBar: AppBar(
        title: const Text('DashBoard Screen'),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          IconButton(
              onPressed: () {
                showGlobalDrawer(
                  context: context,
                  builder: (ctx) => NotificationPage(),
                  direction: AxisDirection.right,
                );
              },
              icon: const Icon(Icons.notifications)),
          const SizedBox(
            width: 6,
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 43.0),
        child: SingleChildScrollView(
          controller: primaryController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 22.0, right: 19),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(text: 'Date Updated : ', style: dateTimestyle()),
                      TextSpan(text: dateTime, style: dateTimestyle()),
                    ]))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 22.0, right: 19),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Get.dialog(
                        //   viewByPlantMethod(),
                        // );
                        // getFirmList().then((value) {

                        // });

                        Get.offAllNamed(MainDashBoardScreen.routeName);
                      },
                      child: Text(
                        'Back to Main Dashboard',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Color.fromRGBO(44, 96, 154, 1),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard: ${firmName},${plantName}',
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    )),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 92,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    controller: secondaryController,
                    children: [
                      Container(
                        width: 201,
                        height: 92,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: const Color.fromRGBO(44, 96, 154, 01),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0, left: 9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Total Birds',
                                        style: primaryCardsTextStyle(),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          '120000',
                                          style: primaryCardsNumberStyles(),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 19.0),
                                    child: Container(
                                        width: 46,
                                        height: 46,
                                        child: CircleAvatar(
                                          child: SizedBox(
                                            width: 36,
                                            height: 28,
                                            child: Image.asset(
                                                'assets/images/dashboard/chicken.png'),
                                          ),
                                          backgroundColor: const Color.fromRGBO(
                                              44, 96, 154, 1),
                                        )),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 9.0),
                                child: Text(
                                  'Updated On 2nd October',
                                  style: primaryCardsSecondaryTextStyle(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 48,
                      ),
                      Container(
                        width: 201,
                        height: 92,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: const Color.fromRGBO(44, 96, 154, 01),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0, left: 9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Total Eggs',
                                        style: primaryCardsTextStyle(),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          '250000',
                                          style: primaryCardsNumberStyles(),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 19.0),
                                    child: Container(
                                        width: 46,
                                        height: 46,
                                        child: CircleAvatar(
                                          child: SizedBox(
                                            width: 36,
                                            height: 28,
                                            child: Image.asset(
                                                'assets/images/dashboard/Egg-Image.png'),
                                          ),
                                          backgroundColor: const Color.fromRGBO(
                                              44, 96, 154, 1),
                                        )),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 9.0),
                                child: Text(
                                  'Updated On 2nd October',
                                  style: primaryCardsSecondaryTextStyle(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 48,
                      ),
                      Container(
                        width: 201,
                        height: 92,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: const Color.fromRGBO(44, 96, 154, 01),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0, left: 9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Batches',
                                        style: primaryCardsTextStyle(),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          '20',
                                          style: primaryCardsNumberStyles(),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 19.0),
                                    child: Container(
                                        width: 46,
                                        height: 46,
                                        child: CircleAvatar(
                                          child: SizedBox(
                                            width: 36,
                                            height: 28,
                                            child: Image.asset(
                                                'assets/images/dashboard/truck.png'),
                                          ),
                                          backgroundColor: const Color.fromRGBO(
                                              44, 96, 154, 1),
                                        )),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 9.0),
                                child: Text(
                                  'Updated On 2nd October',
                                  style: primaryCardsSecondaryTextStyle(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 48,
                      ),
                      Container(
                        width: 201,
                        height: 92,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: const Color.fromRGBO(44, 96, 154, 01),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0, left: 9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Closing Stocks',
                                        style: primaryCardsTextStyle(),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          '30000',
                                          style: primaryCardsNumberStyles(),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 19.0),
                                    child: Container(
                                        width: 46,
                                        height: 46,
                                        child: CircleAvatar(
                                          child: SizedBox(
                                            width: 36,
                                            height: 28,
                                            child: Image.asset(
                                                'assets/images/dashboard/cart.png'),
                                          ),
                                          backgroundColor: const Color.fromRGBO(
                                              44, 96, 154, 1),
                                        )),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 9.0),
                                child: Text(
                                  'Updated On 2nd October',
                                  style: primaryCardsSecondaryTextStyle(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 47.0),
                child: SizedBox(
                    height: 330,
                    width: double.infinity,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      controller: tertairyController,
                      children: [
                        Card(
                          elevation: 5,
                          child: Container(
                            width: 400,
                            height: 330,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 13.0,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Infrastructure',
                                          style:
                                              secondaryCardsPrimaryTextStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25.0, left: 18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          child: CircleAvatar(
                                            child: SizedBox(
                                              width: 44,
                                              height: 35.96,
                                              child: Image.asset(
                                                  'assets/images/dashboard/infrastructure.png'),
                                            ),
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    227, 240, 255, 1),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 50.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 80,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: '20\n',
                                                          style:
                                                              secondaryCardsNumberStyle()),
                                                      TextSpan(
                                                        text: 'Plants',
                                                        style:
                                                            secondaryCardsSecondaryTextStyle(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Container(
                                                width: 80,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: '03\n',
                                                          style:
                                                              secondaryCardsNumberStyle()),
                                                      TextSpan(
                                                        text: 'Users',
                                                        style:
                                                            secondaryCardsSecondaryTextStyle(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Container(
                                                width: 80,
                                                height: 50,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  const Divider(thickness: 1),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Get.toNamed(FirmsPage.routeName);
                                          },
                                          child: Text('View Details',
                                              style:
                                                  secondaryTextButtonStyle()),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Card(
                          elevation: 5,
                          child: Container(
                            width: 400,
                            height: 280,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 13.0,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Inventory',
                                          style:
                                              secondaryCardsPrimaryTextStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25.0, left: 18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          child: CircleAvatar(
                                            child: SizedBox(
                                              width: 44,
                                              height: 35.96,
                                              child: Image.asset(
                                                  'assets/images/dashboard/product-management.png'),
                                            ),
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    227, 240, 255, 1),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 50.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 120,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: '20,000\n',
                                                          style:
                                                              secondaryCardsNumberStyle()),
                                                      TextSpan(
                                                        text: 'Total Birds',
                                                        style:
                                                            secondaryCardsSecondaryTextStyle(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Container(
                                                width: 120,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: '40,000\n',
                                                          style:
                                                              secondaryCardsNumberStyle()),
                                                      TextSpan(
                                                        text: 'Total Eggs',
                                                        style:
                                                            secondaryCardsSecondaryTextStyle(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Container(
                                                width: 120,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: '20%\n',
                                                          style: secondaryCardsNumberStyle()
                                                              .copyWith(
                                                                  color: Colors
                                                                      .red)),
                                                      TextSpan(
                                                        text: 'Total Batches',
                                                        style:
                                                            secondaryCardsSecondaryTextStyle(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  const Divider(thickness: 1),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Get.toNamed(ProductManagementPage
                                                .routeName);
                                          },
                                          child: Text('View Details',
                                              style:
                                                  secondaryTextButtonStyle()),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Card(
                          elevation: 5,
                          child: Container(
                            width: 400,
                            height: 280,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 13.0,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Operations',
                                          style:
                                              secondaryCardsPrimaryTextStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25.0, left: 18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          child: CircleAvatar(
                                            child: SizedBox(
                                              width: 44,
                                              height: 35.96,
                                              child: Image.asset(
                                                  'assets/images/dashboard/users.png'),
                                            ),
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    227, 240, 255, 1),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 50.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 140,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: '04\n',
                                                          style:
                                                              secondaryCardsNumberStyle()),
                                                      TextSpan(
                                                        text:
                                                            'Activity Planning',
                                                        style:
                                                            secondaryCardsSecondaryTextStyle(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Container(
                                                width: 140,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: '50%\n',
                                                          style: secondaryCardsNumberStyle()
                                                              .copyWith(
                                                                  color: Colors
                                                                      .yellow)),
                                                      TextSpan(
                                                        text: 'Sales',
                                                        style:
                                                            secondaryCardsSecondaryTextStyle(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Container(
                                                width: 140,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '3',
                                                        style:
                                                            secondaryCardsNumberStyle(),
                                                      ),
                                                      TextSpan(
                                                        text: 'pending\n',
                                                        style:
                                                            GoogleFonts.roboto(
                                                          textStyle:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromRGBO(
                                                                    165,
                                                                    161,
                                                                    161,
                                                                    1),
                                                          ),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: 'Activity Logs',
                                                        style:
                                                            secondaryCardsSecondaryTextStyle(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  const Divider(thickness: 1),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {},
                                          child: Text('View Details',
                                              style:
                                                  secondaryTextButtonStyle()),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 47.0),
                child: Container(
                    height: 330,
                    width: double.infinity,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      controller: tertairyController,
                      children: [
                        Card(
                          elevation: 5,
                          child: Container(
                            width: 400,
                            height: 280,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 13.0,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Product Management',
                                          style:
                                              secondaryCardsPrimaryTextStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25.0, left: 18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          child: CircleAvatar(
                                            child: SizedBox(
                                              width: 44,
                                              height: 35.96,
                                              child: Image.asset(
                                                  'assets/images/dashboard/product-management.png'),
                                            ),
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    227, 240, 255, 1),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 50.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 120,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: '20\n',
                                                          style:
                                                              secondaryCardsNumberStyle()),
                                                      TextSpan(
                                                        text: 'Total Products',
                                                        style:
                                                            secondaryCardsSecondaryTextStyle(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Container(
                                                width: 120,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: '50\n',
                                                          style:
                                                              secondaryCardsNumberStyle()),
                                                      TextSpan(
                                                        text: 'Sub Products',
                                                        style:
                                                            secondaryCardsSecondaryTextStyle(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Container(
                                                width: 120,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: '40\n',
                                                          style:
                                                              secondaryCardsNumberStyle()),
                                                      TextSpan(
                                                        text: 'Total Batches',
                                                        style:
                                                            secondaryCardsSecondaryTextStyle(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  const Divider(thickness: 1),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Get.toNamed(ProductManagementPage
                                                .routeName);
                                          },
                                          child: Text('View Details',
                                              style:
                                                  secondaryTextButtonStyle()),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Card(
                          elevation: 5,
                          child: Container(
                            width: 400,
                            height: 330,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 13.0,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Logs',
                                          style:
                                              secondaryCardsPrimaryTextStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25.0, left: 18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          child: CircleAvatar(
                                            child: SizedBox(
                                              width: 44,
                                              height: 35.96,
                                              child: Image.asset(
                                                  'assets/images/dashboard/logs.png'),
                                            ),
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    227, 240, 255, 1),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 50.0,
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 150,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '43\n',
                                                        style:
                                                            secondaryCardsNumberStyle(),
                                                      ),
                                                      TextSpan(
                                                        text: 'Total Logs',
                                                        style:
                                                            secondaryCardsSecondaryTextStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Container(
                                                width: 150,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '50\n',
                                                        style:
                                                            secondaryCardsNumberStyle(),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'data to be added',
                                                        style:
                                                            secondaryCardsSecondaryTextStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Container(
                                                width: 150,
                                                height: 50,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: '34\n',
                                                          style:
                                                              secondaryCardsNumberStyle()),
                                                      TextSpan(
                                                        text:
                                                            'data to be added',
                                                        style:
                                                            secondaryCardsSecondaryTextStyle(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  const Divider(thickness: 1),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {},
                                          child: Text('View Details',
                                              style:
                                                  secondaryTextButtonStyle()),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 36.0, bottom: 67),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog viewByPlantMethod() {
  //   plantSelected = false;
  //   return Dialog(
  //     child: StatefulBuilder(
  //       builder: (BuildContext context, setState) {
  //         return Container(
  //           width: 814,
  //           height: firmSelected == false ? 503 : 642,
  //           color: Colors.white,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 65, vertical: 55),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text.rich(
  //                   TextSpan(
  //                     children: [
  //                       TextSpan(
  //                           text: 'Hi UserName,',
  //                           style: dialogHeadingPrimaryTextStyle()),
  //                       TextSpan(
  //                           text: 'Please select the firm',
  //                           style: dialogHeadingPrimaryTextStyle())
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 8,
  //                 ),
  //                 Text(
  //                   'Please select your firm to get proceeded',
  //                   style: dialogHeadingSecondaryTextStyle(),
  //                 ),
  //                 const SizedBox(
  //                   height: 43,
  //                 ),
  //                 Text(
  //                   'Select the firm',
  //                   style: GoogleFonts.roboto(
  //                     textStyle: const TextStyle(
  //                       fontWeight: FontWeight.w700,
  //                       fontSize: 24,
  //                       color: Color.fromRGBO(15, 15, 15, 1),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 24,
  //                 ),
  //                 Align(
  //                   alignment: Alignment.topLeft,
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Container(
  //                         width: 450,
  //                         padding: const EdgeInsets.only(bottom: 12),
  //                         child: Text(
  //                           'Firm Id/Name',
  //                           style: dialogHeadingSecondaryTextStyle(),
  //                         ),
  //                       ),
  //                       Container(
  //                         width: 450,
  //                         height: 36,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(8),
  //                           color: Colors.white,
  //                           border: Border.all(color: Colors.black26),
  //                         ),
  //                         child: Padding(
  //                           padding:
  //                               const EdgeInsets.symmetric(horizontal: 5.0),
  //                           child: DropdownButtonHideUnderline(
  //                             child: DropdownButton(
  //                               value: firmId,
  //                               items: firmsList
  //                                   .map<DropdownMenuItem<String>>((e) {
  //                                 return DropdownMenuItem(
  //                                   child: Text(e['Firm_Name']),
  //                                   value: e['Firm_Name'],
  //                                   onTap: () async {
  //                                     await Provider.of<Apicalls>(context,
  //                                             listen: false)
  //                                         .tryAutoLogin()
  //                                         .then((value) async {
  //                                       var token = Provider.of<Apicalls>(
  //                                               context,
  //                                               listen: false)
  //                                           .token;
  //                                       await Provider.of<InfrastructureApis>(
  //                                               context,
  //                                               listen: false)
  //                                           .getPlantDetails(
  //                                               token, e['Firm_Id'])
  //                                           .then((value1) {
  //                                         setState(() {
  //                                           firmSelected = true;
  //                                         });
  //                                       });
  //                                     });

  //                                     // itemDetails['Product_Id'] =
  //                                     //     e['Product_Category_Id'];
  //                                   },
  //                                 );
  //                               }).toList(),
  //                               hint: Container(
  //                                   width: 404, child: const Text('Select')),
  //                               onChanged: (value) {
  //                                 setState(() {
  //                                   firmId = value as String?;
  //                                 });
  //                               },
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 24,
  //                 ),
  //                 firmSelected == false
  //                     ? SizedBox()
  //                     : Align(
  //                         alignment: Alignment.topLeft,
  //                         child: Column(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Container(
  //                               width: 450,
  //                               padding: const EdgeInsets.only(bottom: 12),
  //                               child: Text(
  //                                 'Plant Id/Name',
  //                                 style: dialogHeadingSecondaryTextStyle(),
  //                               ),
  //                             ),
  //                             Container(
  //                               width: 450,
  //                               height: 36,
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(8),
  //                                 color: Colors.white,
  //                                 border: Border.all(color: Colors.black26),
  //                               ),
  //                               child: Padding(
  //                                 padding: const EdgeInsets.symmetric(
  //                                     horizontal: 5.0),
  //                                 child: DropdownButtonHideUnderline(
  //                                   child: DropdownButton(
  //                                     value: plantId,
  //                                     items: plantList
  //                                         .map<DropdownMenuItem<String>>((e) {
  //                                       return DropdownMenuItem(
  //                                         child: Text(e['Plant_Name']),
  //                                         value: e['Plant_Name'],
  //                                         onTap: () {
  //                                           setState(() {
  //                                             plantSelected = true;
  //                                           });
  //                                           // itemDetails['Product_Id'] =
  //                                           //     e['Product_Category_Id'];
  //                                         },
  //                                       );
  //                                     }).toList(),
  //                                     hint: Container(
  //                                         width: 404,
  //                                         child: const Text('Select')),
  //                                     onChanged: (value) {
  //                                       setState(() {
  //                                         plantId = value as String?;
  //                                       });
  //                                     },
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                 SizedBox(height: firmSelected == false ? 103 : 180),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () {
  //                         Get.back();
  //                       },
  //                       child: Container(
  //                         width: 200,
  //                         height: 48,
  //                         decoration: BoxDecoration(
  //                           border: Border.all(
  //                             color: const Color.fromRGBO(44, 96, 154, 1),
  //                           ),
  //                           borderRadius: BorderRadius.circular(4),
  //                         ),
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           'Cancel',
  //                           style: GoogleFonts.roboto(
  //                             textStyle: const TextStyle(
  //                               fontWeight: FontWeight.w500,
  //                               fontSize: 18,
  //                               color: Color.fromRGBO(44, 96, 154, 1),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       width: 24,
  //                     ),
  //                     Container(
  //                       width: 200,
  //                       height: 48,
  //                       child: ElevatedButton(
  //                         onPressed: () {},
  //                         style: ButtonStyle(
  //                           backgroundColor: plantSelected == false
  //                               ? MaterialStateProperty.all(
  //                                   const Color.fromRGBO(130, 130, 130, 1),
  //                                 )
  //                               : MaterialStateProperty.all(
  //                                   const Color.fromRGBO(44, 96, 154, 1),
  //                                 ),
  //                         ),
  //                         child: Text(
  //                           'Continue',
  //                           style: GoogleFonts.roboto(
  //                             textStyle: const TextStyle(
  //                               fontWeight: FontWeight.w500,
  //                               fontSize: 18,
  //                               color: Color.fromRGBO(255, 254, 254, 1),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  TextStyle secondaryTextButtonStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.underline,
        fontSize: 14,
        color: Color.fromRGBO(68, 68, 68, 1),
      ),
    );
  }
}
