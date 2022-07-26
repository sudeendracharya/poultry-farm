import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:poultry_login_signup/packages/infrastructure/lib/infrastructure.dart';
// import 'package:poultry_login_signup/packages/breed_info/lib/breed_info.dart';
// import 'package:poultry_login_signup/packages/items/lib/items.dart';
// import 'package:poultry_login_signup/packages/batch_plan/lib/batch_plan.dart';
// import 'package:poultry_login_signup/packages/activity_plan/lib/activity_plan.dart';
// import 'package:poultry_login_signup/packages/customer_sales_record/lib/customer_sales_record.dart';
// import 'package:poultry_login_signup/packages/journal/lib/journal.dart';
// import 'package:poultry_login_signup/packages/admin/lib/admin.dart';
// import 'package:poultry_login_signup/packages/egg_collection/lib/egg_collection.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/providers/dashboard_apicalls.dart';
import 'package:poultry_login_signup/screens/dashboard_default_screen.dart';

import 'package:poultry_login_signup/widgets/inventory_search_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../batch_plan/screens/batchplanmapping.dart';
import '../customer_sales_record/screens/customer_info.dart';
import '../customer_sales_record/screens/sales_record.dart';
import '../infrastructure/screens/warehouse_details_screen.dart';
import '../infrastructure/screens/warehouse_section_line.dart';
import '../infrastructure/screens/warehouse_section_screen.dart';
import '../inventory/screens/inventory_batch_screen.dart';
import '../items/screens/inventory.dart';
import '../items/screens/inventory_adjustment.dart';
import '../main.dart';
import '../search_widget.dart';

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({Key? key}) : super(key: key);

  static const routeName = '/DashBoardScreen';

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  List<bool> _isOpen = [false];
  bool isOpened = false;
  List plantData = [];
  List planrData = [];

  var query = '';

  var plantName;

  bool isLoading = true;

  var firmName;

  @override
  void initState() {
    getFirmName().then((value) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<Apicalls>(context, listen: false)
            .getInventory(token, firmName)
            .then((value1) {});
      });
    });

    // Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
    //   var token = Provider.of<Apicalls>(context, listen: false).token;
    //   Provider.of<DashBoardApicalls>(context, listen: false)
    //       .getPlantDetails(token)
    //       .then((value1) {});
    // });
    super.initState();
  }

  Future<void> getFirmName() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('firmData')) {
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('firmData')!) as Map<String, dynamic>;
    plantName = extratedUserData['plantName'];
    firmName = extratedUserData['firmName'];
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    DashBoardApicalls.reload = true;

    return true; // return true if the route toNamed be popped
  }

  @override
  Widget build(BuildContext context) {
    plantData = Provider.of<Apicalls>(
      context,
    ).plantDetails;
    planrData = Provider.of<DashBoardApicalls>(
      context,
    ).plantDetails;
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(DashBoardDefaultScreen.routeName);
        return true;
      },
      child: Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Welcome'),
                    ],
                  ),
                ),
                const Divider(color: Colors.black),
                InfraManagement(),
                ItemsManagement(),
                EggCollectionManagement(),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ListTile(
                    title: const Text('Firm Plant Selection'),
                    trailing: const Icon(Icons.business),
                    onTap: () {
                      // html.window.open('http://localhost:53636/#/', '_self');
                      Provider.of<Apicalls>(context, listen: false)
                          .tryAutoLogin()
                          .then((value) {
                        if (value == true) {
                          var token =
                              Provider.of<Apicalls>(context, listen: false)
                                  .token;
                          Provider.of<Apicalls>(
                            context,
                            listen: false,
                          ).logOut(token);

                          Get.offAll(MyApp());
                          // Modular.toNamed.navigateAndRemoveUntil(MyHomePage.routeName,
                          //     (Route<dynamic> route) => false);
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ListTile(
                    title: const Text('Log Out'),
                    trailing: const Icon(Icons.business),
                    onTap: () {
                      // html.window.open('http://localhost:53636/#/', '_self');
                      Provider.of<Apicalls>(context, listen: false)
                          .tryAutoLogin()
                          .then((value) {
                        if (value == true) {
                          var token =
                              Provider.of<Apicalls>(context, listen: false)
                                  .token;
                          Provider.of<Apicalls>(
                            context,
                            listen: false,
                          ).logOut(token);

                          Get.offAll(MyApp());
                          // Modular.toNamed.navigateAndRemoveUntil(MyHomePage.routeName,
                          //     (Route<dynamic> route) => false);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: const Text('DashBoard Screen'),
            backgroundColor: Theme.of(context).backgroundColor,
            actions: [
              Container(
                  width: 216,
                  height: 36,
                  child: SearchWidget(
                      text: query, onChanged: (value) {}, hintText: 'Search')),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.notifications)),
              const SizedBox(
                width: 6,
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 43.0, top: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.offAllNamed(DashBoardDefaultScreen.routeName);
                      },
                      child: Text(
                        'Dashboard',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: const Color.fromRGBO(0, 0, 0, 1)),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_back_ios_new,
                      size: 15,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Inventory',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: const Color.fromRGBO(0, 0, 0, 0.5)),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Text(
                      'Farm Inventory',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 36),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 253,
                    child: InventorySearchWidget(
                      text: query,
                      onChanged: (value) {},
                      hintText: 'Search',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 66.0),
                    child: plantData.isEmpty
                        ? SizedBox()
                        : DataTable(
                            headingTextStyle: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Color.fromRGBO(0, 0, 0, 1),
                              ),
                            ),
                            columns: const <DataColumn>[
                                DataColumn(
                                    label: Text(
                                  'Farm Name',
                                  textAlign: TextAlign.left,
                                )),
                                DataColumn(label: Text('Total Birds')),
                                DataColumn(label: Text('Total Eggs')),
                              ],
                            rows: <DataRow>[
                                for (var data in plantData)
                                  // for(var data in displayData)
                                  DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        TextButton(
                                          onPressed: () async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            final userData = json.encode(
                                              {
                                                'plantName': data['Plant_Name'],
                                                'totalBirds':
                                                    data['Total_Birds'],
                                                'totalEggs': data['Total_Eggs']
                                              },
                                            );
                                            prefs.setString(
                                                'plantDetails', userData);

                                            Get.toNamed(
                                                InventoryBatchScreen.routeName);
                                          },
                                          child: Text(
                                            data['Plant_Name'],
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    68, 68, 68, 1),
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        data['Total_Birds'] == null
                                            ? const Text('0')
                                            : Text(
                                                data['Total_Birds'].toString(),
                                              ),
                                      ),
                                      DataCell(
                                        data['Total_Eggs'] == null
                                            ? const Text('0')
                                            : Text(
                                                data['Total_Eggs'].toString(),
                                              ),
                                      )
                                    ],
                                  ),
                              ]),
                  ),
                ),
              ],
            ),
          )

          // body: Center(
          //     child: Container(
          //   width: 500,
          //   height: 500,
          //   child: firmData.isEmpty
          //       ? Text('Loading')
          //       : ListView.builder(
          //           itemCount: firmData.length,
          //           itemBuilder: (BuildContext context, int index) {
          //             return ExpansionPanelList(
          //               children: [
          //                 ExpansionPanel(
          //                   headerBuilder: (context, isOpened) {
          //                     return Row(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: [
          //                         firmData.isEmpty
          //                             ? Text('Name')
          //                             : Text(firmData[index]['Firm_Name'])
          //                       ],
          //                     );
          //                   },
          //                   isExpanded: isOpened,
          //                   canTapOnHeader: true,
          //                   body: Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       ListView.builder(
          //                         physics: NeverScrollableScrollPhysics(),
          //                         shrinkWrap: true,
          //                         itemCount: planrData.length,
          //                         itemBuilder: (BuildContext context, int index) {
          //                           return ListTile(
          //                             title: Text(planrData[index]['Plant_Name']),
          //                             onTap: () {
          //                               //  Modular.toNamed.navigate(FirmDetailScreen.routeName);
          //                             },
          //                           );
          //                         },
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //               expansionCallback: (i, isOpen) => setState(
          //                 () {
          //                   isOpened = !isOpen;
          //                 },
          //               ),
          //             );
          //           },
          //         ),
          // )),
          ),
    );
  }
}

