import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/admin/screens/admin.dart';
import 'package:poultry_login_signup/colors.dart';
import 'package:poultry_login_signup/items/screens/productmanagement_primary_bar.dart';
import 'package:poultry_login_signup/screens/dashboard_default_screen.dart';
import 'package:poultry_login_signup/screens/dashboard_screen.dart';
import 'package:poultry_login_signup/screens/sales_screen.dart';

import 'package:poultry_login_signup/screens/secondary_dashboard_screen.dart';
import 'package:poultry_login_signup/transfer_journal/screens/transfers_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../infrastructure/screens/firms_page.dart';
import '../items/screens/product_management.dart';
import '../main.dart';
import '../providers/apicalls.dart';
import '../infrastructure/providers/infrastructure_apicalls.dart';
import '../search_widget.dart';
import 'notifications_page.dart';
import 'package:intl/intl.dart';

class MainDashBoardScreen extends StatefulWidget {
  MainDashBoardScreen({Key? key}) : super(key: key);

  static const routeName = '/MainDashBoardScreen';

  @override
  State<MainDashBoardScreen> createState() => _MainDashBoardScreenState();
}

class _MainDashBoardScreenState extends State<MainDashBoardScreen> {
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

  bool loading = true;

  var extratedData;

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

  @override
  void initState() {
    getPermission('User_Name').then((value) {
      extratedData = value;
    });
    getFirmList().then((value) {
      dateTime = DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now());
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    firmsList = Provider.of<InfrastructureApis>(context).firmDetails;
    plantList = Provider.of<InfrastructureApis>(context).plantDetails;
    final expansionHeaderTheme = Theme.of(context).textTheme.headline6;
    final expansionDataTheme = Theme.of(context).textTheme.headline5;
    if (firmsList.isNotEmpty) {}
    return Scaffold(
      drawer: PrimarySideBar(
          controller: controller, expansionHeaderTheme: expansionHeaderTheme),
      appBar: AppBar(
        title: const Text('Main DashBoard Screen'),
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
                        Get.dialog(
                          viewByPlantMethod(),
                        );
                        // getFirmList().then((value) {

                        // });
                      },
                      child: Text(
                        'View by Firm',
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
                    'Dashboard',
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
                                              right: 100.0),
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
                                              right: 100.0),
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
                                          'Users',
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
                                              right: 100.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 80,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: '43\n',
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
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: '50\n',
                                                          style:
                                                              secondaryCardsNumberStyle()),
                                                      TextSpan(
                                                        text: 'Roles',
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
                                            Get.toNamed(Admin.routeName);
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
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 36.0, bottom: 67),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                                      'Logs',
                                      style: secondaryCardsPrimaryTextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 25.0, left: 18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                        backgroundColor: const Color.fromRGBO(
                                            227, 240, 255, 1),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 100.0),
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
                                                          secondaryCardsNumberStyle()),
                                                  TextSpan(
                                                    text: 'Total Logs',
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
                                            width: 150,
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: '50\n',
                                                      style:
                                                          secondaryCardsNumberStyle()),
                                                  TextSpan(
                                                    text: 'data to be added',
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
                                                    text: 'data to be added',
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
                                          style: secondaryTextButtonStyle()),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Dialog viewByPlantMethod() {
    plantSelected = false;
    firmSelected = false;
    firmId = null;
    var selectedPlantName;
    var selectedFirmName;
    var selectedFirmId;
    var selectedPlantId;
    return Dialog(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            width: 814,
            height: firmSelected == false ? 510 : 510,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 65, vertical: 55),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text:
                                    'Hi ${extratedData['User_Name'] ?? 'User'},',
                                style: dialogHeadingPrimaryTextStyle()),
                            TextSpan(
                                text: ' Please select the firm',
                                style: dialogHeadingPrimaryTextStyle())
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.cancel_outlined),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Please select your firm to get proceeded',
                    style: dialogHeadingSecondaryTextStyle(),
                  ),
                  const SizedBox(
                    height: 43,
                  ),
                  Text(
                    'Select the firm',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Color.fromRGBO(15, 15, 15, 1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 450,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            'Firm Id/Name',
                            style: dialogHeadingSecondaryTextStyle(),
                          ),
                        ),
                        Container(
                          width: 450,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: firmId,
                                items: firmsList
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Firm_Name'],
                                    onTap: () async {
                                      setState(() {
                                        firmSelected = true;
                                        selectedFirmName = e['Firm_Name'];
                                        selectedFirmId = e['Firm_Id'];
                                      });

                                      // itemDetails['Product_Id'] =
                                      //     e['Product_Category_Id'];
                                    },
                                    child: Text(e['Firm_Name']),
                                  );
                                }).toList(),
                                hint: Container(
                                    width: 404, child: const Text('Select')),
                                onChanged: (value) {
                                  setState(() {
                                    firmId = value as String?;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 24,
                  // ),
                  // firmSelected == false
                  //     ? const SizedBox()
                  //     : Align(
                  //         alignment: Alignment.topLeft,
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             Container(
                  //               width: 450,
                  //               padding: const EdgeInsets.only(bottom: 12),
                  //               child: Text(
                  //                 'Plant Id/Name',
                  //                 style: dialogHeadingSecondaryTextStyle(),
                  //               ),
                  //             ),
                  //             Container(
                  //               width: 450,
                  //               height: 36,
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(8),
                  //                 color: Colors.white,
                  //                 border: Border.all(color: Colors.black26),
                  //               ),
                  //               child: Padding(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 5.0),
                  //                 child: DropdownButtonHideUnderline(
                  //                   child: DropdownButton(
                  //                     value: plantId,
                  //                     items: plantList
                  //                         .map<DropdownMenuItem<String>>((e) {
                  //                       return DropdownMenuItem(
                  //                         child: Text(e['Plant_Name']),
                  //                         value: e['Plant_Name'],
                  //                         onTap: () {
                  //                           setState(() {
                  //                             plantSelected = true;
                  //                             selectedPlantName =
                  //                                 e['Plant_Name'];
                  //                             selectedPlantId = e['Plant_Id'];
                  //                           });
                  //                           // itemDetails['Product_Id'] =
                  //                           //     e['Product_Category_Id'];
                  //                         },
                  //                       );
                  //                     }).toList(),
                  //                     hint: Container(
                  //                         width: 404,
                  //                         child: const Text('Select')),
                  //                     onChanged: (value) {
                  //                       setState(() {
                  //                         plantId = value as String?;
                  //                       });
                  //                     },
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  SizedBox(height: firmSelected == false ? 103 : 103),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: 200,
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromRGBO(44, 96, 154, 1),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Color.fromRGBO(44, 96, 154, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Container(
                        width: 200,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            if (prefs.containsKey('FirmAndPlantDetails')) {
                              prefs.remove('FirmAndPlantDetails');
                            }
                            final userData = json.encode(
                              {
                                'FirmId': selectedFirmId,
                                'PlantId': selectedPlantId,
                                'firmName': selectedFirmName,
                                'plantName': selectedPlantName,
                              },
                            );
                            prefs.setString('FirmAndPlantDetails', userData);
                            clearDatas(context);
                            Get.toNamed(SecondaryDashBoardScreen.routeName,
                                arguments: {
                                  'plantName': selectedPlantName,
                                  'plantId': selectedPlantId,
                                  'firmName': selectedFirmName,
                                  'firmId': selectedFirmId
                                });
                          },
                          style: ButtonStyle(
                            backgroundColor: firmSelected == false
                                ? MaterialStateProperty.all(
                                    const Color.fromRGBO(130, 130, 130, 1),
                                  )
                                : MaterialStateProperty.all(
                                    const Color.fromRGBO(44, 96, 154, 1),
                                  ),
                          ),
                          child: Text(
                            'Continue',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Color.fromRGBO(255, 254, 254, 1),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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

class PrimarySideBar extends StatefulWidget {
  const PrimarySideBar({
    Key? key,
    required this.controller,
    required this.expansionHeaderTheme,
  }) : super(key: key);

  final ScrollController controller;
  final TextStyle? expansionHeaderTheme;

  @override
  State<PrimarySideBar> createState() => _PrimarySideBarState();
}

class _PrimarySideBarState extends State<PrimarySideBar> {
  var extratedData;
  bool loading = true;
  @override
  void initState() {
    getPermission('User_Name').then((value) {
      extratedData = value;

      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: const Color.fromRGBO(44, 96, 154, 1),
          dividerColor: Colors.transparent),
      child: loading == true
          ? const SizedBox()
          : SizedBox(
              width: 325,
              child: Drawer(
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: ListView(
                      controller: widget.controller,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          height: 30,
                          padding: const EdgeInsets.only(left: 25),
                          color: Theme.of(context).backgroundColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 18),
                              Text(
                                'Hi ${extratedData['User_Name'].toString().toUpperCase()}',
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 38.0, bottom: 24, left: 20),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(FirmsPage.routeName);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 16,
                                  height: 16,
                                  child: const Icon(
                                    Icons.person,
                                    color: Color.fromRGBO(159, 205, 255, 1),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  'Infrastructure',
                                  style: widget.expansionHeaderTheme,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // : const SizedBox(),
                        const SizedBox(
                          height: 15,
                        ),
                        // InfraManagementDefault(),
                        // extratedData['Role_Name'] == 'Admin'
                        //     ?
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 24.0, left: 20),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                  ProductManagementPrimaryBar.routeName);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/Product_Icon.png',
                                  width: 22,
                                  height: 17.98,
                                ),
                                const SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  'Product Management',
                                  style: widget.expansionHeaderTheme,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // : const SizedBox(),
                        const SizedBox(
                          height: 15,
                        ),
                        // extratedData['Role_Name'] == 'Admin'
                        // ?
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 15.0, left: 20),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(Admin.routeName);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/people.png',
                                  width: 22,
                                  height: 17.98,
                                  color: ProjectColors.drawerIconColor,
                                ),
                                const SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  'Users',
                                  style: widget.expansionHeaderTheme,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // extratedData['Role_Name'] == 'Admin'
                        // ?
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 15.0, left: 20),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(TransfersJournelScreen.routeName);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/people.png',
                                  width: 22,
                                  height: 17.98,
                                  color: ProjectColors.drawerIconColor,
                                ),
                                const SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  'Transfers',
                                  style: widget.expansionHeaderTheme,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // : const SizedBox(),
                        const SizedBox(
                          height: 15,
                        ),
                        // Padding(
                        //     padding: const EdgeInsets.only(bottom: 24.0),
                        //     child: LogsDropDown()),
                        // const SizedBox(
                        //   height: 15,
                        // ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 24.0, left: 20),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(SalesDisplayScreen.routeName);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/dashboard/logs.png',
                                  width: 22,
                                  height: 17.98,
                                  color: ProjectColors.drawerIconColor,
                                ),
                                const SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  'Customers',
                                  style: widget.expansionHeaderTheme,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.44,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: GestureDetector(
                            onTap: () {
                              Provider.of<Apicalls>(context, listen: false)
                                  .tryAutoLogin()
                                  .then((value) {
                                if (value == true) {
                                  var token = Provider.of<Apicalls>(context,
                                          listen: false)
                                      .token;
                                  Provider.of<Apicalls>(
                                    context,
                                    listen: false,
                                  ).logOut(token);
                                  Provider.of<Apicalls>(
                                    context,
                                    listen: false,
                                  ).logoutLocally();

                                  Get.offAllNamed(MyHomePage.routeName);
                                  // Modular.toNamed.navigateAndRemoveUntil(MyHomePage.routeName,
                                  //     (Route<dynamic> route) => false);
                                }
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/logout.png',
                                  width: 22,
                                  height: 17.98,
                                  color: ProjectColors.drawerIconColor,
                                ),
                                const SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  'Log Out',
                                  style: widget.expansionHeaderTheme,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
