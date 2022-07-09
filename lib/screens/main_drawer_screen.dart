import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/items/screens/product_management_secondary.dart';
import 'package:poultry_login_signup/items/screens/product_management_secondary_bar.dart';
import 'package:poultry_login_signup/screens/dashboard_default_screen.dart';
import 'package:provider/provider.dart';

import '../colors.dart';
import '../items/screens/product_management.dart';
import '../main.dart';
import '../providers/apicalls.dart';
import 'dashboard_screen.dart';
import 'firm_and_plant_selection_page.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ScrollController controller;

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
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
    final expansionHeaderTheme = Theme.of(context).textTheme.headline6;
    var size = MediaQuery.of(context).size;
    return loading == true
        ? const SizedBox()
        : Theme(
            data: Theme.of(context).copyWith(
                canvasColor: const Color.fromRGBO(44, 96, 154, 1),
                dividerColor: Colors.transparent),
            child: SizedBox(
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // const SizedBox(
                              //     width: 46,
                              //     height: 46,
                              //     child: CircleAvatar(
                              //       backgroundColor:
                              //           Color.fromRGBO(196, 196, 196, 1),
                              //     )),
                              const SizedBox(width: 18),
                              Text(
                                'Hi ${extratedData['User_Name'].toString().toUpperCase()}',
                                style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // extratedData['Role_Name'] == 'Admin'
                        //     ?
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, bottom: 24),
                          child: AdminManagement(),
                        ),
                        // : const SizedBox(),
                        // InfraManagementDefault(),
                        // extratedData['Role_Name'] == 'Admin'
                        //     ?
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 24.0, left: 20),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                  ProductManagementSecondaryBar.routeName);
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
                                  style: expansionHeaderTheme,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: OperationsDropDown(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: LogsDropDown(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: InventoryDropDown(),
                        ),
                        // BreedManagement(),
                        // BatchPlanManagemnt(),
                        // RecordsManagement(),
                        // JournalManagement(),

                        // ListTile(
                        //   title: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       const Icon(
                        //         Icons.settings,
                        //         color: Color.fromRGBO(159, 205, 255, 1),
                        //       ),
                        //       const SizedBox(
                        //         width: 14.67,
                        //       ),
                        //       TextButton(
                        //           onPressed: () {},
                        //           child: Text(
                        //             'Settings',
                        //             style:
                        //                 Theme.of(context).textTheme.headline6,
                        //           )),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 15),
                        //   child: ListTile(
                        //     title: const Text('Firm Plant Selection'),
                        //     trailing: const Icon(Icons.business),
                        //     onTap: () {
                        //       Get.to(() => FirmPlantSelectionPage());
                        //     },
                        //   ),
                        // ),
                        SizedBox(
                          height: size.height * 0.45,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 24.0, left: 10),
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
                                  width: 23,
                                  height: 23,
                                  color: ProjectColors.drawerIconColor,
                                ),
                                const SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  'Log Out',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 15),
                        //   child: ListTile(
                        //     title: const Text('Log Out'),
                        //     trailing: const Icon(Icons.business),
                        //     onTap: () {
                        //       // html.window.open('http://localhost:53636/#/', '_self');
                        //       Provider.of<Apicalls>(context, listen: false)
                        //           .tryAutoLogin()
                        //           .then((value) {
                        //         if (value == true) {
                        //           var token = Provider.of<Apicalls>(context,
                        //                   listen: false)
                        //               .token;
                        //           Provider.of<Apicalls>(
                        //             context,
                        //             listen: false,
                        //           ).logOut(token);
                        //           Provider.of<Apicalls>(
                        //             context,
                        //             listen: false,
                        //           ).logoutLocally();

                        //           Get.offAllNamed(MyHomePage.routeName);
                        //           // Modular.toNamed.navigateAndRemoveUntil(MyHomePage.routeName,
                        //           //     (Route<dynamic> route) => false);
                        //         }
                        //       });
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