class InfraManagement extends StatefulWidget {
  InfraManagement({Key? key}) : super(key: key);

  @override
  _InfraManagementState createState() => _InfraManagementState();
}

class _InfraManagementState extends State<InfraManagement> {
  bool isOpened = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      children: [
        ExpansionPanel(
            headerBuilder: (context, isOpened) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Infrastructure Management'),
                ],
              );
            },
            isExpanded: isOpened,
            canTapOnHeader: true,
            body: Column(
              children: [
                // ListTile(
                //   title: const Text('Firm Details'),
                //   onTap: () {
                //     Modular.toNamed.navigate(FirmDetailScreen.routeName);
                //   },
                // ),
                // ListTile(
                //   title: const Text('Plant Details'),
                //   onTap: () {
                //     Modular.toNamed.navigate(PlantDetailsScreen.routeName);
                //   },
                // ),
                // ListTile(
                //   title: const Text('Ware House Category'),
                //   onTap: () {
                //     Modular.toNamed.navigate(WarehouseCategoryScreen.routeName);
                //   },
                // ),

                ListTile(
                  title: const Text('Ware House Details'),
                  onTap: () {
                    Get.toNamed(WareHouseDetailsScreen.routeName);
                    // Get.to(() => WareHouseDetailsScreen());
                  },
                ),
                // ListTile(
                //   title: const Text('Ware House Section'),
                //   onTap: () {
                //     Get.toNamed(WareHouseSectionScreen.routeName);
                //   },
                // ),
                ListTile(
                  title: const Text('Ware House Section Line'),
                  onTap: () {
                    Get.toNamed(WarehouseSectionLine.routeName);
                  },
                ),
              ],
            ))
      ],
      expansionCallback: (i, isOpen) => setState(
        () {
          isOpened = !isOpen;
        },
      ),
    );
  }
}

class AdminManagement extends StatefulWidget {
  AdminManagement({Key? key}) : super(key: key);

  @override
  _AdminManagementState createState() => _AdminManagementState();
}

class _AdminManagementState extends State<AdminManagement> {
  bool isOpened = false;

  EdgeInsetsGeometry getpadding() {
    return const EdgeInsets.only(left: 32.0);
  }

  @override
  Widget build(BuildContext context) {
    final expansionHeaderTheme = Theme.of(context).textTheme.headline6;
    final expansionDataTheme = Theme.of(context).textTheme.headline5;
    return ExpansionTile(
      onExpansionChanged: (value) {
        setState(() {
          isOpened = value;
        });
      },
      trailing: SizedBox(),
      title: Row(
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
            style: expansionHeaderTheme,
          ),
          const SizedBox(
            width: 10,
          ),
          isOpened == false
              ? const Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(159, 205, 255, 1),
                  size: 16,
                )
              : const Icon(
                  Icons.arrow_drop_up,
                  color: Color.fromRGBO(159, 205, 255, 1),
                  size: 16,
                ),
        ],
      ),
      // dividerColor: Colors.transparent,
      // elevation: 0,
      children: [
        Padding(
          padding: getpadding(),
          child: ListTile(
            title: Text(
              'Firm',
              style: expansionDataTheme,
            ),
            onTap: () {
              Get.offNamed(DashBoardDefaultScreen.routeName, arguments: 0);
            },
          ),
        ),
        // Padding(
        //   padding: getpadding(),
        //   child: ListTile(
        //     title: Text(
        //       'Users',
        //       style: expansionDataTheme,
        //     ),
        //     onTap: () {
        //       Get.offNamed(DashBoardDefaultScreen.routeName, arguments: 1);
        //     },
        //   ),
        // ),
        Padding(
          padding: getpadding(),
          child: ListTile(
            title: Text(
              'Warehouse Management',
              style: expansionDataTheme,
            ),
            onTap: () {
              Get.offNamed(DashBoardDefaultScreen.routeName, arguments: 1);
            },
          ),
        ),
        Padding(
          padding: getpadding(),
          child: ListTile(
            title: Text(
              'Reference Data',
              style: expansionDataTheme,
            ),
            onTap: () {
              Get.offNamed(DashBoardDefaultScreen.routeName, arguments: 2);
            },
          ),
        ),
        // Padding(
        //   padding: getpadding(),
        //   child: ListTile(
        //     title: Text(
        //       'User Roles',
        //       style: expansionDataTheme,
        //     ),
        //     onTap: () {
        //       Get.toNamed(UserRoles.routeName);
        //     },
        //   ),
        // ),
        // Padding(
        //   padding: getpadding(),
        //   child: ListTile(
        //     title: Text(
        //       'Firm Details',
        //       style: expansionDataTheme,
        //     ),
        //     onTap: () {
        //       Get.toNamed(FirmDetailScreen.routeName);
        //     },
        //   ),
        // ),
        // Padding(
        //   padding: getpadding(),
        //   child: ListTile(
        //     title: Text(
        //       'Plant Details',
        //       style: expansionDataTheme,
        //     ),
        //     onTap: () {
        //       Get.toNamed(PlantDetailsScreen.routeName);
        //     },
        //   ),
        // ),
        // Padding(
        //   padding: getpadding(),
        //   child: ListTile(
        //     title: Text(
        //       'Ware House Category',
        //       style: expansionDataTheme,
        //     ),
        //     onTap: () {
        //       Get.toNamed(WarehouseSubCategoryScreen.routeName);
        //     },
        //   ),
        // ),
        // ListTile(
        //   title: const Text('Ware House Section'),
        //   onTap: () {
        //     Get.toNamed(WareHouseSectionScreen.routeName);
        //   },
        // ),
        // ListTile(
        //   title: const Text('Ware House Section Line'),
        //   onTap: () {
        //     Get.toNamed(WarehouseSectionLine.routeName);
        //   },
        // ),
      ],

      // expansionCallback: (i, isOpen) {
      //   setState(
      //     () {
      //       isOpened = !isOpen;
      //     },
      //   );
      // }
    );
  }
}

class ItemsManagement extends StatefulWidget {
  ItemsManagement({Key? key}) : super(key: key);

  @override
  _ItemsManagementState createState() => _ItemsManagementState();
}

class _ItemsManagementState extends State<ItemsManagement> {
  bool isOpened = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
        children: [
          ExpansionPanel(
              headerBuilder: (context, isOpened) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Items Management'),
                  ],
                );
              },
              isExpanded: isOpened,
              canTapOnHeader: true,
              body: Column(
                children: [
                  // ListTile(
                  //   title: const Text('Item Category'),
                  //   onTap: () {
                  //     Modular.toNamed.navigate(ItemCategory.routeName);
                  //   },
                  // ),
                  // ListTile(
                  //   title: const Text('Item Sub-Category'),
                  //   onTap: () {
                  //     Modular.toNamed.navigate(ItemSubCategory.routeName);
                  //   },
                  // ),

                  ListTile(
                    title: const Text('Inventory'),
                    onTap: () {
                      Get.toNamed(Inventory.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text('Inventory Adjustment'),
                    onTap: () {
                      Get.toNamed(InventoryAdjustment.routeName);
                    },
                  ),
                ],
              ))
        ],
        expansionCallback: (i, isOpen) {
          setState(
            () {
              isOpened = !isOpen;
            },
          );
        });
  }
}

class BatchPlanManagemnt extends StatefulWidget {
  BatchPlanManagemnt({Key? key}) : super(key: key);

  @override
  _BatchPlanManagemntState createState() => _BatchPlanManagemntState();
}

class _BatchPlanManagemntState extends State<BatchPlanManagemnt> {
  bool isOpened = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme.headline6;
    final expansionDataTheme = Theme.of(context).textTheme.headline5;
    return ExpansionPanelList(
        dividerColor: Colors.transparent,
        elevation: 0,
        children: [
          ExpansionPanel(
              backgroundColor: Theme.of(context).backgroundColor,
              headerBuilder: (context, isOpened) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Batch Plan',
                      style: theme,
                    ),
                  ],
                );
              },
              isExpanded: isOpened,
              canTapOnHeader: true,
              body: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Batch Plan Mapping',
                      style: expansionDataTheme,
                    ),
                    onTap: () {
                      Get.toNamed(BatchPlanMapping.routeName);
                    },
                  ),
                ],
              ))
        ],
        expansionCallback: (i, isOpen) {
          setState(
            () {
              isOpened = !isOpen;
            },
          );
        });
  }
}

class RecordsManagement extends StatefulWidget {
  RecordsManagement({Key? key}) : super(key: key);

  @override
  _RecordsManagementState createState() => _RecordsManagementState();
}

class _RecordsManagementState extends State<RecordsManagement> {
  bool isOpened = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme.headline6;
    final expansionDataTheme = Theme.of(context).textTheme.headline5;
    return ExpansionPanelList(
        dividerColor: Colors.transparent,
        elevation: 0,
        children: [
          ExpansionPanel(
              backgroundColor: Theme.of(context).backgroundColor,
              headerBuilder: (context, isOpened) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Records',
                      style: theme,
                    ),
                  ],
                );
              },
              isExpanded: isOpened,
              canTapOnHeader: true,
              body: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Customer Info',
                      style: expansionDataTheme,
                    ),
                    onTap: () {
                      Get.toNamed(CustomerInfo.routeName);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'sales Record',
                      style: expansionDataTheme,
                    ),
                    onTap: () {
                      Get.toNamed(SalesRecord.routeName);
                    },
                  ),
                ],
              ))
        ],
        expansionCallback: (i, isOpen) {
          setState(
            () {
              isOpened = !isOpen;
            },
          );
        });
  }
}

class JournalManagement extends StatefulWidget {
  JournalManagement({Key? key}) : super(key: key);

  @override
  _JournalManagementState createState() => _JournalManagementState();
}

class _JournalManagementState extends State<JournalManagement> {
  bool isOpened = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme.headline6;
    final expansionDataTheme = Theme.of(context).textTheme.headline5;
    return ExpansionPanelList(
        dividerColor: Colors.transparent,
        elevation: 0,
        children: [
          ExpansionPanel(
              backgroundColor: Theme.of(context).backgroundColor,
              headerBuilder: (context, isOpened) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Journal',
                      style: theme,
                    ),
                  ],
                );
              },
              isExpanded: isOpened,
              canTapOnHeader: true,
              body: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Transfer Journal',
                      style: expansionDataTheme,
                    ),
                    onTap: () {
                      // Get.toNamed(TransferJournalData.routeName);
                    },
                  ),
                ],
              ))
        ],
        expansionCallback: (i, isOpen) {
          setState(
            () {
              isOpened = !isOpen;
            },
          );
        });
  }
}
